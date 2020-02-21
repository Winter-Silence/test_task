class ListFavoriteNews < ApplicationRecord
  belongs_to :user
  belongs_to :news
end
