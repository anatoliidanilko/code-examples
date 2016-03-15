describe UserOrganizationsDecorator do
  describe "#organizations" do
    context 'for administrator' do
      let(:organization) { FactoryGirl.create(:organization) }
      let(:user) { FactoryGirl.build_stubbed(:administrator) }
      let(:decorator) { UserOrganizationsDecorator.new(user) }

      it "should contain organization" do
        expect(decorator.organizations).to include(organization)
      end
    end

    context "for area admin" do
      let(:organization) { FactoryGirl.create(:organization) }
      let(:user) { FactoryGirl.build_stubbed(:area_administrator, zone: organization.area) }
      let(:decorator) { UserOrganizationsDecorator.new(user) }

      it "should contain organization" do
        expect(decorator.organizations).to include(organization)
      end
    end

    [:org_administrator, :supervisor, :learner].each do |user_role|
      context "for #{user_role}" do
        let(:user) { FactoryGirl.build_stubbed(user_role) }
        let(:organization) { FactoryGirl.create(:organization) }
        let(:area) { FactoryGirl.create(:area) }
        let(:decorator) { UserOrganizationsDecorator.new(user) }

        it "should not contain organization" do
          expect(decorator.organizations).to_not include(organization)
        end
      end
    end
  end
end
