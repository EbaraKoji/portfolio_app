class User < ApplicationRecord
       has_many :problems
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :confirmable, :lockable
  validates :email, uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 50 },
                   uniqueness: { case_sensitive: false }
end
