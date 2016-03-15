module UserLogins
  class TranslationQaFilter < BaseFilter
    def permitted_login?
      actor.active?
    end
  end
end
