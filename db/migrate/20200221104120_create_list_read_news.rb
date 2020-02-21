class CreateListReadNews < ActiveRecord::Migration[5.2]
  def change
    create_table :list_read_news do |t|
      t.belongs_to :user
      t.belongs_to :news
      t.timestamps
    end
  end
end
