class Group < ApplicationRecord
  has_one_attached :image

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  validates :name, presence: true
  validates :introduction, presence: true

  def is_owned_by?(user)
    owner.id == user.id
  end

  def get_image(weight, height)
    unless self.image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    self.image.variant(resize_to_fill: [weight,height]).processed
  end

  def get_owner
    users.find(owner_id)
  end
end
