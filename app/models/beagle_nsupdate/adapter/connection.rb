# coding: utf-8

module BeagleNsupdate
  class Connection
    @operators = [Dnsruby::ZoneTransfer, Dnsruby::Resolver]

    class << self
      attr_accessor :operators
    end

    attr_accessor :subject, :zone
    attr_writer :attributes
    attr_reader :operator, :update, :servers, :server, :port, :tsig

    def initialize(operator)
      unless self.class.operators.include?(operator)
        raise ArgumentError, "Invalid Operator: #{operator} in #{self.class.operators.join(',')}"
      end
        self.operator = operator

        yield self if block_given?
        self
    end

    def operator=(operator)
      @operator = operator
    end

    def servers=(servers)
      @servers = servers
    end

    def server=(server)
      @server = server
    end

    def port=(port)
      @port = port
    end

    def tsig=(tsig)
      @tsig = tsig
    end

    def transfer(zone)
      operator.new.tap {|oper|
        oper.server = server
        oper.port = port || 53
        oper.tsig = tsig if tsig
      }.transfer(zone.name)
    end

    def delete_all(records)
      self.update = zone

      records.each do |rec|
        name = "#{rec.name}"
        type = "#{rec.type}"
        rdata = "#{parse_rdata(rec.rdata)}"

        update.delete(name, type, rdata)
      end

      begin
        resolver(server).send_message(update)
      rescue => e
        Rails.logger.error("Connection#delete_all: #{e.message}")
        Rails.logger.debug(e.inspect)
        raise
      end
    end

    def add_all(records)
      self.update = zone

      records.each do |rec|
        name = "#{rec.name}"
        type = "#{rec.type}"
        ttl = "#{rec.ttl}"
        rdata = "#{parse_rdata(rec.rdata)}"

        update.add(name, type, ttl, rdata)
      end

      begin
        resolver(server).send_message(update)
      rescue => e
        Rails.logger.error("Connection#add_all: #{e.message}")
        Rails.logger.debug(e.inspect)
        raise
      end
    end

    def delete
      self.update = zone

      name = "#{subject.name}"
      type = "#{subject.type}"
      rdata = "#{parse_rdata(subject.rdata)}"

      update.delete(name, type, rdata)

      begin
        resolver(server).send_message(update)
      rescue => e
        Rails.logger.error("Connection#delete: #{e.message}")
        Rails.logger.debug(e.inspect)
        raise
      end
    end

    def add
      self.update = zone

      name = "#{subject.name}"
      type = "#{subject.type}"
      ttl = "#{subject.ttl}"
      rdata = "#{parse_rdata(subject.rdata)}"

      update.add(name, type, ttl, rdata)

      begin
        resolver(server).send_message(update)
      rescue => e
        Rails.logger.error("Connection#add: #{e.message}")
        Rails.logger.debug(e.inspect)
        raise
      end
    end

    protected

    def update=(zone)
      @update = Dnsruby::Update.new(zone.name)
    end

    def resolver(server)
      if server.is_a?(Array)
        operator.new(:nameservers => server, :port => port || 53).tap do |oper|
          oper.tsig = tsig if tsig
        end
      else
        operator.new(:nameserver => server, :port => port || 53).tap do |oper|
          oper.tsig = tsig if tsig
        end
      end
    end

    private

    def parse_rdata(rdata)
      if rdata.is_a?(Array)
        rdata.map {|d| "#{d}" }.join(' ')
      else
        "#{rdata}"
      end
    end
  end
end
