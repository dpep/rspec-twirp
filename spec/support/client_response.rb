def client_response(data: nil, body: nil, error: nil)
  if Gem::Version.new(Twirp::VERSION) < Gem::Version.new("1.10")
    Twirp::ClientResp.new(data, error)
  else
    Twirp::ClientResp.new(data: data, body: body, error: error)
  end
end
