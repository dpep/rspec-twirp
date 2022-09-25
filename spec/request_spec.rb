describe "be_a_twirp_request" do
  subject { HelloRequest.new(**attrs) }

  let(:attrs) { {} }

  it { is_expected.to be_a_twirp_request }

  it "catches non-twirp requests" do
    expect {
      expect(Object).to be_a_twirp_request
    }.to fail_with /Expected a Twirp request, found Object/
  end

  it "matches a specific request type" do
    is_expected.to be_a_twirp_request(HelloRequest)
  end

  it "catches type mismatches" do
    expect {
      is_expected.to be_a_twirp_request(GoodbyeRequest)
    }.to fail_with /request of type GoodbyeRequest/
  end

  it "catches erroneous request types" do
    expect {
      is_expected.to be_a_twirp_request(Object)
    }.to raise_error(ArgumentError, /Object/)
  end

  context "with attributes" do
    let(:attrs) { { name: "Bob", count: 3 } }

    it "can match attributes" do
      is_expected.to be_a_twirp_request(HelloRequest, **attrs)
    end

    it "supports regex matches" do
      is_expected.to be_a_twirp_request(name: /^B/)
    end

    it "supports range matches" do
      is_expected.to be_a_twirp_request(count: 1..5)
    end

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_request(GoodbyeRequest, name: "Bob")
      }.to fail_with /request of type/

      expect {
        is_expected.to be_a_twirp_request(name: "nope")
      }.to fail_with /to have name: "nope"/

      expect {
        is_expected.to be_a_twirp_request(name: /no/)
      }.to fail_with /to have name: \/no\//

      expect {
        is_expected.to be_a_twirp_request(count: 1)
      }.to fail_with /to have count: 1/
    end

    it "catches the erroneous attribute matches" do
      expect {
        is_expected.to be_a_twirp_request(namezzz: "Bob")
      }.to raise_error(ArgumentError, /namezzz/)
    end

    it "catches type mismatches" do
      expect {
        is_expected.to be_a_twirp_request(name: 123)
      }.to raise_error(TypeError, /string field.*given Integer/)
    end
  end
end
