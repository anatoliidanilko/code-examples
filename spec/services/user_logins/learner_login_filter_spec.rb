RSpec.describe UserLogins::LearnerLoginFilter, type: :service do
  describe '#permitted_login?' do
    let(:learning_group) { create(:learning_group, organization: organization) }
    let(:user) { create(:learner, learning_group: learning_group) }

    context 'when organization disabled' do
      let(:organization) { create(:organization, disabled: true) }

      subject { described_class.new(user).permitted_login? }
      it { is_expected.to be_falsey }
    end

    context 'when organization enabled' do
      let(:organization) { create(:organization, disabled: false) }

      subject { described_class.new(user).permitted_login? }
      it { is_expected.to be_truthy }
    end

    context 'when organization expired' do
      let(:organization) { create(:organization, expires_at: Date.today - 1.day) }

      subject { described_class.new(user).permitted_login? }
      it { is_expected.to be_falsey }
    end

    context 'when organization expires date is nil' do
      let(:organization) { create(:organization, expires_at: nil) }

      subject { described_class.new(user).permitted_login? }
      it { is_expected.to be_truthy }
    end

    context 'when organization active' do
      let(:organization) { create(:organization, expires_at: Date.today + 1.day) }

      subject { described_class.new(user).permitted_login? }
      it { is_expected.to be_truthy }
    end

    context "when learner inactive" do
      let(:learner) { create(:learner, active: false) }

      subject { described_class.new(learner).permitted_login? }
      it { is_expected.to be_falsey }
    end

    context "when learner active" do
      let(:learner) { create(:learner, active: true) }

      subject { described_class.new(learner).permitted_login? }
      it { is_expected.to be_truthy }
    end
  end
end
