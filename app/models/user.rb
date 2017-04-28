class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true

  has_many :posts, class_name: 'Post', foreign_key: 'user_id'
  has_many :target_posts, class_name: 'Post', foreign_key: 'target_id'

  has_many :notifications, dependent: :destroy
end
