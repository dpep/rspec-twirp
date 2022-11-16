describe "be_a_twirp_message" do
  subject(:request) { HelloRequest.new(**attrs) }

  let(:attrs) { {} }

  it { is_expected.to be_a_twirp_message }

  it "works with responses also" do
    expect(HelloResponse.new).to be_a_twirp_message
  end

  it "supports compound matchers" do
    expect([ request ]).to include(a_twirp_message)
  end

  it "does not match non-twirp subjects" do
    expect(Object).not_to be_a_twirp_message
  end

  it "matches a specific message type" do
    is_expected.to be_a_twirp_message(HelloRequest)
  end

  it "catches type mismatches" do
    is_expected.not_to be_a_twirp_message(GoodbyeRequest)
  end

  it "catches erroneous message types" do
    expect {
      is_expected.to be_a_twirp_message(Object)
    }.to raise_error(TypeError, /Object/)
  end

  context "with attributes" do
    let(:attrs) { { name: "Bob", count: 3 } }

    it "can match attributes" do
      is_expected.to be_a_twirp_message(HelloRequest, **attrs)
    end

    it "supports regex matches" do
      is_expected.to be_a_twirp_message(name: /^B/)
    end

    it "supports range matches" do
      is_expected.to be_a_twirp_message(count: 1..5)
    end

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_message(GoodbyeRequest, name: "Bob")
      }.to fail_with /message of type/

      is_expected.not_to be_a_twirp_message(name: "nope")

      is_expected.not_to be_a_twirp_message(name: /no/)

      is_expected.not_to be_a_twirp_message(count: 1)
    end

    it "catches erroneous attribute matches" do
      is_expected.not_to be_a_twirp_message(namezzz: "Bob")
    end

    it "handles type mismatches" do
      is_expected.not_to be_a_twirp_message(name: 123)
    end
  end
end
