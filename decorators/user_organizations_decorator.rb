class UserOrganizationsDecorator < UserDecorator
  def organizations
    all_organizations || area_admin_organizations || Organization.none
  end

  private

  def all_organizations
    @user.root_admin? && Organization.all
  end

  def area_admin_organizations
    @user.area_admin? && @user.zone.organizations
  end
end
