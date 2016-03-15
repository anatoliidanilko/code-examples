class CreateAssetForm
  include ActiveModel::Model
  SAVE_FOLDERS = { "mp3" => "audios", "ogg" => "audios", "mp4" => "movies", "jpg" => "images" }

  attr_reader :files, :region, :voice

  def initialize(files = [], region = nil, voice = nil)
    @files = files
    @region = region ? region.downcase : Region.default.title.downcase
    @voice = voice.to_s.downcase
  end

  def submit
    upload
  end

  private

  def upload
    files.each do |file|
      next unless file
      @file = file
      set_format_and_prefix
      upload_local_file
    end
  end

  def set_format_and_prefix
    @format = @file.original_filename.split(".").last.downcase
    @prefix = (SAVE_FOLDERS[@format] + "/")
  end

  def upload_local_file
    SAVE_FOLDERS[@format] == "audios" ? upload_with_region : upload_without_region
  end

  def upload_with_region
    generate_path!(true)
    File.open(Rails.root.join('public', 'content', SAVE_FOLDERS[@format], "regions", @region, @voice, fetch_filename), 'wb') do |file|
      file.write(@file.read)
    end
  end

  def fetch_filename
    @file.headers.match(/filename="(.*?)"/)[1]
  end

  def upload_without_region
    generate_path!
    File.open(Rails.root.join('public', 'content', SAVE_FOLDERS[@format], fetch_filename), 'wb') do |file|
      file.write(@file.read)
    end
  end

  def generate_path!(audio = false)
    @audio = audio
    FileUtils.mkdir_p(media_path) unless File.directory?(media_path)
  end

  def media_path
    return ["#{Rails.root}/public/content/audios/regions/", "#{@region}/", @voice].join if @audio
    ["#{Rails.root}/public/content/", SAVE_FOLDERS[@format]].join
  end
end
