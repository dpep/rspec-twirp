describe "be_a_twirp_message" do
  subject { HelloRequest.new(**attrs) }

  let(:attrs) { {} }

  it { is_expected.to be_a_twirp_message }

  it "works with responses also" do
    expect(HelloResponse.new).to be_a_twirp_message
  end

  it "supports compound matchers" do
    expect([ subject ]).to include(a_twirp_message)
  end

  it "catches non-twirp subjects" do
    expect {
      expect(Object).to be_a_twirp_message
    }.to fail_with /Expected a Twirp message, found Object/
  end

  it "matches a specific message type" do
    is_expected.to be_a_twirp_message(HelloRequest)
  end

  it "catches type mismatches" do
    expect {
      is_expected.to be_a_twirp_message(GoodbyeRequest)
    }.to fail_with /message of type GoodbyeRequest/
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

      expect {
        is_expected.to be_a_twirp_message(name: "nope")
      }.to fail_with /to have name: "nope"/

      expect {
        is_expected.to be_a_twirp_message(name: /no/)
      }.to fail_with /to have name: \/no\//

      expect {
        is_expected.to be_a_twirp_message(count: 1)
      }.to fail_with /to have count: 1/
    end

    it "catches the erroneous attribute matches" do
      expect {
        is_expected.to be_a_twirp_message(namezzz: "Bob")
      }.to raise_error(ArgumentError, /namezzz/)
    end

    it "catches type mismatches" do
      expect {
        is_expected.to be_a_twirp_message(name: 123)
      }.to raise_error(TypeError, /string field.*given Integer/)
    end
  end
end
