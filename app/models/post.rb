class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy #post가 destroy되면 관계를 맺고있는 comments도 destroy되도록 처리
  belongs_to :user
  has_many :like_posts
  has_many :liked_users, through: :like_posts, source: :user
end
