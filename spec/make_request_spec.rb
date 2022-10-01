describe "make_twirp_request" do
  let(:client) { HelloWorldClient.new(conn) }
  let(:conn) { mock_twirp_connection("/HelloWorld/Hello", response) }
  let!(:other_client) { HelloWorldClient.new(conn) }
  let(:request) { HelloRequest.new(name: "World", count: 3) }
  let(:response) { HelloResponse.new(message: ["Hello", "Hello", "Hello World"]) }

  def hello
    client.hello(request)
  end

  describe "block mode" do
    it { expect { hello }.to make_twirp_request }

    it "returns nil" do
      expect {
        expect(hello).to be_nil
      }.to make_twirp_request
    end

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

      it "catches type errors" do
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

    describe ".and_call_original" do
      it "calls original" do
        expect {
          expect(hello).to be_a_twirp_response(response)
        }.to make_twirp_request.and_call_original
      end
    end

    describe ".and_return" do
      it "returns the specified value" do
        expect {
          expect(hello).to be_a_twirp_response(HelloRequest.new)
        }.to make_twirp_request.and_return(HelloRequest.new)
      end

      it "returns the specified value" do
        expect {
          expect(hello).to be_a_twirp_response(HelloRequest.new)
        }.to make_twirp_request.and_return(HelloRequest)
      end
    end
  end

  describe "inline mode" do
    after { hello }

    it { expect(client).to make_twirp_request }

    it "matches a specific rpc method" do
      expect(client).to make_twirp_request(:hello)
    end

    it "matches a specific rpc method by rpc name" do
      expect(client).to make_twirp_request(:Hello)
    end

    describe ".with" do
      let(:request) { HelloRequest.new(name: "Daniel") }

      it "matches the request message" do
        expect(client).to make_twirp_request(:hello).with(request)
      end

      it "matches the request arguments" do
        expect(client).to make_twirp_request(:hello).with(name: "Daniel")
      end
    end
  end
end
