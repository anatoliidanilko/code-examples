class Administrator < User
  belongs_to :zone, polymorphic: true
  has_many :visits, class_name: LiveViewStat.name, foreign_key: :user_id, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :name, uniqueness: true

  def root_admin?
    zone.nil?
  end

  def area
    return nil if root_admin?
    return zone.area if org_admin?
    return zone if area_admin?
  end

  def member?
    zone.member
  end

  def area_admin?
    zone.is_a? Area
  end

  def org_admin?
    zone.is_a? Organization
  end
end
