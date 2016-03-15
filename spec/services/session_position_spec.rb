describe SessionPosition, type: :service do
  let!(:session) { create(:toolkit_session, :with_toolkits) }
  let(:think_aloud) { session.think_ahead[0] }
  let(:key_word) { session.think_ahead[1] }
  let(:prediction_connection) { session.think_ahead[2] }

  let(:tricky_word) { session.word_check[0] }
  let(:word_web) { session.word_check[1] }
  let(:word_pair) { session.word_check[2] }

  let(:look_back_race) { session.question[0] }
  let(:digging_deeper) { session.question[1] }
  let(:discuss) { session.question[2] }

  let(:emotion_journey) { session.summarize[0] }
  let(:key_theme) { session.summarize[1] }
  let(:chain_of_event) { session.summarize[2] }

  describe "#session_id" do
    let(:walkthrough) { SessionPosition.build_from_toolkit_params(id: think_aloud.id) }

    it { expect(walkthrough.session_id).to be == session.id }
  end

  describe "#build_from_toolkit_params" do
    let(:walkthrough) { SessionPosition.build_from_toolkit_params(id: think_aloud.id) }

    it "should be first" do
      expect(walkthrough).to be_first
    end

    it "should assign toolkit" do
      expect(walkthrough.toolkit).to be == think_aloud
    end

    it "should assign session" do
      expect(walkthrough.session).to be == session
    end

    it "should assign skill" do
      expect(walkthrough.skill).to be == session.available_skills[0]
    end
  end

  describe "#next!" do
    context "switch toolkit" do
      let(:walkthrough) { SessionPosition.new(skill_index: 0, session_id: session.id) }

      before(:each) { walkthrough.next! }

      it "should assign session" do
        expect(walkthrough.session).to be == session
      end

      it "should assign skill" do
        expect(walkthrough.skill).to be == session.available_skills[0]
      end

      it "should assign toolkit" do
        expect(walkthrough.toolkit).to be == key_word
      end
    end

    context "switch skill" do
      let(:walkthrough) { SessionPosition.new(toolkit_index: session.think_ahead.size - 1, skill_index: 0, session_id: session.id) }

      before(:each) { walkthrough.next! }

      it "should assign session" do
        expect(walkthrough.session).to be == session
      end

      it "should assign skill" do
        expect(walkthrough.skill).to be == session.available_skills[1]
      end

      it "should assign toolkit" do
        expect(walkthrough.toolkit).to be == tricky_word
      end
    end

    context "for last step" do
      let(:walkthrough) { SessionPosition.new(toolkit_index: (session.summarize.size - 1), skill_index: 3, session_id: session.id) }

      it "should be last" do
        expect(walkthrough).to be_last
      end

      it "should raise error" do
        expect { walkthrough.next! }.to raise_error(SessionPosition::NoNextSkill)
      end
    end
  end

  describe "#prev!" do
    context "switch toolkit" do
      let(:walkthrough) { SessionPosition.new(toolkit_index: 2, skill_index: 2, session_id: session.id) }

      before(:each) { walkthrough.prev! }

      it "should assign session" do
        expect(walkthrough.session).to be == session
      end

      it "should assign skill" do
        expect(walkthrough.skill).to be == session.available_skills[2]
      end

      it "should assign toolkit" do
        expect(walkthrough.toolkit).to be == digging_deeper
      end
    end

    context "switch skill" do
      let(:walkthrough) { SessionPosition.new(toolkit_index: 0, skill_index: 1, session_id: session.id) }

      before(:each) { walkthrough.prev! }

      it "should assign session" do
        expect(walkthrough.session).to be == session
      end

      it "should assign skill" do
        expect(walkthrough.skill).to be == session.available_skills[0]
      end

      it "should assign toolkit" do
        expect(walkthrough.toolkit).to be == prediction_connection
      end
    end

    context "for first step" do
      let(:walkthrough) { SessionPosition.new(toolkit_index: 0, skill_index: 0, session_id: session.id) }

      it "should be last" do
        expect(walkthrough).to be_first
      end

      it "should raise error" do
        expect { walkthrough.prev! }.to raise_error(SessionPosition::NoPrevSkill)
      end
    end
  end
end
