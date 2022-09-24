describe "be_a_twirp_error" do
  subject { Twirp::Error.new(code, msg, meta) }

  let(:code) { :not_found }
  let(:msg) { "Not Found" }
  let(:meta) { { is_meta: "true" } }

  it { is_expected.to be_a_twirp_error }

  it "catches type mismatches" do
    expect {
      expect(Object).to be_a_twirp_error
    }.to fail
  end

  describe "code matches" do
    it { is_expected.to be_a_twirp_error(:not_found) }

    it { expect { is_expected.to be_a_twirp_error(:unknown) }.to fail }

    it "catches erroneous codes" do
      expect {
        is_expected.to be_a_twirp_error(:not_a_valid_code)
      }.to raise_error(ArgumentError, /:not_a_valid_code/)
    end
  end

  describe "msg matches" do
    it { is_expected.to be_a_twirp_error("Not Found") }

    it "supports Regex matches" do
      is_expected.to be_a_twirp_error(/Not/)
    end

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_error("Not")
      }.to fail_with /msg/

      expect {
        is_expected.to be_a_twirp_error(/Nope/)
      }.to fail_with /Nope/
    end
  end

  describe "meta matches" do
    it { is_expected.to be_a_twirp_error(is_meta: "true") }
    it { is_expected.to be_a_twirp_error(is_meta: /^t/) }

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_error(is_meta: "false")
      }.to fail_with /meta/

      expect {
        is_expected.to be_a_twirp_error(not_meta: "")
      }.to fail_with /not_meta/
    end

    it "catches type errors" do
      expect {
        is_expected.to be_a_twirp_error(is_meta: true)
      }.to raise_error(ArgumentError, /meta values must be Strings/)
    end
  end

  describe "multi matches" do
    it { is_expected.to be_a_twirp_error(:not_found, "Not Found") }
    it { is_expected.to be_a_twirp_error(:not_found, /Not/) }
    it { is_expected.to be_a_twirp_error(:not_found, is_meta: "true") }

    it "catches mismatches" do
      expect {
        is_expected.to be_a_twirp_error(:unknown, "Not Found")
      }.to fail_with /unknown/

      expect {
        is_expected.to be_a_twirp_error(:not_found, "Nope")
      }.to fail_with /Nope/

      expect {
        is_expected.to be_a_twirp_error(:not_found, is_meta: "false")
      }.to fail_with /is_meta/
    end
  end
end
