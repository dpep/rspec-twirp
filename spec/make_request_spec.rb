describe "make_twirp_request" do
  let(:client) { HelloWorldClient.new(conn) }
  let(:conn) { mock_twirp_connection("/HelloWorld/Hello", HelloResponse.new) }
  let!(:other_client) { HelloWorldClient.new(conn) }
  let(:request) { HelloRequest.new(name: "World", count: 3) }

  def hello
    client.hello(request)
  end

  it { expect { hello }.to make_twirp_request }

  context "with client instance matcher" do
    it "matches a client instance" do
      expect { hello }.to make_twirp_request(client)
    end

    it "matches a pre-existing client instance" do
      expect {
        other_client.hello(HelloRequest.new)
      }.to make_twirp_request(other_client)
    end

    it "catches client mismaches" do
      expect {
        expect { hello }.to make_twirp_request(other_client)
      }.to fail
    end
  end

  context "with client class matcher" do
    it "matches a client class" do
      expect { hello }.to make_twirp_request(HelloWorldClient)
    end

    it "matches subclasses" do
      expect { hello }.to make_twirp_request(Twirp::Client)
    end

    it "catches mismatches" do
      expect {
        expect { hello }.to make_twirp_request(GoodbyeClient)
      }.to fail
    end

    xit "catches type errors" do
      expect {
        expect { hello }.to make_twirp_request(Object)
      }.to raise_error(TypeError)
    end
  end

  context "with rpc name matcher" do
    it { expect { hello }.to make_twirp_request(:Hello) }
    it { expect { hello }.to make_twirp_request("Hello") }
    it { expect { hello }.to make_twirp_request(/^He/) }

    it "catches mismatches" do
      expect {
        expect { hello }.to make_twirp_request(:Bye)
      }.to fail

      expect {
        expect { hello }.to make_twirp_request(/B/)
      }.to fail
    end
  end

  context "with input matcher" do
    it "matches messages" do
      expect { hello }.to make_twirp_request.with(request)
    end

    it "matches message type" do
      expect { hello }.to make_twirp_request.with(HelloRequest)
    end

    it "matches with attrs" do
      expect { hello }.to make_twirp_request.with(count: 3)
    end

    context "with json request" do
      it "matches messages" do
        expect {
          client.hello(name: "World")
        }.to make_twirp_request.with(HelloRequest.new(name: "World"))
      end

      it "matches attrs" do
        expect {
          client.hello(name: "World")
        }.to make_twirp_request.with(name: "World")
      end
    end

    it "catches mismatches" do
      expect {
        expect { hello }.to make_twirp_request.with(count: 1)
      }.to fail
    end
  end

  context "with service matcher" do
    it { expect { hello }.to make_twirp_request(HelloWorldService) }

    it "catches mismatches" do
      expect {
        expect { hello }.to make_twirp_request(GoodbyeService)
      }.to fail
    end
  end

  # it "matches a rpc call" do
  #   expect(client).to make_twirp_request
  #   client.hello(HelloRequest.new)
  # end

  # it "matches a specific rpc method" do
  #   expect(client).to make_twirp_request(:hello)
  #   client.hello(HelloRequest.new)
  # end

  # it "matches a specific rpc method by rpc name" do
  #   expect(client).to make_twirp_request(:Hello)
  #   client.hello(HelloRequest.new)
  # end

  # describe ".with" do
  #   let(:request) { HelloRequest.new(name: "Daniel") }

  #   it "matches the request message" do
  #     expect(client).to make_twirp_request(:hello).with(request)
  #     client.hello(request)
  #   end

  #   it "matches the request arguments" do
  #     expect(client).to make_twirp_request(:hello).with(name: "Daniel")
  #     client.hello(request)
  #   end

  #   it "matches when the request is made with arguments" do
  #     expect(client).to make_twirp_request(:hello).with(request)
  #     client.hello(name: "Daniel")
  #   end

  #   it "catches erroneous request types" do
  #     expect {
  #       expect(client).to make_twirp_request(:hello).with(GoodbyeRequest.new)
  #     }.to raise_error(TypeError, /found GoodbyeRequest/)
  #   end

  #   it "catches mismatches" do
  #     allow(client).to receive(:rpc)
  #     client.hello(name: "Bob")
  #     expect(client).to make_twirp_request(:hello, have_received: true).with(request)
  #   end
  # end

  # context "with a response" do
  #   subject { Twirp::ClientResp.new(GoodbyeResponse.new, nil) }

  #   it { is_expected.to be_a_twirp_response }

  # end
end
