module UserLogins
  class LearnerLoginFilter < OrgUserFilter
    def permitted_login?
      active_learner? && super
    end

    def notification_message
      return :sub_not_active if from_disabled_zone? && inactive_learner?
      return :sub_expired if from_expired_zone?
      false
    end

    protected

    def active_learner?
      actor.active?
    end

    def inactive_learner?
      !actor.active?
    end
  end
end
