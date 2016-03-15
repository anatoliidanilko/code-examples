describe UserPresenter, type: :presenter do
  describe '#birth_date' do
    context 'with existing birthdate' do
      let(:user) { FactoryGirl.build(:learner, birth_date: Date.parse('2008-12-02')) }
      let(:presenter) { UserPresenter.new(user) }

      it 'should return dated string' do
        expect(presenter.birth_date).to be == 'December  2, 2008'
      end
    end

    context 'with blank' do
      let(:user) { FactoryGirl.build(:learner, birth_date: nil) }
      let(:presenter) { UserPresenter.new(user) }

      it 'should return dated string' do
        expect(presenter.birth_date).to be == ''
      end
    end
  end

  describe '#last_sign_in_at' do
    context 'with existing last_sign_in_at' do
      let(:user) { FactoryGirl.build(:learner, last_sign_in_at: DateTime.parse('2008-12-02 02:12:32')) }
      let(:presenter) { UserPresenter.new(user) }

      it 'should return dated string' do
        expect(presenter.last_sign_in_at).to be == '02 Dec 02:12'
      end
    end

    context 'with blank' do
      let(:user) { FactoryGirl.build(:learner, last_sign_in_at: nil) }
      let(:presenter) { UserPresenter.new(user) }

      it 'should return dated string' do
        expect(presenter.last_sign_in_at).to be == 'never'
      end
    end
  end

  describe '#full_name' do
    let(:user) { FactoryGirl.build_stubbed(:user, first_name: 'Jack', last_name: 'Smith') }
    let(:presenter) { UserPresenter.new(user) }

    it 'should return joined names' do
      expect(presenter.full_name).to be == 'Jack Smith'
    end

    context 'for nil' do
      it 'should be blank' do
        expect(UserPresenter.new(nil).full_name).to be == '&ndash;'
      end
    end
  end

  describe '#current_sign_in_at' do
    context 'with existing current_sign_in_at' do
      let(:user) { FactoryGirl.build(:learner, current_sign_in_at: DateTime.parse('2008-12-02 02:12:32')) }
      let(:presenter) { UserPresenter.new(user) }

      it 'should return dated string' do
        expect(presenter.current_sign_in_at).to be == '02 Dec 02:12'
      end
    end

    context 'with blank' do
      let(:user) { FactoryGirl.build(:learner, current_sign_in_at: nil) }
      let(:presenter) { UserPresenter.new(user) }

      it 'should return dated string' do
        expect(presenter.current_sign_in_at).to be == 'never'
      end
    end
  end

  describe '#age' do
    before { Timecop.freeze('2014-12-08 17:00') }
    after { Timecop.return }

    context 'with existing birthdate' do
      let(:user) { FactoryGirl.build(:learner, birth_date: Date.parse('2008-12-02')) }
      let(:presenter) { UserPresenter.new(user) }

      it 'should return dated string' do
        expect(presenter.age).to be == 6
      end
    end

    context 'with blank' do
      let(:user) { FactoryGirl.build(:learner, birth_date: nil) }
      let(:presenter) { UserPresenter.new(user) }

      it 'should return dated string' do
        expect(presenter.birth_date).to be == ''
      end
    end
  end

  describe '#path_prefix' do
    subject { described_class.new(user).path_prefix }

    context "for all admins" do
      %w(administrator area_administrator org_administrator).each do |role|
        let(:user) { build_stubbed(:"#{role}") }
        it { is_expected.to eq :admin }
      end
    end

    context "for team member" do
      let(:user) { build_stubbed(:team_member) }
      it { is_expected.to eq :admin }
    end

    context "for supervisor" do
      let(:user) { build_stubbed(:supervisor) }
      it { is_expected.to eq :super }
    end
  end
end
