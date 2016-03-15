describe UserLoginsFilter, type: :service do
  let(:actor) { create(:administrator) }
  let(:filter) { described_class.new(actor) }

  describe '#initialize' do
    it "should assign actor" do
      expect(filter.actor).to be == actor
    end
  end

  describe '#login_accessed?' do
    context "for root admins" do
      %w(administrator team_member).each do |role|
        let(:actor) { create(:"#{role}") }

        subject { filter.login_accessed? }
        it { is_expected.to be_truthy }
      end
    end

    context "for non-member org user" do
      %w(area_administrator org_administrator supervisor learner).each do |role|
        let(:actor) { create(:"#{role}") }

        subject { filter.login_accessed? }
        it { is_expected.to be_truthy }
      end
    end

    context "for translation qa" do
      let(:actor) { create(:translation_qa, active: false) }

      subject { filter.login_accessed? }
      it { is_expected.to be_falsey }
    end

    context "for learner" do
      context 'when learner inactive' do
        let(:actor) { create(:learner, active: false) }

        subject { filter.login_accessed? }
        it { is_expected.to be_falsey }
      end

      context 'when learner active' do
        let(:actor) { create(:learner, active: true) }

        subject { filter.login_accessed? }
        it { is_expected.to be_truthy }
      end
    end
  end
end
