RSpec.describe MailchimpSubscribeWorker do
  describe "#perform" do
    let(:opts) do
      {
        "email" => "john@mail.com",
        "first_name" => "John",
        "last_name" => "Doe",
        "role" => "Teacher",
        "school_name" => "EAL",
        "languages" => "English, French",
        "region" => "Region",
        "list_id" => "d32d145g4"
      }
    end
    let(:service) { double('Rw::MailchimpSubscriber') }

    it "should call Rw::MailchimpSubscriber method" do
      expect(Rw::MailchimpSubscriber).to receive(:new).with(opts)
        .and_return(service)
      expect(service).to receive(:call)
      described_class.new.perform(opts)
    end
  end
end
