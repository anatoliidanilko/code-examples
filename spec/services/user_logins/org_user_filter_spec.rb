RSpec.describe UserLogins::OrgUserFilter, type: :service do
  describe '#permitted_login?' do
    %w(area org).each do |role|
      let(:obj_name) { role == "org" ? "organization" : "area" }

      context "for #{role} admin" do
        let(:user) { create(:"#{role}_administrator", zone: zone) }

        context 'when zone disabled' do
          let(:zone) { create(:"#{obj_name}", disabled: true) }

          subject { described_class.new(user).permitted_login? }
          it { is_expected.to be_falsey }
        end

        context 'when zone enabled' do
          let(:zone) { create(:"#{obj_name}", disabled: false) }

          subject { described_class.new(user).permitted_login? }
          it { is_expected.to be_truthy }
        end

        context 'when zone expired' do
          let(:zone) { create(:"#{obj_name}", expires_at: Date.today - 1.day) }

          subject { described_class.new(user).permitted_login? }
          it { is_expected.to be_falsey }
        end

        context 'when zone expires date is nil' do
          let(:zone) { create(:"#{obj_name}", expires_at: nil) }

          subject { described_class.new(user).permitted_login? }
          it { is_expected.to be_truthy }
        end

        context 'when zone active' do
          let(:zone) { create(:"#{obj_name}", expires_at: Date.today + 1.day) }

          subject { described_class.new(user).permitted_login? }
          it { is_expected.to be_truthy }
        end
      end
    end
  end
end
