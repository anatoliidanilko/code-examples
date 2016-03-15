RSpec.describe ChangeHistoryService, type: :service do
  describe "#create" do
    let(:user) { build_stubbed(:area_administrator) }
    let(:chapter) { build_stubbed(:chapter, title: "C1") }
    let(:title) { chapter.title }

    context "with valid params" do
      let(:action) { :record_create }
      let(:service) { described_class.new(action, user, title: title, obj: chapter) }

      it "should create new PositionChangeHistory object" do
        expect { service.create }.to change { PositionChangeHistory.count }.by 1
      end

      it "should return true" do
        expect(service.create).to be_truthy
      end
    end

    context "with invalid params" do
      let(:service) { described_class.new(:fake_action, user, title: title, obj: chapter) }

      it "should not create PositionChangeHistory object" do
        expect { service.create }.to change { PositionChangeHistory.count }.by 0
      end

      it "should return false" do
        expect(service.create).to be_falsey
      end

      context "#errors" do
        before { service.create }

        it "should return error message" do
          expect(service.errors).to eq "PositionChangeHistory validation failed: 'fake_action' is not a valid user_action"
        end
      end
    end
  end
end
