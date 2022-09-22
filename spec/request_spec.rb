describe "be_a_twirp_request" do
  subject { HelloRequest.new(**attrs) }

  let(:attrs) { {} }

  it { is_expected.to be_a_twirp_request }

  it "catches non-twirp requests" do
    expect {
      expect(Object).to be_a_twirp_request
    }.to fail
  end

  it "matches a specific request type" do
    is_expected.to be_a_twirp_request(HelloRequest)
  end

  it "catches type mismatches" do
    expect {
      is_expected.to be_a_twirp_request(GoodbyeRequest)
    }.to fail
  end

  it "catches erroneous request types" do
    expect {
      is_expected.to be_a_twirp_request(Object)
    }.to raise_error(ArgumentError, /Object/)
  end

  context "with attributes" do
    let(:attrs) { { name: "Bob", count: 3 } }

    it "can match attributes" do
      is_expected.to be_a_twirp_request.with(name: "Bob", count: 3)
    end

    it "supports regex matches" do
      is_expected.to be_a_twirp_request.with(name: /^B/)
    end

    it "supports range matches" do
      is_expected.to be_a_twirp_request.with(count: 1..5)
    end

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_request.with(name: "nope")
      }.to fail

      expect {
        is_expected.to be_a_twirp_request.with(count: 1)
      }.to fail
    end

    it "catches the erroneous attribute matches" do
      expect {
        is_expected.to be_a_twirp_request.with(namezzz: "Bob")
      }.to raise_error(ArgumentError, /namezzz/)
    end

    it "catches type mismatches" do
      expect {
        is_expected.to be_a_twirp_request.with(name: 123)
      }.to raise_error(TypeError, /string field.*given Integer/)
    end
  end
end
