RSpec.describe Admin::TeamMembersController, type: :controller do
  it_should_behave_like "logged-in only controller"
  it_should_behave_like "not accessible for", roles: [:learner, :supervisor, :area_administrator, :org_administrator]

  context "logged-in as root admin" do
    let(:admin) { build_stubbed(:administrator) }

    before { sign_in(admin) }

    describe "GET index" do
      let(:filter) { instance_double(TeamMemberFilter) }

      before do
        expect(TeamMemberFilter).to receive(:new).and_return(filter)
        get :index
      end

      it "returns http success" do
        expect(response).to be_success
      end

      it "should render index" do
        expect(response).to render_template(:index)
      end

      it "should assign users" do
        expect(assigns(:filter)).to be == filter
      end
    end

    describe "GET new" do
      let(:form) { instance_double(CreateTeamMemberForm) }

      before(:each) do
        expect(CreateTeamMemberForm).to receive(:new).and_return(form)
        get :new
      end

      it "should be success" do
        expect(response).to be_success
      end

      it "should render template" do
        expect(response).to render_template(:new)
      end

      it "should assign model" do
        expect(assigns(:form)).to be == form
      end
    end

    describe "POST create" do
      let(:form) { instance_double(CreateTeamMemberForm) }
      let(:team_member_attributes) { FactoryGirl.attributes_for(:team_member) }

      before(:each) do
        expect(CreateTeamMemberForm).to receive(:new).and_return(form)
      end

      context "with valid params" do
        before(:each) do
          expect(form).to receive(:submit).and_return(true)
          post :create, team_member: team_member_attributes
        end

        it "assigns a newly created form" do
          expect(assigns(:form)).to be == form
        end

        it "redirects to the created form" do
          expect(response).to be_redirect
          expect(response).to redirect_to(admin_team_members_path)
        end

        it "should assign flash notice" do
          expect(flash[:notice]).to be == "Community member was successfully created"
        end
      end

      context "with invalid params" do
        before(:each) do
          expect(form).to receive(:submit).and_return(false)
          post :create, administrator: team_member_attributes
        end

        it "assigns a newly created form" do
          expect(assigns(:form)).to be == form
        end

        it "should success" do
          expect(response).to be_success
        end

        it "re-renders the 'new' template" do
          expect(response).to render_template(:new)
        end

        it "should assign flash notice" do
          expect(flash[:alert]).to be == "Community member was not created"
        end
      end
    end

    describe "GET edit" do
      let(:form) { instance_double(UpdateTeamMemberForm) }
      let(:team_member) { build_stubbed(:team_member) }

      before(:each) do
        expect(UpdateTeamMemberForm).to receive(:new).with(team_member.to_param).and_return(form)
        get :edit, id: team_member.to_param
      end

      it "should be success" do
        expect(response).to be_success
      end

      it "should render template" do
        expect(response).to render_template(:edit)
      end

      it "should assign model" do
        expect(assigns(:form)).to be == form
      end
    end

    describe "PUT update" do
      let(:form) { instance_double(UpdateTeamMemberForm) }
      let(:team_member) { build_stubbed(:team_member) }
      let(:team_member_attributes) { attributes_for(:team_member) }

      before(:each) do
        expect(UpdateTeamMemberForm).to receive(:new).with(team_member.to_param).and_return(form)
      end

      context "with valid params" do
        before(:each) do
          expect(form).to receive(:submit).and_return(true)
          post :update, id: team_member.to_param
        end

        it "assigns a form" do
          expect(assigns(:form)).to be == form
        end

        it "redirects to the created form" do
          expect(response).to be_redirect
          expect(response).to redirect_to(admin_team_members_path)
        end

        it "should assign flash notice" do
          expect(flash[:notice]).to be == "Community member was successfully updated"
        end
      end

      context "with invalid params" do
        before(:each) do
          expect(form).to receive(:submit).and_return(false)
          post :update, id: team_member.to_param
        end

        it "assigns a form" do
          expect(assigns(:form)).to be == form
        end

        it "should success" do
          expect(response).to be_success
        end

        it "re-renders the 'edit' template" do
          expect(response).to render_template(:edit)
        end

        it "should assign flash notice" do
          expect(flash[:alert]).to be == "Community member was not updated"
        end
      end
    end

    describe 'DELETE destroy' do
      let(:team_member) { build_stubbed(:team_member) }

      before(:each) do
        expect(TeamMember).to receive(:find).with(team_member.to_param).and_return(team_member)
        expect(team_member).to receive(:destroy)

        delete :destroy, id: team_member.to_param
      end

      it "should be redirected" do
        expect(response).to be_redirect
        expect(response).to redirect_to(admin_team_members_path)
      end

      it "should assign flash notice" do
        expect(flash[:notice]).to be == "Community member was successfully deleted"
      end
    end
  end
end
