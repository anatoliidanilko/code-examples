class CreateTextsBatchForm
  include ActiveModel::Model

  DAILY_LIMIT = 'Daily Limit Exceeded'
  INVALID_VALUE = 'Invalid Value'

  attr_reader :translation, :error

  def initialize(translation, languages)
    @translation = translation
    @languages = filter_languages(languages)
    @error = nil
  end

  def submit
    @languages.each do |language|
      @language = language
      @translated_text = EasyTranslate.translate(translation.source_text.to_s, easy_translate_attrs)
      translation.translated_texts.create(texts_attrs)
    end
    true
  rescue EasyTranslate::EasyTranslateException => ex
    @error = ex.message
    false
  rescue => ex
    @error = ex.message
    false
  end

  private

  def filter_languages(languages)
    languages.select(&:present?)
  end

  def easy_translate_attrs
    { to: @language, key: Rails.application.secrets.translate_key }
  end

  def texts_attrs
    {
      destination_language: @language,
      translated_text: @translated_text,
      payment_rate: Setting.translation_rate
    }
  end
end
