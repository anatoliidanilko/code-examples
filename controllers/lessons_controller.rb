module Admin
  class LessonsController < BaseController
    layout "application"

    before_action :root_admin_only, except: [:index]
    before_action :set_chapter
    before_action :check_mod_access, only: [:index]

    def index
      @lessons = @chapter.lessons.all
    end

    def new
      @form = CreateLessonForm.new(@chapter)
      @form.prebuild_lesson!
    end

    def create
      @form = CreateLessonForm.new(@chapter)
      if @form.submit(params)
        ChangeHistoryService.new(:record_create, @current_user, title: @form.lesson.title, obj: @form.lesson).create
        Rw::Versioning::Validator.new(@form.lesson.content_versioning).call unless @form.lesson.content_versioning.public?
        redirect_to admin_chapter_lessons_path(@chapter), notice: 'Lesson was successfully created'
      else
        flash[:alert] = 'Lesson was not created'
        render :new
      end
    end

    def edit
      @form = UpdateLessonForm.new(@chapter, params[:id])
    end

    def update
      @form = UpdateLessonForm.new(@chapter, params[:id])
      if @form.submit(params)
        UpdateLessonItemPositions.new(@form.lesson, params).call
        ChangeHistoryService.new(:record_update, current_user, title: @form.lesson.title, obj: @form.lesson).create
        redirect_to admin_chapter_lessons_path(@chapter), notice: 'Lesson was successfully updated'
      else
        flash[:alert] = 'Lesson was not updated'
        render :edit
      end
    end

    def destroy
      lesson = @chapter.lessons.find(params[:id])
      @removal_service = Rw::Lesson::Removal.new(lesson)
      if @removal_service.perform
        flash[:notice] = "Lesson was successfully deleted"
        ChangeHistoryService.new(:record_delete, @current_user, title: lesson.title, obj: lesson).create
      else
        flash[:alert] = @removal_service.notification
      end
      redirect_to admin_chapter_lessons_path(@chapter)
    end

    private

    def set_chapter
      @chapter = Chapter.find(params[:chapter_id])
    end

    def check_mod_access
      return unless current_user.org_admin? || current_user.supervisor?
      redirect_to root_path, alert: "Access denied" unless Rw::Mod::AccessChecker.new(current_user, @chapter.mod).grant?
    end
  end
end
