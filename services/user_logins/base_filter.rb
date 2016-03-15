module UserLogins
  class BaseFilter
    attr_reader :actor

    def initialize(actor)
      @actor = actor
    end

    def permitted_login?
      true
    end

    def notification_message
      false
    end

    protected

    def from_disabled_zone?
      false
    end

    def from_enable_zone?
      !from_disabled_zone?
    end

    def from_expired_zone?
      false
    end

    def from_active_zone?
      !from_expired_zone?
    end
  end
end
