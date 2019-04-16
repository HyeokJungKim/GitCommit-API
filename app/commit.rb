class Commit < ActiveRecord::Base
  belongs_to :user
  after_create :increment_streak

  validates :commit_reference, uniqueness: true

  private

  def increment_streak
    self.user.update(streak: self.user.streak + 1)
  end
end
