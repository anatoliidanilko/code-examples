RSpec.describe TranslatorForm, type: :form do
  it 'should include ActiveModel::Model' do
    expect(described_class.ancestors).to include(ActiveModel::Model)
  end

  describe '#model_name' do
    it 'should emulate translation qa' do
      expect(described_class.model_name).to be == TranslationQa.name
    end
  end

  describe "#submit" do
    context "with valid params" do
      let(:translator_params) do
        {
          first_name: 'first name',
          last_name: 'last name',
          email: 'email@mail.com',
          password: 'pass1234',
          role: "role",
          school_name: 'school name',
          languages: %w(en uk)
        }
      end
      let(:form) { described_class.new(filtered_params) }
      let(:filtered_params) { ActionController::Parameters.new(translator_params) }

      it 'should create new translation qa' do
        expect { form.submit }.to change { TranslationQa.count }.by 1
        expect(TranslationQa.find_by(email: 'email@mail.com').name).to eq 'email@mail.com'
      end

      subject { form.submit }
      it { is_expected.to be_truthy }
    end

    context "with invalid params" do
      let(:translator_params) do
        {
          first_name: '',
          last_name: '',
          email: 'invalid_email',
          password: 'pass1234',
          role: "",
          school_name: '',
          languages: %w(en uk)
        }
      end

      let(:form) { described_class.new(filtered_params) }
      let(:filtered_params) { ActionController::Parameters.new(translator_params) }

      it 'should not create new translation qa' do
        expect { form.submit }.not_to change { TranslationQa.count }
        expect(form.errors[:first_name][0]).to eq "can't be blank"
        expect(form.errors[:last_name][0]).to eq "can't be blank"
        expect(form.errors[:email][0]).to eq "is invalid"
        expect(form.errors[:password][0]).not_to be_present
        expect(form.errors[:role][0]).to eq "can't be blank"
        expect(form.errors[:school_name][0]).to eq "can't be blank"
        expect(form.errors[:languages][0]).not_to be_present
      end

      subject { form.submit }
      it { is_expected.to be_falsey }
    end
  end
end
