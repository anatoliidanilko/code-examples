module UserLogins
  class OrgUserFilter < BaseFilter
    def permitted_login?
      from_enable_zone? && from_active_zone?
    end

    def notification_message
      return :sub_not_active if from_disabled_zone?
      return :sub_expired if from_expired_zone?
      super
    end

    protected

    def zone
      return actor.zone if actor.admin?
      actor.organization
    end

    def from_disabled_zone?
      zone.disabled
    end

    def from_enable_zone?
      !from_disabled_zone?
    end

    def from_expired_zone?
      zone.expires_at && zone.expires_at <= Date.today
    end

    def from_active_zone?
      !from_expired_zone?
    end
  end
end
