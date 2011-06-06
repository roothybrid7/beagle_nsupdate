# coding: utf-8

module BeagleNsupdate
  class Record
    include Enumerable
    extend ActiveModel::Naming
    extend ActiveModel::Callbacks
    include ActiveModel::AttributeMethods
    include ActiveModel::Conversion
    include ActiveModel::Dirty
    include ActiveModel::Validations
#    include ActiveModel::Serialization

    class << self
      attr_accessor :group, :servers, :master, :errors

      def group=(group)
        @connection, @group = nil, group
      end

      def servers=(servers)
        @connection = nil
        @servers = servers
      end

      def master=(master)
        @connection, @master = nil, master
      end

      def connection(operator, refresh=false)
        @connection = Connection.new(operator) if refresh || @connection.nil?
        @connection.servers = servers.map {|server| server.host } if servers
        @connection.server = master.host
        @connection.port = group.port || master.port
        @connection.tsig = group.tsig_key_name, group.tsig_key_value
        @connection
      end

      # AFXR
      def all(zone)
        return nil unless prepare(zone)

        begin
          result = connection(Dnsruby::ZoneTransfer).transfer(zone)
          instantiate_collection(result)
        rescue => e
          Rails.logger.error(e.message)
          Rails.logger.debug(e.pretty_inspect)
          err_obj = self.new.tap do |obj|
            obj.errors['base'] = e.message
            self.errors = obj.errors
          end

          []
        end
      end

      def where(zone, params={})
        result = all(zone)

        return result if params.empty?

        if params[:type] && params[:type] != 'ANY'
          result = result.select do |rec|
            rec.type.to_s == params[:type]
          end
        end

        if params[:name]
          result = result.select do |rec|
            rec.name.to_s =~ /#{params[:name]}/
          end
        end

        result
      end

      def destroy_all(zone, records)
        return nil unless prepare(zone)

        begin
          connection(Dnsruby::Resolver, true).tap {|conn|
            conn.attributes = @@def_attributes
            conn.zone = zone
          }.delete_all(records)
        rescue => e
          Rails.logger.error(e.message)
          Rails.logger.debug(e.pretty_inspect)
          nil
        end
      end

      # Query
      # recordset, type
      def query(*args)
      end

      protected

      def instantiate_collection(collection)
        collection.map! {|record| instantiate_record(record) }
      end

      def instantiate_record(record)
        self.new.import_record(record)
      end

      private

      def prepare(zone)
        return nil if zone.group.nil? && zone.group.servers.empty?

        self.group = zone.group
        self.servers = group.servers

        if masters = servers.select {|s| s.is_master == true }
          self.master = masters.first
        else
          self.master = servers.first
        end
      end
    end
    # domain rrset: <name:object> <ttl:int> <klass:str> <type:str> <rdata:object OR array>
    #   name:  Dnsruby::Name: (variable length)
    #   ttl:   Fixnum(32bits: 4bytes)
    #   klass: Dnsruby::Classes(IN)(16bits: 2bytes)
    #   type:  Dnsruby::Types(SOA, NS, MX, A, CNAME, PTR)(16bits: 2bytes)
    #   rdata: Array, Dnsruby::Name OR Dnsruby::IPv4(variable length)
    # A record: rdata = @addresss
    #   foo.example.com. 10 IN A 1.2.3.4
    # CNAME record: rdata = @domainname
    #   bar.example.com. 120 IN CNAME foo.example.com.
    # PTR record: rdata = @domainname
    #   100.1.168.192.in-addr.arpa. 10 IN PTR buz-ptr.example.com.
    # NS Record: rdata = @domainname
    #   example.com. 10 IN NS dns.example.com.
    # SOA Record: rdata = Array:[mname, rname, serial, refresh, retry, expire, minimum]
    #   example.com. 10 IN SOA dns.example.com. root.example.com. 1970010102 20 2 86400 60
    # MX Record: rdata = Array:[preference, exchange]
    #   example.com. 10 IN MX 10 mail.example.com.

    attribute_method_affix :prefix => 'clear_', :suffix => '!'

    @@def_attributes = [:name, :ttl, :klass, :type, :rdata]
    define_attribute_methods @@def_attributes
    @@def_attributes.each {|attr| attr_accessor attr }
    attr_reader :id

    validates_presence_of :name
    validates_numericality_of :ttl, :greater_than => 1, :only_integer => true, :allow_nil => true

    def clear_attribute!(attr)
      send("#{attr}=", nil)
    end

#    def attributes
#      if @attributes.nil?
#        alist = @@def_attributes.zip([].fill(0,@@def_attributes.size) { nil })
#        Rails.logger.debug(Hash[*alist.flatten].inspect)
#        @attributes ||= Hash[*alist.flatten]
#      else
#        @attributes
#      end
#    end

    def initialize(attrs={})
      attrs.each do |name, value|
        send("#{name}=", value)
      end

      yield self if block_given?
      self
    end

    def import_record(record)
      # Model attributes
      hash_seed = @@def_attributes.inject("") do |seed, attr|
        send("#{attr}=", record.send(attr))
        tmp_str = send(attr).is_a?(Array) ? send(attr).map {|x| "#{x}" }.join : "#{send(attr)}"
        seed << tmp_str
      end
      @@msg_digest ||= BeagleNsupdate::Application.config.message_digest_algorithm
      @id = Digest::const_get(@@msg_digest.to_s.upcase).hexdigest(hash_seed)

      extends(record)   # Delegate dnsruby

      yield self if block_given?
      self
    end

    # name, type, ttl, rdata
    def save(zone)
      self.name << ".#{zone.name}." unless self.name.match(/#{zone.name}$/)   # complement zone

      connection(Dnsruby::Resolver, true).tap {|conn|
        conn.subject = self
        conn.attributes = @@def_attributes
        conn.zone = zone
      }.add

      true
    rescue => e
      self.errors['base'] = e.message
      Rails.logger.error("Record#save: #{e.message}")
      Rails.logger.debug(e.inspect)
      false
    end

    # name, type, rdata
    def destroy(zone)
      connection(Dnsruby::Resolver, true).tap {|conn|
        conn.subject = self
        conn.attributes = @@def_attributes
        conn.zone = zone
      }.delete

      true
    rescue => e
      self.errors['base'] = e.message
      Rails.logger.error("Record#destroy: #{e.message}")
      Rails.logger.debug(e.inspect)
      false
    end

    def where(zone, params)
      self.class.where(zone, params)
    end

    def each
    end

    def persisted?
      false
    end

    protected

    # Delegate Dnsruby
    def extends(prototype)
      instance_variable_set("@__proto__", prototype)
      def self.method_missing(message, *args)
        @__proto__.send(message, *args)
      end
      return self
    end

    def connection(operator, refresh=false)
      self.class.connection(operator, refresh)
    end
  end
end
