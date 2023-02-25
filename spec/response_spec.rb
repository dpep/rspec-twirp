describe "be_a_twirp_response" do
  context "with a response" do
    subject { Twirp::ClientResp.new(data: response) }

    let(:response) { GoodbyeResponse.new }

    it { is_expected.to be_a_twirp_response }

    it "handles non-twirp response" do
      expect(Object).not_to be_a_twirp_response
    end

    context "with attributes" do
      let(:response) { GoodbyeResponse.new(**attrs) }
      let(:attrs) { { message: "bye", name: "Bob" } }

      it "can match attributes" do
        is_expected.to be_a_twirp_response(**attrs)
      end

      it "supports regex matches" do
        is_expected.to be_a_twirp_response(name: /^B/)
      end

      it "catches mismatches" do
        expect {
          is_expected.to be_a_twirp_response(name: "nope")
        }.to fail_including(
          '-:name => "nope",',
          '+:name => "Bob",',
        )

        expect {
          is_expected.to be_a_twirp_response(name: /no/)
        }.to fail_including(
          '-:name => /no/,',
          '+:name => "Bob",',
        )
      end
    end
  end

  context "with error" do
    subject { Twirp::ClientResp.new(error: error) }

    let(:error) { Twirp::Error.new(code, msg, meta) }
    let(:code) { :not_found }
    let(:msg) { "Not Found" }
    let(:meta) { { is_meta: "true" } }

    it { is_expected.to be_a_twirp_response.with_error }
    it { is_expected.to be_a_twirp_response.with_error(code) }
    it { is_expected.to be_a_twirp_response.with_error(msg) }
    it { is_expected.to be_a_twirp_response.with_error(**meta) }
    it { is_expected.to be_a_twirp_response.with_error(/Not/) }

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_response.with_error(:internal)
      }.to fail_with /to have code `:internal`/
    end
  end

  context "with neither response nor error" do
    subject { Twirp::ClientResp.new }

    it "fails the response match" do
      expect {
        is_expected.to be_a_twirp_response
      }.to fail_with /to have data/
    end

    it "fails the error match" do
      expect {
        is_expected.to be_a_twirp_response.with_error
      }.to fail_with /to have an error/
    end
  end

  context "with both response and error" do
    subject do
      Twirp::ClientResp.new(
        data: GoodbyeResponse.new,
        error: Twirp::Error.not_found("Not Found"),
      )
    end

    it "does not permit both attr and error matching" do
      expect {
        is_expected.to be_a_twirp_response(name: "Bob").with_error
      }.to raise_error(ArgumentError, /but not both/)
    end
  end
end
