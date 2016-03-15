RSpec.describe Administrator, type: :model do
  describe "factories" do
    context "for admin" do
      it "should create admin" do
        expect { FactoryGirl.create(:administrator) }.to change { Administrator.count }.by 1
      end
    end

    context "for area_admin" do
      it "should create admin" do
        expect { FactoryGirl.create(:area_administrator) }.to change { Administrator.count }.by 1
      end

      it "should create area" do
        expect { FactoryGirl.create(:area_administrator) }.to change { Area.count }.by 1
      end
    end

    context "for org_admin" do
      it "should create admin" do
        expect { FactoryGirl.create(:org_administrator) }.to change { Administrator.count }.by 1
      end

      it "should create area" do
        expect { FactoryGirl.create(:org_administrator) }.to change { Organization.count }.by 1
      end
    end
  end

  describe "validations" do
    it "should allow empty zone" do
      is_expected.to allow_value(nil).for(:zone)
    end

    it "should allow area as a zone" do
      is_expected.to allow_value(FactoryGirl.create(:area)).for(:zone)
    end

    it "should allow organization as a zone" do
      is_expected.to allow_value(FactoryGirl.create(:organization)).for(:zone)
    end

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "assiciations" do
    it { is_expected.to belong_to(:zone) }
    it { is_expected.to have_many(:visits).class_name("LiveViewStat").dependent(:destroy) }
  end

  describe "#root_admin? #area_admin?" do
    context "admin" do
      let(:user) { FactoryGirl.build_stubbed(:administrator) }

      it { expect(user).to be_root_admin }
      it { expect(user).to_not be_area_admin }
      it { expect(user).to_not be_org_admin }
    end

    context "area admin" do
      let(:user) { FactoryGirl.build_stubbed(:area_administrator) }

      it { expect(user).to_not be_root_admin }
      it { expect(user).to be_area_admin }
      it { expect(user).to_not be_org_admin }
    end

    context "org admin" do
      let(:user) { FactoryGirl.build_stubbed(:org_administrator) }

      it { expect(user).to_not be_root_admin }
      it { expect(user).to_not be_area_admin }
      it { expect(user).to be_org_admin }
    end
  end
end
