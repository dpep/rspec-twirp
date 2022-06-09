describe "be_a_twirp_request" do
  subject { Example::HelloRequest.new(**attrs) }

  let(:attrs) { {} }

  it { is_expected.to be_a_twirp_request }
  it { is_expected.to be_a_twirp_request(Example::HelloRequest) }

  context "with attributes" do
    let(:attrs) { { name: "Bob" } }

    it "can match attributes" do
      is_expected.to be_a_twirp_request.with(name: "Bob")
    end

    it "can use a regex to match" do
      is_expected.to be_a_twirp_request.with(name: /^B/)
    end

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_request.with(name: "nope")
      }.to fail
    end

    it "catches the erroneous attribute matches" do
      expect {
        is_expected.to be_a_twirp_request.with(namezzz: "nope")
      }.to raise_error(ArgumentError, /namezzz/)
    end
  end
end
