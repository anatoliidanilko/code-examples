RSpec.describe SchoolRegistrationNotifier, type: :notifier do
  let(:opts) do
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      role: Faker::Company.buzzword,
      email: Faker::Internet.email,
      school_name: Faker::Company.name,
      region: Faker::Address.country,
      languages: %w(en uk)
    }
  end

  describe "#initialize" do
    it "should assign translation_qa_id" do
      expect(described_class.new(opts).opts).to eq(opts)
    end
  end

  describe '#perform' do
    before(:each) { allow(NotificationMailerWorker).to receive(:perform_async) }

    it 'should send email to admin' do
      expect(NotificationMailerWorker).to receive(:perform_async)
        .with(:admin_school_registration_email, opts[:first_name], opts[:last_name], opts[:role],
              opts[:email], opts[:school_name], opts[:region], opts[:languages])
      described_class.new(opts).perform
    end
  end
end
