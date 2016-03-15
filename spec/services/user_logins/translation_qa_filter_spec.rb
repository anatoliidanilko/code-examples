RSpec.describe UserLogins::TranslationQaFilter, type: :service do
  describe '#permitted_login?' do
    context 'when translation inactive' do
      subject { described_class.new(build_stubbed(:translation_qa, active: false)).permitted_login? }
      it { is_expected.to be_falsey }
    end

    context 'when translation active' do
      subject { described_class.new(build_stubbed(:translation_qa, active: true)).permitted_login? }
      it { is_expected.to be_truthy }
    end
  end
end
