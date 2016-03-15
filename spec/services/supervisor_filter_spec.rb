describe SupervisorFilter do
  let(:area) { FactoryGirl.create(:area) }
  let(:organization1) { FactoryGirl.create(:organization, area: area) }
  let(:organization2) { FactoryGirl.create(:organization) }
  let(:supervisor1) { FactoryGirl.create(:supervisor, organization: organization1, name: 'aj78user1') }
  let(:supervisor2) { FactoryGirl.create(:supervisor, organization: organization2, name: 'aj78user2') }
  let(:supervisor3) { FactoryGirl.create(:supervisor, organization: organization2) }

  describe "without params" do
    context "for root admin" do
      let(:user) { FactoryGirl.build_stubbed(:administrator) }
      let(:filter) { SupervisorFilter.new(user: user) }

      it "should contain all supervisors" do
        expect(filter.supervisors).to include supervisor1
        expect(filter.supervisors).to include supervisor2
      end
    end

    context "for area admin" do
      let(:user) { FactoryGirl.build_stubbed(:area_administrator, zone: area) }
      let(:filter) { SupervisorFilter.new(user: user) }

      it "should not contain supervisors" do
        expect(filter.supervisors).to include supervisor1
        expect(filter.supervisors).to_not include supervisor2
      end
    end

    context "for org admin" do
      let(:user) { FactoryGirl.build_stubbed(:org_administrator, zone: organization1) }
      let(:filter) { SupervisorFilter.new(user: user) }

      it "should not contain supervisors" do
        expect(filter.supervisors).to include supervisor1
        expect(filter.supervisors).to_not include supervisor2
      end
    end

    context "for supervisor" do
      let(:user) { supervisor1 }
      let(:filter) { SupervisorFilter.new(user: user) }

      it "should not contain supervisors" do
        expect(filter.supervisors).to_not include supervisor1
        expect(filter.supervisors).to_not include supervisor2
      end
    end
  end

  describe "with area_id" do
    context "for root admin" do
      let(:user) { FactoryGirl.build_stubbed(:administrator) }
      let(:filter) { SupervisorFilter.new(user: user, area_id: area.id) }

      it "should raise with invalid value" do
        expect { SupervisorFilter.new(user: user, area_id: -1) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should contain supervisors" do
        expect(filter.supervisors).to include supervisor1
        expect(filter.supervisors).to_not include supervisor2
      end
    end

    [:area_administrator, :org_administrator, :supervisor, :learner].each do |user_role|
      context "for #{user_role}" do
        let(:user) { FactoryGirl.build_stubbed(user_role) }

        it "should not allow area_id" do
          expect { SupervisorFilter.new(user: user, area_id: area.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "with organization_id" do
    context "for root admin" do
      let(:user) { FactoryGirl.build_stubbed(:administrator) }
      let(:filter) { SupervisorFilter.new(user: user, area_id: area.id, organization_id: organization1.id) }

      it "should raise with invalid value" do
        expect { SupervisorFilter.new(user: user, area_id: area.id, organization_id: organization2.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should contain supervisors" do
        expect(filter.supervisors).to include supervisor1
        expect(filter.supervisors).to_not include supervisor2
      end
    end

    context "for area admin" do
      let(:user) { FactoryGirl.build_stubbed(:area_administrator, zone: area) }
      let(:filter) { SupervisorFilter.new(user: user, organization_id: organization1.id) }

      it "should raise with invalid value" do
        expect { SupervisorFilter.new(user: user, organization_id: organization2.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should contain supervisors" do
        expect(filter.supervisors).to include supervisor1
        expect(filter.supervisors).to_not include supervisor2
      end
    end

    [:org_administrator, :supervisor, :learner].each do |user_role|
      context "for #{user_role}" do
        let(:user) { FactoryGirl.build_stubbed(user_role) }

        it "should not allow area_id" do
          expect { SupervisorFilter.new(user: user, organization_id: organization1.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "with query" do
    let(:user) { FactoryGirl.build_stubbed(:administrator) }
    let(:filter) { SupervisorFilter.new(user: user, query: "aj78") }

    it "should contain supervisors" do
      expect(filter.supervisors).to include supervisor1
      expect(filter.supervisors).to include supervisor2
      expect(filter.supervisors).to_not include supervisor3
    end
  end
end
