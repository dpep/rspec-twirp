#!/usr/bin/env ruby

require "google/protobuf"
require "rack"
require "twirp"
require "webrick"
require "./spec/support/hello_world"

handler = HelloWorldHandler.new
service = HelloWorldService.new(handler)

path_prefix = "/twirp/" + service.full_name
server = WEBrick::HTTPServer.new(Port: 3000)
server.mount path_prefix, Rack::Handler::WEBrick, service
server.start

# client = HelloWorldClient.new("http://localhost:3000/twirp")
# resp = client.hello(name: "World")
# puts resp.data
