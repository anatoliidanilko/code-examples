describe Rw::Import::Determiner do
  describe '.gender' do
    context 'values for male' do
      %w(m M male Male).each do |gender|
        context "#{gender} => male" do
          subject { described_class.gender(gender) }
          it { is_expected.to eq 'male' }
        end
      end
    end

    context 'values for female' do
      %w(f F female Female).each do |gender|
        context "#{gender} => female" do
          subject { described_class.gender(gender) }
          it { is_expected.to eq 'female' }
        end
      end
    end
  end

  describe '.birth_date' do
    context 'with "/" as delimiter' do
      ['3/2/15', '03/2/15', '3/02/15', '3/2/2015', '03/02/2015', '3/02/2015'].each do |date|
        context "#{date} => 03/02/2015" do
          subject { described_class.birth_date(date) }
          it { is_expected.to eq '03/02/2015' }
        end
      end
    end

    context "with '.' as delimiter" do
      ["3.2.15", "03.2.15", "3.02.15", "3.2.2015", "03.02.2015", "3.02.2015"].each do |date|
        context "#{date} => 03/02/2015" do
          subject { described_class.birth_date(date) }
          it { is_expected.to eq '03/02/2015' }
        end
      end
    end
  end

  describe '.eal' do
    context 'values for `yes`' do
      %w(y Y yes YES Yes).each do |eal|
        subject { described_class.eal(eal) }
        it { is_expected.to eq 'yes' }
      end
    end

    context 'values for `no`' do
      %w(n N no NO No).each do |eal|
        subject { described_class.eal(eal) }
        it { is_expected.to eq 'no' }
      end
    end
  end

  describe '.fsm' do
    context 'values for `yes`' do
      %w(y Y yes YES Yes).each do |fsm|
        subject { described_class.fsm(fsm) }
        it { is_expected.to eq 'yes' }
      end
    end

    context 'values for `no`' do
      %w(n N no NO No).each do |fsm|
        subject { described_class.fsm(fsm) }
        it { is_expected.to eq 'no' }
      end
    end
  end

  describe '.benchmark_reading_age' do
    context 'when reading age number of mounts' do
      let(:ra) { '65' }

      subject { described_class.benchmark_reading_age(ra) }
      it { is_expected.to eq '65' }
    end

    context 'for `:` delimiter' do
      it 'should be processed' do
        expect(described_class.benchmark_reading_age('5:10')).to eq '5.10'
        expect(described_class.benchmark_reading_age('04:10')).to eq '4.10'
        expect(described_class.benchmark_reading_age('6:05')).to eq '6.05'
        expect(described_class.benchmark_reading_age('07:1')).to eq '7.1'
      end
    end

    context 'for `/` delimiter' do
      it 'should be processed' do
        expect(described_class.benchmark_reading_age('5/10')).to eq '5.10'
        expect(described_class.benchmark_reading_age('04/10')).to eq '4.10'
        expect(described_class.benchmark_reading_age('6/05')).to eq '6.05'
        expect(described_class.benchmark_reading_age('07/1')).to eq '7.1'
      end
    end

    context 'for whitespace delimiter' do
      it 'should be processed' do
        expect(described_class.benchmark_reading_age('5 10')).to eq '5.10'
        expect(described_class.benchmark_reading_age('04 10')).to eq '4.10'
        expect(described_class.benchmark_reading_age('6 05')).to eq '6.05'
        expect(described_class.benchmark_reading_age('07 1')).to eq '7.1'
      end
    end

    context 'for `.` delimiter' do
      it 'should be processed' do
        expect(described_class.benchmark_reading_age('5.10')).to eq '5.10'
        expect(described_class.benchmark_reading_age('04.10')).to eq '4.10'
        expect(described_class.benchmark_reading_age('6.05')).to eq '6.05'
        expect(described_class.benchmark_reading_age('07.1')).to eq '7.1'
      end
    end

    context 'when reading age is blank' do
      subject { described_class.benchmark_reading_age('') }
      it { is_expected.to eq '' }
    end

    context 'when reading age is in XyYm format' do
      subject { described_class.benchmark_reading_age('10y5m') }
      it { is_expected.to eq '10.5' }
    end

    context 'when reading age is in XyrYm format' do
      subject { described_class.benchmark_reading_age('12yr3m') }
      it { is_expected.to eq '12.3' }
    end

    context 'when only months putted' do
      subject { described_class.benchmark_reading_age('0/10') }
      it { is_expected.to eq '.10' }
    end
  end
end
