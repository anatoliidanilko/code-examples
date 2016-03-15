describe AdministratorPresenter do
  let(:area) { FactoryGirl.build_stubbed(:area, title: 'Area') }
  let(:organization) { FactoryGirl.build_stubbed(:organization, area: area, title: 'Org') }

  it 'should inherit UserPresenter' do
    filter = AdministratorPresenter.new(FactoryGirl.build_stubbed(:administrator))
    expect(filter).to be_a_kind_of UserPresenter
  end

  context 'for area admin' do
    let(:area_admin) { FactoryGirl.build_stubbed(:area_administrator, zone: area) }

    it 'should return area title' do
      expect(AdministratorPresenter.new(area_admin).area_title).to be == 'Area'
    end

    it 'should return organization title' do
      expect(AdministratorPresenter.new(area_admin).organization_title).to be == ''
    end
  end

  context 'for org admin' do
    let(:org_admin) { FactoryGirl.build_stubbed(:org_administrator, zone: organization) }

    it 'should return area title' do
      expect(AdministratorPresenter.new(org_admin).area_title).to be == 'Area'
    end

    it 'should return organization title' do
      expect(AdministratorPresenter.new(org_admin).organization_title).to be == 'Org'
    end
  end

  context 'for root admin' do
    let(:root_admin) { FactoryGirl.build_stubbed(:administrator) }

    it 'should return area title' do
      expect(AdministratorPresenter.new(root_admin).area_title).to be == 'ROOT'
    end

    it 'should return organization title' do
      expect(AdministratorPresenter.new(root_admin).organization_title).to be == ''
    end
  end
end
