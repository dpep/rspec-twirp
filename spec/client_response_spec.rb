describe "be_a_twirp_client_response" do
  context "with a response" do
    subject { Twirp::ClientResp.new(GoodbyeResponse.new, nil) }

    it { is_expected.to be_a_twirp_client_response }

    it "catches non-twirp response" do
      expect {
        expect(Object).to be_a_twirp_client_response
      }.to fail_with /found Object/
    end

    it "matches a specific response type" do
      is_expected.to be_a_twirp_client_response(GoodbyeResponse)
    end

    it "catches type mismatches" do
      expect {
        is_expected.to be_a_twirp_client_response(HelloResponse)
      }.to fail_with /of type HelloResponse/
    end

    it "catches erroneous response types" do
      expect {
        is_expected.to be_a_twirp_client_response(Object)
      }.to raise_error(ArgumentError, /Object/)
    end

    context "with attributes" do
      subject { Twirp::ClientResp.new(GoodbyeResponse.new(**attrs), nil) }

      let(:attrs) { { message: "bye", name: "Bob" } }

      it "can match attributes" do
        is_expected.to be_a_twirp_client_response(GoodbyeResponse, **attrs)
      end

      it "supports regex matches" do
        is_expected.to be_a_twirp_client_response(name: /^B/)
      end

      it "catches mismatches" do
        expect {
          is_expected.to be_a_twirp_client_response(name: "nope")
        }.to fail_with /to have name: "nope"/

        expect {
          is_expected.to be_a_twirp_client_response(name: /no/)
        }.to fail_with /to have name: \/no\//
      end

      it "catches the erroneous attributes" do
        expect {
          is_expected.to be_a_twirp_client_response(namezzz: "Bob")
        }.to raise_error(ArgumentError, /namezzz/)
      end

      it "catches type mismatches" do
        expect {
          is_expected.to be_a_twirp_client_response(name: 123)
        }.to raise_error(TypeError, /string field.*given Integer/)
      end
    end
  end

  context "with error" do
    subject { Twirp::ClientResp.new(nil, error) }

    let(:error) { Twirp::Error.new(code, msg, meta) }
    let(:code) { :not_found }
    let(:msg) { "Not Found" }
    let(:meta) { { is_meta: "true" } }

    it { is_expected.to be_a_twirp_client_response.with_error }
    it { is_expected.to be_a_twirp_client_response.with_error(code) }
    it { is_expected.to be_a_twirp_client_response.with_error(msg) }
    it { is_expected.to be_a_twirp_client_response.with_error(**meta) }
    it { is_expected.to be_a_twirp_client_response.with_error(/Not/) }

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_client_response.with_error(:internal)
      }.to fail_with /code: :internal/
    end
  end

  context "with neither response nor error" do
    subject { Twirp::ClientResp.new(nil, nil) }

    it "fails the response match" do
      expect {
        is_expected.to be_a_twirp_client_response
      }.to fail_with /to have data/
    end

    it "fails the error match" do
      expect {
        is_expected.to be_a_twirp_client_response.with_error
      }.to fail_with /to have an error/
    end
  end

  context "with both response and error" do
    subject { Twirp::ClientResp.new(GoodbyeResponse.new, Twirp::Error.not_found("Not Found")) }

    it "fails" do
      expect {
        is_expected.to be_a_twirp_client_response(name: "Bob").with_error
      }.to raise_error(ArgumentError, /but not both/)
    end
  end
end
