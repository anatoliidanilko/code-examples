class ChangeHistoryService
  attr_reader :errors

  def initialize(user_action, user, params = {})
    @user_action = user_action.to_s
    @user = user
    @title = params.delete(:title)
    @obj = params.delete(:obj)
  end

  def create
    PositionChangeHistory.new(history_attrs).save
  rescue => e
    add_error(e)
    false
  end

  private

  def history_attrs
    {
      user_action: @user_action,
      updated_by: @user.id,
      model_name: @obj.class.to_s,
      model_id: @obj.id,
      title: @title,
      ip_address: @user.current_sign_in_ip.to_s
    }
  end

  def add_error(text)
    @errors = "PositionChangeHistory validation failed: #{text}"
  end
end
