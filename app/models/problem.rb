class Problem < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :content, presence: true, length: { maximum: 4095 }
end
