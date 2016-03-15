describe Rw::Lesson::AudiosInfo do
  let(:lesson) { create(:lesson, lesson_custom_text_audio: "lcta.mp3", description_audio: "da.mp3") }
  let(:service) { described_class.new(lesson) }

  describe "#initialize" do
    it "should assign lesson" do
      expect(service.lesson).to eq(lesson)
    end
  end

  describe "#call" do
    let(:item1) { create(:item, sound: "item_sound.mp3") }
    let(:item2) { create(:item, sound: "item_sound.mp3") }

    let(:urls) do
      {
        sound_to_word: { audio: "sw.mp3" },
        word_to_sound: { audio: "ws.mp3" },
        movie: "movie.mp4"
      }
    end

    let!(:lesson_item1) do
      create(:lesson_item,
             lesson: lesson,
             item: item1,
             urls: urls,
             voiceover_audio: "va.mp3",
             additional_voiceover_audio: "avsa.mp3"
      )
    end

    let!(:lesson_item2) do
      create(:lesson_item,
             lesson: lesson,
             item: item2,
             urls: {},
             voiceover_audio: nil,
             additional_voiceover_audio: nil
      )
    end

    it "should contain lesson_custom_text_audio" do
      expect(service.call).to include("lcta")
    end

    it "should contain description_audio" do
      expect(service.call).to include("da")
    end

    it "should contain related lesson item urls" do
      expect(service.call).to include("sw")
      expect(service.call).to include("ws")
    end

    it "should contain related lesson item voiceover_audio" do
      expect(service.call).to include("va")
    end

    it "should contain related lesson item additional_voiceover_audio" do
      expect(service.call).to include("avsa")
    end

    it "should contain related item sound url" do
      expect(service.call).to include("item_sound")
    end

    it "should contain uniq non-blank values" do
      expect(service.call).to contain_exactly("lcta", "da", "sw", "ws", "va", "avsa", "item_sound")
    end

    it "should not contain blank values" do
      expect(service.call).not_to include ""
      expect(service.call).not_to include nil
    end
  end
end
