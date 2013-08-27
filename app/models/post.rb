class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy #post가 destroy되면 관계를 맺고있는 comments도 destroy되도록 처리
  belongs_to :user
end
