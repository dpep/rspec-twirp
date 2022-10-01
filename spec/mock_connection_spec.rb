describe :mock_twirp_connection do
  subject { client.bye(request) }

  let(:client) { GoodbyeClient.new(conn) }
  let(:request) { GoodbyeRequest.new }
  let(:response) { GoodbyeResponse.new(**response_attrs) }
  let(:response_attrs) { { message: "bye" } }

  context "without a mock" do
    let(:conn) { "http://localhost:3000/twirp/Goodbye/Bye" }

    it { expect { subject }.to raise_error(Faraday::ConnectionFailed) }
  end

  describe "with a response instance" do
    let(:conn) { mock_twirp_connection(response) }

    it { is_expected.to be_a(Twirp::ClientResp) }
    it { is_expected.to be_a_twirp_response }
    it { is_expected.to be_a_twirp_response(response) }
    it { is_expected.to be_a_twirp_response(message: "bye") }

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_response(message: "nope")
      }.to fail
    end
  end

  describe "with a response type" do
    let(:conn) { mock_twirp_connection(GoodbyeResponse) }

    it { is_expected.to be_a_twirp_response(GoodbyeResponse) }

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_response(HelloResponse)
      }.to fail
    end
  end

  describe "with default response" do
    let(:conn) { mock_twirp_connection }

    it { is_expected.to be_a_twirp_response(GoodbyeResponse) }

    context "and with attrs" do
      let(:conn) { mock_twirp_connection(message: "adios") }

      it { is_expected.to be_a_twirp_response(message: "adios") }
    end
  end

  describe "with an error" do
    let(:conn) { mock_twirp_connection(error) }
    let(:error) { Twirp::Error.not_found("nope") }

    it { is_expected.to be_a_twirp_response.with_error(error) }

    context "when error is symbol" do
      let(:error) { :not_found }

      it { is_expected.to be_a_twirp_response.with_error(404) }
      it { is_expected.to be_a_twirp_response.with_error(:not_found) }
    end

    context "when error is integer" do
      let(:error) { 500 }

      it { is_expected.to be_a_twirp_response.with_error(500) }
      it { is_expected.to be_a_twirp_response.with_error(:internal) }
    end
  end

  describe "with a block" do
    context "with a response object" do
      let(:conn) { mock_twirp_connection { response } }

      it { is_expected.to be_a_twirp_response(response) }
    end

    context "with response attrs" do
      let(:conn) { mock_twirp_connection { response_attrs } }

      it "determines the correct response type and incorporates the attrs" do
        is_expected.to be_a_twirp_response(GoodbyeResponse, **response_attrs)
      end
    end

    context "with error" do
      let(:conn) { mock_twirp_connection { error } }
      let(:error) { Twirp::Error.not_found("nope") }

      it { is_expected.to be_a_twirp_response.with_error(error) }
    end

    context "with error code" do
      let(:conn) { mock_twirp_connection { :not_found } }

      it { is_expected.to be_a_twirp_response.with_error(:not_found) }
    end
  end
end
