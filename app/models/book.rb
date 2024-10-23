class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments
  has_many :favorites

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  # 条件式への名前付け
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

  validates :category, presence: true
  validates :rate,presence: true
  validate :rate_changed_disallow

  # 自作method
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search(how, word)
    case how
    when "perfect_match"
      books = Book.where("title LIKE?", "#{word}")
    when "forward_match"
      books = Book.where("title LIKE?", "#{word}%")
    when "backward_match"
      books = Book.where("title LIKE?", "%#{word}")
    when "partial_match"
      books = Book.where("title LIKE?", "%#{word}%")
    else
      books = Book.all
    end
  end

  def self.tag_search(word)
    books = Book.where(category: word)
  end

  # 自作validation
  def rate_changed_disallow
    if rate_changed? && rate_was.present?
      errors.add(:rate, "評価は投稿時以外にできません。")
    end
  end
end
