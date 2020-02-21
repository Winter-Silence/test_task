class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.references :user
      t.string :title, null: false
      t.text :preview, null: false
      t.text :text, null: false
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
