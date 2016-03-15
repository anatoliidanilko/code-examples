class UserLoginsFilter
  attr_reader :actor

  def initialize(actor)
    @actor = actor
  end

  def login_accessed?
    filter.permitted_login?
  end

  def message
    filter.notification_message
  end

  private

  def filter
    return @filter ||= UserLogins::BaseFilter.new(actor) if actor.root_admin?
    return @filter ||= UserLogins::OrgUserFilter.new(actor) if actor.admin? || actor.supervisor?
    return @filter ||= UserLogins::LearnerLoginFilter.new(actor) if actor.learner?
    @filter ||= UserLogins::TranslationQaFilter.new(actor)
  end
end
