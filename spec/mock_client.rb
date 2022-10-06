describe "mock_twirp_client" do
  subject(:client) { mock_twirp_client(client_class, **responses) }

  let(:client_class) { GoodbyeClient }
  let(:responses) { {} }
  let(:request) { GoodbyeRequest.new(name: "Alfred") }
  let(:res) { client.bye(request) }

  it { is_expected.to be_a(Twirp::Client) }
  it { is_expected.to be_a(client_class) }

  it "packes response" do
    expect(res).to be_a(Twirp::ClientResp)
  end

  context "when responses arg is empty" do
    it "returns the default response" do
      expect(res).to be_a_twirp_response(GoodbyeResponse.new)
    end
  end

  context "when responses arg is specified" do
    let(:responses) { { bye: request } }

    it { expect(res).to be_a_twirp_response(name: /Alf/) }

    it "raises when unstubbed methods are called" do
      expect {
        client.goodbye(request)
      }.to raise_error(RSpec::Mocks::MockExpectationError)
    end
  end

  context "when responses attributes are specified" do
    let(:responses) { { bye: { message: "adios" } } }

    it { expect(res).to be_a_twirp_response(message: "adios") }
  end

  context "bogus methods are stubbed" do
    let(:responses) { { foo: "nope" } }

    it { expect { client }.to raise_error(ArgumentError) }
  end
end
