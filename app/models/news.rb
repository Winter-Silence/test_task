class News < ApplicationRecord
  belongs_to :user
  has_many :list_read_news
  has_many :list_favorite_news

  scope :by_status, lambda { |status|
    where(status: status)
  }
end
