RSpec.describe UserLogins::BaseFilter, type: :service do
  let(:actor) { build_stubbed(:administrator) }
  let(:service) { described_class.new(actor) }

  describe '#initialize' do
    it "should assign actor" do
      expect(service.actor).to be == actor
    end
  end

  describe '#permitted_login?' do
    it 'should be true by default' do
      expect(service.permitted_login?).to be_truthy
    end
  end

  describe '#notification_message?' do
    it 'should be false by default' do
      expect(service.notification_message).to be_falsey
    end
  end
end
