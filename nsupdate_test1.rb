#!/usr/bin/env ruby
# coding: utf-8

require 'pp'
require 'rubygems'
require 'dnsruby'

# Nsupdate(destroy, save(create, update))
res = Dnsruby::Resolver.new(:nameservers => ["175.41.224.74"], :port => "55153").tap do |r|
  r.tsig = "nsupdate.example.com.", "WImSObCU+ClK7Ol8wWSDo6AkeR6kBtGp8CUPSBpKBSc1yA2ODpcye7vryKzIMqBjELzRsHjWJACyfgs+b7qUnA=="
end

# nsupdate
update = Dnsruby::Update.new("nsupdate.example.com").tap do |up|
  up.delete("foo4.nsupdate.example.com")
  up.add("foo4.nsupdate.example.com", "A", 7200, "4.4.4.4")
end

#update.delete("foo4.nsupdate.example.com")
#update.add("foo4.nsupdate.example.com", "A", 7200, "4.4.4.4")

begin
puts "Send message"
pp  reply = res.send_message(update)
rescue => e
STDERR.puts "Ocurring Error"
p e.message
  pp e
end

