module Rw
  module Region
    class FolderGenerator
      MAIN_PATH = "#{Rails.root}/public/content/audios/regions/"
      CREATE_ACTION = "create"
      UPDATE_ACTION = "update"
      DESTROY_ACTION = "destroy"

      def initialize(title, old_title = "", action = CREATE_ACTION)
        @title = title.to_s.downcase
        @old_title = old_title.to_s.downcase
        @action = action
      end

      def call
        manage_folder!
      end

      private

      def manage_folder!
        return create_folder! if create_action?
        return rename_folder! if update_action?
        remove_folder!
      end

      def create_action?
        @action == CREATE_ACTION
      end

      def update_action?
        @action == UPDATE_ACTION
      end

      def region_path
        [MAIN_PATH, @title].join
      end

      def old_region_path
        [MAIN_PATH, @old_title].join
      end

      def folder_exists?(path)
        File.directory?(path)
      end

      def create_folder!
        return if @title.blank?
        FileUtils.mkdir_p(region_path) unless folder_exists?(region_path)
      end

      def rename_folder!
        return if @old_title.blank? && @title.blank?
        return if @old_title == @title
        FileUtils.mv(old_region_path, region_path) if folder_exists?(old_region_path)
      end

      def remove_folder!
        return if @title.blank?
        FileUtils.rm_rf(region_path) if folder_exists?(region_path)
      end
    end
  end
end
