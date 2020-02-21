class CreateListFavoriteNews < ActiveRecord::Migration[5.2]
  def change
    create_table :list_favorite_news do |t|
      t.belongs_to :user
      t.belongs_to :news

      t.timestamps
    end
  end
end
