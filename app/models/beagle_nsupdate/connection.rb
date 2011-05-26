# coding: utf-8

module BeagleNsupdate
  class Connection
    OPERATORS = [Dnsruby::ZoneTransfer, Dnsruby::Resolver]
    attr_accessor :subject, :zone
    attr_writer :attributes
    attr_reader :operator, :update, :servers, :server, :port, :tsig

    def initialize(operator)
      unless OPERATORS.include?(operator)
        raise ArgumentError, "Invalid Operator: #{operator} in #{OPERATORS.join(',')}"
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

      resolver_request(update)
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

      resolver_request(update)
    end

    def delete
      raise ArgumentError, subject.errors unless subject.valid?

      self.update = zone

      name = "#{subject.name}"
      type = "#{subject.type}"
      rdata = "#{parse_rdata(subject.rdata)}"

      update.delete(name, type, rdata)

      resolver_request(update)
    end

    def add
      raise ArgumentError, subject.errors unless subject.valid?

      self.update = zone

      name = "#{subject.name}"
      type = "#{subject.type}"
      ttl = "#{subject.ttl}"
      rdata = "#{parse_rdata(subject.rdata)}"

      update.add(name, type, ttl, rdata)

      resolver_request(update)
    end

    protected

    def update=(zone)
      @update = Dnsruby::Update.new(zone.name)
    end

    def resolver_request(update)
      begin
        operator.new(:nameservers => servers, :port => port || 53).tap {|oper|
          oper.tsig = tsig if tsig
        }.send_message(update)
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.debug(e.inspect)
        raise
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
