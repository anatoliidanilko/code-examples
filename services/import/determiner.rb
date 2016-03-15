module Rw
  module Import
    class Determiner
      GENDER_VALUES = {
        'm' => 'male',
        'M' => 'male',
        'male' => 'male',
        'Male' => 'male',
        'f' => 'female',
        'F' => 'female',
        'female' => 'female',
        'Female' => 'female'
      }

      BOOLEAN_VALUES = {
        'y' => 'yes',
        'Y' => 'yes',
        'yes' => 'yes',
        'YES' => 'yes',
        'Yes' => 'yes',
        'n' => 'no',
        'N' => 'no',
        'no' => 'no',
        'NO' => 'no',
        'No' => 'no'
      }

      def self.gender(gender)
        GENDER_VALUES[gender]
      end

      def self.birth_date(date_of_birth)
        parse_birth_date(date_of_birth, "/") || parse_birth_date(date_of_birth, ".")
      end

      def self.eal(eal)
        BOOLEAN_VALUES[eal]
      end

      def self.fsm(fsm)
        BOOLEAN_VALUES[fsm]
      end

      def self.benchmark_reading_age(reading_age)
        return '' if reading_age.blank?
        scan_and_set_ra(reading_age)
      end

      def self.parse_birth_date(date, format_delimiter)
        format_str = "%d#{format_delimiter}%m#{format_delimiter}" + (date =~ /\d{4}/ ? "%Y" : "%y")
        date && Date.strptime(date, format_str).strftime("%d/%m/%Y") rescue nil
      end

      def self.scan_and_set_ra(reading_age)
        ra = reading_age.scan(/\d+/).join('.')
        return ra unless ra[0] == '0'
        ra[1..-1]
      end
    end
  end
end
