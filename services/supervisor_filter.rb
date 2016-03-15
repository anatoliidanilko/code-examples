class SupervisorFilter
  include UserQueryConditionsLine
  attr_reader :organization_filter

  def initialize(params = {})
    @user, @page = params[:user], params[:page]
    @query = params[:query]
    @sort_params = params[:search].try(:[], :s)
    @organization_filter = OrganizationFilter.new(params)
  end

  def supervisors
    ransack_supervisors.result.page(@page).per(per_page)
  end

  def ransack_supervisors
    q = supervisors_scope.ransack
    q.sorts = @sort_params || ""
    q
  end

  private

  def supervisors_scope
    scope = supervisors_container.supervisors.order('first_name, last_name')
    scope = scope.where(query_conditions_line, query: "%#{@query}%") unless @query.blank?
    scope
  end

  def per_page
    10
  end

  def supervisors_container
    @organization_filter.organization || @organization_filter.area || UserSupervisorsDecorator.new(@user)
  end
end
