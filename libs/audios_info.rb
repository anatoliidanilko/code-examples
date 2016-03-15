module Rw
  module Lesson
    class AudiosInfo
      using ValuesForKey

      attr_reader :lesson

      def initialize(lesson)
        @lesson = lesson
      end

      def call
        fetch_files_list!
      end

      private

      def fetch_files_list!
        list = urls + [custom_text_audio, description_audio] + voiceover_audios +
               additional_voiceover_audios + sound_urls
        list.uniq.reject(&:blank?)
      end

      def lesson_items
        @lesson_items ||= @lesson.lesson_items
      end

      def items
        @items ||= @lesson.items
      end

      def custom_text_audio
        basename(@lesson.lesson_custom_text_audio.to_s)
      end

      def description_audio
        basename(@lesson.description_audio.to_s)
      end

      def urls
        urls = lesson_items.pluck(:urls).flat_map { |url| url.find_all_values_for(:audio) }
        urls.map { |url| basename(URI.unescape(url.to_s)) }
      end

      def voiceover_audios
        lesson_items.pluck(:voiceover_audio).map { |url| basename(URI.unescape(url.to_s)) }
      end

      def additional_voiceover_audios
        lesson_items.pluck(:additional_voiceover_audio).map { |url| basename(URI.unescape(url.to_s)) }
      end

      def sound_urls
        items.pluck(:sound).map { |url| basename(URI.unescape(url.to_s)) }
      end

      def basename(url)
        File.basename(url, ".*")
      end
    end
  end
end
