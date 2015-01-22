class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.integer :github_id, null: false, unique: true
      t.string :name, null: false
      t.string :url, null: false
      t.timestamps null: false
    end
  end
end
