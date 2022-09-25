describe "be_a_twirp_response" do
  subject { HelloResponse.new(**attrs) }

  let(:attrs) { {} }

  it { is_expected.to be_a_twirp_response }

  it "catches non-twirp response" do
    expect {
      expect(Object).to be_a_twirp_response
    }.to fail_with /Expected a Twirp response, found Object/
  end

  it "matches a specific response type" do
    is_expected.to be_a_twirp_request(HelloResponse)
  end

  it "catches type mismatches" do
    expect {
      is_expected.to be_a_twirp_request(GoodbyeResponse)
    }.to fail_with /request of type GoodbyeResponse/
  end

  context "with attributes" do
    let(:attrs) { { message: msg } }
    let(:msg) { [ "Hello World" ] }

    it { is_expected.to be_a_twirp_response(**attrs) }

    it "supports regex matches" do
      is_expected.to be_a_twirp_response(message: include(/Hello/))
    end

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_response(message: [ "" ])
      }.to fail_with /to have message/

      expect {
        is_expected.to be_a_twirp_response(message: [ "Hello" ])
      }.to fail_with /to have message/
    end

    it "catches the erroneous attributes" do
      expect {
        is_expected.to be_a_twirp_response(msg: [])
      }.to raise_error(ArgumentError, /msg/)
    end

    it "catches type mismatches" do
      expect {
        is_expected.to be_a_twirp_response(message: "Hello World")
      }.to raise_error(ArgumentError, /Expected array/)
    end
  end
end
