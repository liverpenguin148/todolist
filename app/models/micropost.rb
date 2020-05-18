class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "画像のフォーマット" },
                            size: { less_than: 5.megabytes,
                                  　message: "ファイル容量は5MBまでです。" }
end
