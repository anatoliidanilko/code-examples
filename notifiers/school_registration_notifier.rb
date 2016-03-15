class SchoolRegistrationNotifier
  attr_reader :opts

  def initialize(opts)
    @opts = opts
  end

  def perform
    send_notification
  end

  private

  def send_notification
    NotificationMailerWorker.perform_async(:admin_school_registration_email, opts[:first_name],
                                           opts[:last_name], opts[:role], opts[:email],
                                           opts[:school_name], opts[:region], opts[:languages])
  end
end
