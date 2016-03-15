describe Rw::Import::CsvImporter do
  let(:importer) { described_class.new(file) }

  describe "#parse_file" do
    context "valid csv file" do
      let(:file) { File.open(Rails.root.join("spec", "files", "learners.csv")) }

      it "should return array with 2 elements" do
        expect(importer.parse_file.count).to be == 3
      end

      context "data for first learner" do
        let(:learner) { importer.parse_file[0] }

        it "should return first_name" do
          expect(learner[:first_name]).to eq("alex")
        end

        it "should return last_name" do
          expect(learner[:last_name]).to eq("fichte")
        end

        it "should return upn" do
          expect(learner[:upn]).to eq("11111111111112")
        end

        it "should return gender" do
          expect(learner[:gender]).to eq("male")
        end

        it "should return birth_date" do
          expect(learner[:birth_date]).to eq("16/11/2007")
        end

        it "should return eng_as_additional_lang" do
          expect(learner[:eng_as_additional_lang]).to be_truthy
        end

        it "should return free_school_meals" do
          expect(learner[:free_school_meals]).to eq 'no'
        end

        it "should return benchmark_title" do
          expect(learner[:benchmark_title]).to eq("title")
        end

        it "should return benchmark_subtitle" do
          expect(learner[:benchmark_subtitle]).to eq("subtitle")
        end

        it "should return benchmark_before" do
          expect(learner[:benchmark_before]).to eq ''
        end

        it "should return splds" do
          expect(learner[:splds]).to be_nil
        end
      end

      context "data for second learner" do
        let(:learner) { importer.parse_file[1] }

        it "should return first_name" do
          expect(learner[:first_name]).to eq("test")
        end

        it "should return last_name" do
          expect(learner[:last_name]).to eq("test")
        end

        it "should return upn" do
          expect(learner[:upn]).to eq("22222222222223")
        end

        it "should return gender" do
          expect(learner[:gender]).to eq("male")
        end

        it "should return birth_date" do
          expect(learner[:birth_date]).to be_nil
        end

        it "should return eng_as_additional_lang" do
          expect(learner[:eng_as_additional_lang]).to be_truthy
        end

        it "should return free_school_meals" do
          expect(learner[:free_school_meals]).to be_truthy
        end

        it "should return benchmark_title" do
          expect(learner[:benchmark_title]).to eq("title")
        end

        it "should return benchmark_subtitle" do
          expect(learner[:benchmark_subtitle]).to eq("subtitle")
        end

        it "should return benchmark_before" do
          expect(learner[:benchmark_before]).to eq("13")
        end

        it "should return splds" do
          expect(learner[:splds]).to be_nil
        end
      end

      context "check birthday for third learner" do
        let(:learner) { importer.parse_file[2] }

        it "should return birth_date" do
          expect(learner[:birth_date]).to eq "23/03/2007"
        end
      end
    end

    context "empty csv file" do
      let(:file) { File.open(Rails.root.join("spec", "files", "empty.csv")) }

      it "should return empty array" do
        expect(importer.parse_file.count).to be_zero
      end
    end
  end
end
