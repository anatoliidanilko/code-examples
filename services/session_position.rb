class SessionPosition
  include ActiveModel::Model
  attr_reader :session, :session_index, :skill_index, :toolkit_index

  class NoNextSkill < StandardError; end
  class NoPrevSkill < StandardError; end

  delegate :id, to: :session, prefix: true

  def self.build_from_toolkit_params(params)
    lesson = ToolkitLesson.includes(:toolkit_session).find(params[:id])
    toolkit_index = lesson.toolkit_session.send("#{lesson.skill_type}").pluck(:id).index(lesson.id)
    skill_index = lesson.toolkit_session.available_skills.index(lesson.skill_type)
    new(params.merge(session_id: lesson.toolkit_session_id, toolkit_index: toolkit_index, skill_index: skill_index))
  end

  def initialize(params)
    @skill_index = params[:skill_index].to_i
    @toolkit_index = params[:toolkit_index].to_i
    @session = ToolkitSession.includes(:toolkit_lessons, mod: :toolkit_sessions).find(params[:session_id])
    @session_index = @session.mod.toolkit_sessions.index(@session)
  end

  def last?
    last_toolkit? && last_skill?
  end

  def first?
    first_toolkit? && first_skill?
  end

  def next!
    last_toolkit? ? next_skill! : @toolkit_index += 1
    self
  end

  def prev!
    first_toolkit? ? prev_skill! : @toolkit_index -= 1
    self
  end

  def skill
    session.available_skills[skill_index]
  end

  def toolkit
    session.send("#{skill}").enabled[toolkit_index]
  end

  protected

  def last_toolkit?
    session.send("#{skill}").enabled.count.zero? || (session.send("#{skill}").enabled.count - 1) == @toolkit_index
  end

  def first_toolkit?
    0 == @toolkit_index
  end

  def first_skill?
    0 == @skill_index
  end

  def last_skill?
    session.available_skills.count.zero? || (session.available_skills.count - 1) == @skill_index
  end

  def next_skill!
    @toolkit_index = 0
    last_skill? ? fail(NoNextSkill) : @skill_index += 1
  end

  def prev_skill!
    first_skill? ? fail(NoPrevSkill) : @skill_index -= 1
    @toolkit_index = (session.send("#{skill}").enabled.count - 1)
  end
end
