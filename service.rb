#!/usr/bin/env ruby

require "google/protobuf"
require "rack"
require "twirp"
require "webrick"
require "./spec/support/hello_world"

server = WEBrick::HTTPServer.new(Port: 3000)

handler = HelloWorldHandler.new
service = HelloWorldService.new(handler)
path_prefix = "/twirp/" + service.full_name
server.mount path_prefix, Rack::Handler::WEBrick, service

handler = GoodbyeHandler.new
service = GoodbyeService.new(handler)
path_prefix = "/twirp/" + service.full_name
server.mount path_prefix, Rack::Handler::WEBrick, service

server.start

# client = HelloWorldClient.new("http://localhost:3000/twirp")
# client = GoodbyeClient.new("http://localhost:3000/twirp")
# resp = client.hello(name: "World")
# puts resp.data
