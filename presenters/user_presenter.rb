class UserPresenter
  def initialize(user)
    @user = user
  end

  def birth_date
    @user && @user.birth_date? ? @user.birth_date.to_s(:long) : ''
  end

  def short_birth_date
    @user && @user.birth_date? ? @user.birth_date.strftime('%d/%m/%Y') : ''
  end

  def age
    birth_date.present? ? calculate_age(@user.birth_date) : ''
  end

  def gender
    @user && @user.profile.gender? ? @user.profile.gender.humanize : ''
  end

  def current_sign_in_at
    @user && @user.current_sign_in_at? ? @user.current_sign_in_at.to_s(:short) : 'never'
  end

  def last_sign_in_at
    @user && @user.last_sign_in_at? ? @user.last_sign_in_at.to_s(:short) : 'never'
  end

  def full_name
    @user && [@user.first_name, @user.last_name].join(" ") || '&ndash;'.html_safe
  end

  def path_prefix
    return :admin if @user && @user.admin? || @user.team_member?
    return :super if @user && @user.supervisor?
  end

  private

  def calculate_age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
