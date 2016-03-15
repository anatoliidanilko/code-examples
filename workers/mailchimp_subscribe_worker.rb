class MailchimpSubscribeWorker
  include Sidekiq::Worker

  sidekiq_options queue: :subscriber, retry: 10

  def perform(options)
    Rw::MailchimpSubscriber.new(options).call
  rescue Gibbon::MailChimpError => mce
    p "subscribe failed: due to #{mce.message}"
    raise mce
  rescue Exception => e
    raise e
  end
end
