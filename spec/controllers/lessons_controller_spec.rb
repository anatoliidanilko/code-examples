RSpec.describe Admin::LessonsController, type: :controller do
  it_should_behave_like "logged-in only controller", chapter_id: 1
  it_should_behave_like "not accessible for", roles: [:learner], chapter_id: 1

  context "logged-in as admin" do
    let(:admin) { FactoryGirl.build_stubbed(:administrator) }
    let(:lesson_attributes) { FactoryGirl.attributes_for(:lesson) }
    let(:chapter) { FactoryGirl.build_stubbed(:chapter) }
    let(:lesson) { FactoryGirl.create(:lesson) }
    let(:lessons) { double("Association") }

    before(:each) do
      sign_in(admin)
      expect(Chapter).to receive(:find).with(chapter.to_param).and_return(chapter)
    end

    describe "GET index" do
      before(:each) do
        expect(chapter).to receive(:lessons).and_return(lessons)
        expect(lessons).to receive(:all).and_return([lesson])
        get :index, chapter_id: chapter.to_param
      end

      it "should be success" do
        expect(response).to be_success
      end

      it "should render template" do
        expect(response).to render_template(:index)
      end

      it "should assign chapter" do
        expect(assigns(:chapter)).to be == chapter
      end

      it "assigns all lessons as @lessons" do
        expect(assigns(:lessons)).to match_array([lesson])
      end
    end

    describe "GET new" do
      let(:create_form) { instance_double(CreateLessonForm) }
      before(:each) do
        expect(CreateLessonForm).to receive(:new).with(chapter).and_return(create_form)
        expect(create_form).to receive(:prebuild_lesson!)
        get :new, chapter_id: chapter.to_param
      end

      it "should be success" do
        expect(response).to be_success
      end

      it "should render template" do
        expect(response).to render_template(:new)
      end

      it "should assign chapter" do
        expect(assigns(:chapter)).to be == chapter
      end

      it "assigns the form" do
        expect(assigns(:form)).to be == create_form
      end
    end

    describe "GET edit" do
      let(:update_form) { instance_double(UpdateLessonForm) }
      before(:each) do
        expect(UpdateLessonForm).to receive(:new).with(chapter, lesson.to_param).and_return(update_form)
        get :edit, chapter_id: chapter.to_param, id: lesson.to_param
      end

      it "should be success" do
        expect(response).to be_success
      end

      it "should render template" do
        expect(response).to render_template(:edit)
      end

      it "should assign chapter" do
        expect(assigns(:chapter)).to be == chapter
      end

      it "assigns the form" do
        expect(assigns(:form)).to be == update_form
      end
    end

    describe "POST create" do
      describe "with valid params" do
        let(:create_form) { instance_double(CreateLessonForm, submit: true) }
        before(:each) do
          expect(CreateLessonForm).to receive(:new).with(chapter).and_return(create_form)
          expect(create_form).to receive(:lesson).at_least(:once).and_return(lesson)
          post :create, chapter_id: chapter.to_param, lesson: lesson_attributes
        end

        it "assigns the form" do
          expect(assigns(:form)).to be == create_form
        end

        it "redirects to the created lesson" do
          expect(response).to be_redirect
          expect(response).to redirect_to(admin_chapter_lessons_path)
        end

        it "should assign flash notice" do
          expect(flash[:notice]).to be == "Lesson was successfully created"
        end
      end

      describe "with invalid params" do
        let(:create_form) { instance_double(CreateLessonForm, submit: false) }
        before(:each) do
          expect(CreateLessonForm).to receive(:new).with(chapter).and_return(create_form)
          post :create, chapter_id: chapter.to_param, lesson: lesson_attributes
        end

        it "assigns the form" do
          expect(assigns(:form)).to be == create_form
        end

        it "should success" do
          expect(response).to be_success
        end

        it "re-renders the 'new' template" do
          expect(response).to render_template("new")
        end

        it "should assign flash notice" do
          expect(flash[:alert]).to be == "Lesson was not created"
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:update_form) { instance_double(UpdateLessonForm, submit: true) }
        let(:update_pos_instance) { instance_double(UpdateLessonItemPositions, call: true) }
        before(:each) do
          expect(UpdateLessonForm).to receive(:new).with(chapter, lesson.to_param).and_return(update_form)
          expect(update_form).to receive(:lesson).at_least(:once).and_return(lesson)
          put :update, chapter_id: chapter.to_param, id: lesson.to_param, lesson: lesson_attributes
        end

        it "assigns the form" do
          expect(assigns(:form)).to be == update_form
        end

        it "redirects to the lesson" do
          expect(response).to redirect_to(admin_chapter_lessons_url(chapter))
        end

        it "should assign flash notice" do
          expect(flash[:notice]).to be == "Lesson was successfully updated"
        end
      end

      describe "with invalid params" do
        let(:update_form) { instance_double(UpdateLessonForm, submit: false) }
        before(:each) do
          expect(UpdateLessonForm).to receive(:new).with(chapter, lesson.to_param).and_return(update_form)
          put :update, chapter_id: chapter.to_param, id: lesson.to_param, lesson: lesson_attributes
        end

        it "assigns the form" do
          expect(assigns(:form)).to be == update_form
        end

        it "should success" do
          expect(response).to be_success
        end

        it "re-renders the 'edit' template" do
          expect(response).to render_template("edit")
        end

        it "should assign flash notice" do
          expect(flash[:alert]).to be == "Lesson was not updated"
        end
      end
    end

    describe "DELETE destroy" do
      let(:removal_service) { double('Rw::Lesson::Removal') }

      before(:each) do
        expect(chapter).to receive(:lessons).and_return(lessons)
        expect(lessons).to receive(:find).with(lesson.to_param).and_return(lesson)
        expect(Rw::Lesson::Removal).to receive(:new).with(lesson).and_return(removal_service)
      end

      context "related learners with chapter" do
        before(:each) do
          allow(removal_service).to receive(:perform).and_return(false)
          allow(removal_service).to receive(:notification).and_return("You can't remove this lesson because currently it is used by <a href='/super/learners/1'>Bill Moy</a>. Please edit this lesson")
          delete :destroy, chapter_id: chapter.to_param, id: lesson.to_param
        end

        it "should be redirected" do
          expect(response).to be_redirect
          expect(response).to redirect_to(admin_chapter_lessons_url(chapter))
        end

        it "should assign chapter" do
          expect(assigns(:chapter)).to be == chapter
        end

        it "should assign flash notice" do
          expect(flash[:alert]).to be == "You can't remove this lesson because currently it is used by <a href='/super/learners/1'>Bill Moy</a>. Please edit this lesson"
        end
      end

      context "no learners related with lesson" do
        before(:each) do
          allow(removal_service).to receive(:perform).and_return(true)
          delete :destroy, chapter_id: chapter.to_param, id: lesson.to_param
        end

        it "should be redirected" do
          expect(response).to be_redirect
          expect(response).to redirect_to(admin_chapter_lessons_url(chapter))
        end

        it "should assign chapter" do
          expect(assigns(:chapter)).to be == chapter
        end

        it "should assign flash notice" do
          expect(flash[:notice]).to be == "Lesson was successfully deleted"
        end
      end
    end
  end
end
