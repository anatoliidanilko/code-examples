class TranslatorForm
  include ActiveModel::Model

  validates :first_name, presence: { message: "can't be blank" }
  validates :last_name, presence: { message: "can't be blank" }
  validates :email, presence: { message: "can't be blank" }, format: { with: /@/, message: "is invalid" }
  validates :password, presence: { message: "can't be blank" }, length: { minimum: 8 }
  validates :role, presence: { message: "can't be blank" }
  validates :school_name, presence: { message: "can't be blank" }
  validates :languages, presence: { message: "can't be blank" }
  validate :email_is_unique
  validate :check_terms_of_use

  attr_accessor :first_name, :last_name, :email, :password, :role, :school_name, :languages,
                :terms_of_use

  def self.model_name
    ActiveModel::Name.new(self, nil, TranslationQa.name)
  end

  def persisted?
    false
  end

  def submit
    return false unless valid?
    persist!
  end

  private

  def email_is_unique
    errors.add(:email, 'is already taken') if User.find_by(email: email)
  end

  def persist!
    @translation_qa = TranslationQa.create!(qa_attributes)
    send_notifications
    MailchimpSubscribeWorker.perform_async(mailchimp_params)
    true
  end

  def qa_attributes
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      name: email,
      password: password,
      role: role,
      school_name: school_name,
      languages: languages
    }
  end

  def mailchimp_params
    {
      "first_name" => first_name,
      "last_name" => last_name,
      "email" => email,
      "role" => role,
      "school_name" => school_name,
      "languages" => languages_list,
      "list_id" => Rw::MailchimpSubscriber::IDS_LIST[:translator]
    }
  end

  def send_notifications
    TranslatorCreationNotifier.new(@translation_qa).perform
    QaRegistrationNotifier.new(@translation_qa).perform
  end

  def languages_list
    languages.reject(&:blank?).map { |lng| Translation::LANGUAGES[lng] }.join(", ")
  end

  def check_terms_of_use
    errors.add(:base, 'Please accept the terms and conditions to continue') unless terms_of_use
  end
end
