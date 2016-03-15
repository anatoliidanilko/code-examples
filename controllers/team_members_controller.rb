module Admin
  class TeamMembersController < BaseController
    before_action :root_admin_only

    def index
      @filter = TeamMemberFilter.new(filter_params)
    end

    def new
      @form = CreateTeamMemberForm.new
    end

    def create
      @form = CreateTeamMemberForm.new
      if @form.submit(params)
        redirect_to admin_team_members_path, notice: 'Community member was successfully created'
      else
        flash[:alert] = 'Community member was not created'
        render :new
      end
    end

    def edit
      @form = UpdateTeamMemberForm.new(params[:id])
    end

    def update
      @form = UpdateTeamMemberForm.new(params[:id])
      if @form.submit(params)
        redirect_to admin_team_members_path(filter_params), notice: 'Community member was successfully updated'
      else
        flash[:alert] = 'Community member was not updated'
        render :edit
      end
    end

    def destroy
      team_member = TeamMember.find(params[:id])
      team_member.destroy
      redirect_to admin_team_members_path(filter_params), notice: 'Community member was successfully deleted'
    end

    private

    def filter_params
      params.permit(:page)
    end
  end
end
