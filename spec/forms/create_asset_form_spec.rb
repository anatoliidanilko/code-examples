RSpec.describe CreateAssetForm, type: :form do
  it 'should include ActiveModel::Model' do
    expect(described_class.ancestors).to include(ActiveModel::Model)
  end

  describe '#initialize' do
    let(:files) { %w(A B C) }
    let(:region) { "V2" }
    let(:form) { described_class.new(files, region) }

    it "should assign files" do
      expect(form.files).to be == files
    end

    it "should assign region and downcase" do
      expect(form.region).to eq region.downcase
    end
  end

  describe "#submit" do
    before(:each) do
      class << file
        attr_reader :tempfile
        attr_reader :headers
      end
    end

    context 'for audios' do
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec", "files", "rspec_test.mp3")) }
      before(:each) { allow(file).to receive(:headers).and_return("filename=\"rspec_test.mp3\"") }

      context 'without region' do
        let!(:default_region) { create(:def_region, :use_default) }
        let(:form) { described_class.new([file]) }

        after(:each) { File.delete(Rails.root.join("public", "content", "audios", "regions", "original", "rspec_test.mp3")) }

        it "should upload files to default region" do
          expect { form.submit }.to change { Dir.entries(Rails.root.join("public", "content", "audios", "regions", "original")) }
        end
      end

      context 'with region' do
        context 'when voice present' do
          let(:form) { described_class.new([file], "other", 'John') }

          before(:each) { FileUtils.mkdir_p(["#{Rails.root}/public/content/audios/regions/", "other/", "john"].join) }
          after(:each) { FileUtils.rm_rf(["#{Rails.root}/public/content/audios/regions/", "other/", "john"].join) }

          it "should upload files to 'john' voice in 'other' region" do
            expect { form.submit }.to change { Dir.entries(Rails.root.join("public", "content", "audios", "regions", "other", "john")) }
          end
        end

        context 'when voice not present' do
          let(:form) { described_class.new([file], "other") }

          before(:each) { FileUtils.mkdir_p(["#{Rails.root}/public/content/audios/regions/", "other"].join) }
          after(:each) { FileUtils.rm_rf(["#{Rails.root}/public/content/audios/regions/", "other"].join) }

          it "should upload files to 'other' region" do
            expect { form.submit }.to change { Dir.entries(Rails.root.join("public", "content", "audios", "regions", "other")) }
          end
        end
      end
    end

    context 'for other media type' do
      let!(:default_region) { create(:def_region, :use_default) }
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join("spec", "files", "video_test.mp4")) }
      before(:each) { allow(file).to receive(:headers).and_return("filename=\"video_test.mp4\"") }

      let(:form) { described_class.new([file]) }

      before(:each) { FileUtils.mkdir_p("#{Rails.root}/public/content/movies/") }
      after(:each) { FileUtils.rm_rf("#{Rails.root}/public/content/movies") }

      it "should upload video to 'movies' folder" do
        expect { form.submit }.to change { Dir.entries(Rails.root.join("public", "content", "movies")) }
      end
    end
  end
end
