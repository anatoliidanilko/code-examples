describe ItemPresenter, type: :presenter do
  let(:letter) { FactoryGirl.build_stubbed(:letter, content: 'a') }
  let(:blend) { FactoryGirl.build_stubbed(:blend, content: %w(e f)) }
  let(:word) { FactoryGirl.build_stubbed(:word, content: %w(c at)) }
  let(:sentence) { FactoryGirl.build_stubbed(:sentence, content: 'Some sentence to test.') }

  describe '#content_with_type' do
    it 'should return 1 letter' do
      expect(ItemPresenter.new(letter).content_with_type).to be == 'a [Letter]'
    end

    it 'should return merged blend' do
      expect(ItemPresenter.new(blend).content_with_type).to be == 'ef [Blend]'
    end

    it 'should return merged word' do
      expect(ItemPresenter.new(word).content_with_type).to be == 'cat [Word]'
    end

    it 'should return sentence' do
      expect(ItemPresenter.new(sentence).content_with_type).to be == 'Some sentence to test. [Sentence]'
    end
  end

  describe '#content' do
    it 'should return 1 letter' do
      expect(ItemPresenter.new(letter).content).to be == 'a'
    end

    it 'should return merged blend' do
      expect(ItemPresenter.new(blend).content).to be == 'ef'
    end

    it 'should return merged word' do
      expect(ItemPresenter.new(word).content).to be == 'cat'
    end

    it 'should return sentence' do
      expect(ItemPresenter.new(sentence).content).to be == 'Some sentence to test.'
    end
  end

  describe '#type' do
    it 'should return 1 letter' do
      expect(ItemPresenter.new(letter).type).to be == 'Letter'
    end

    it 'should return merged blend' do
      expect(ItemPresenter.new(blend).type).to be == 'Blend'
    end

    it 'should return merged word' do
      expect(ItemPresenter.new(word).type).to be == 'Word'
    end

    it 'should return sentence' do
      expect(ItemPresenter.new(sentence).type).to be == 'Sentence'
    end
  end
end
