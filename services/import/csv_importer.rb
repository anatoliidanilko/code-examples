require 'csv'
module Rw
  module Import
    class CsvImporter
      attr_accessor :data

      def initialize(file)
        @data = []
        @file = file
      end

      def parse_file
        pos = 0
        return [] if File.zero?(@file)
        CSV.foreach(@file, col_sep: separator, headers: true, header_converters: :symbol, skip_blanks: true) do |row|
          @row = row
          next if default_values? || blank_all_row_values?
          @data << learner_hash.merge(pos: pos)
          pos += 1
        end
        @data
      end

      private

      def default_values?
        @row[:first_name].to_s.downcase == "first name" ||
        @row[:first_name].to_s.downcase == "john" && @row[:last_name].to_s.downcase == "doe"
      end

      def blank_all_row_values?
        @row.to_hash.values.all?(&:blank?)
      end

      def separator
        line = @file.dup.readlines.first
        return ";" if line.count(";") > 6
        ","
      end

      def learner_hash
        {
          first_name: @row[:first_name],
          last_name: @row[:last_name],
          birth_date: Rw::Import::Determiner.birth_date(@row[:date_of_birth])
        }.merge(learner_profile_hash)
      end

      def learner_profile_hash
        {
          gender: Rw::Import::Determiner.gender(@row[:gender]),
          upn: @row[:upn],
          eng_as_additional_lang: Rw::Import::Determiner.eal(@row[:eal]),
          benchmark_title: fix_benchmark_name_a,
          benchmark_subtitle: @row[:benchmark_name_b].to_s,
          benchmark_before: Rw::Import::Determiner.benchmark_reading_age(@row[:benchmark_assessment_reading_age]),
          original_ra: @row[:benchmark_assessment_reading_age],
          splds: @row[:spld]
        }.merge(regionalized_fsm)
      end

      def fix_benchmark_name_a
        return @row[:benchmark_name_a] if @row[:benchmark_name_a].present?
        @row[:becnhmark_name_a].to_s
      end

      def regionalized_fsm
        return { free_school_meals: Rw::Import::Determiner.fsm(@row[:fsm]) } if @row[:fsm].present?
        return { scotish_deprivation_index: @row[:simd].to_i } if @row[:simd].present?
        { wales_deprivation_index: @row[:wimd].to_i }
      end
    end
  end
end
