class AdministratorPresenter < UserPresenter
  def area_title
    area && area.title || 'ROOT'
  end

  def organization_title
    organization && organization.title || ''
  end

  def last_sign_in_time
    @user.last_sign_in_at && @user.last_sign_in_at.strftime('%d/%m/%Y %H:%M')
  end

  protected

  def area
    @user.zone.is_a?(Organization) && @user.zone.area || @user.zone
  end

  def organization
    @user.zone.is_a?(Organization) && @user.zone
  end
end
