class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 本に関連した機能
  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # フォロー機能
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  # DM
  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :rooms, through: :user_rooms, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :group, through: :group_users

  # 画像(active_record)
  has_one_attached :profile_image

  # validation
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  # methods
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def following_each?(user)
    followings.include?(user) && user.following?(self)
  end

  def posts_count_days(days)
    unless days
      books.created_today.count
    else
      start_date = days.days.ago.beginning_of_day
      end_date = days.days.ago.end_of_day
      books.where(created_at: start_date..end_date).count
    end
  end

  def self.search(how, word)
    case how
    when "perfect_match"
      users = User.where("name LIKE?", "#{word}")
    when "forward_match"
      users = User.where("name LIKE?", "#{word}%")
    when "backward_match"
      users = User.where("name LIKE?", "%#{word}")
    when "partial_match"
      users = User.where("name LIKE?", "%#{word}%")
    else
      users = User.all
    end
  end

  def get_profile_image(weight, height)
    unless self.profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    self.profile_image.variant(resize_to_fill: [weight,height]).processed
  end
end
