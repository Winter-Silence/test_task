class ListReadNews < ApplicationRecord
  belongs_to :user
  belongs_to :news

  scope :by_user, lambda { |uid|
    where(user_id: uid)
  }

  scope :by_news, lambda { |nid|
    where(news_id: nid)
  }
end
