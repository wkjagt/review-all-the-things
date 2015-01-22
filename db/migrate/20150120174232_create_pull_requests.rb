class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.references :github_user, null: false
      t.references :repository, null: false
      t.string :url, null: false
      t.string :title, null: false
      t.text :body
      t.string :status, default: :open
      t.timestamps
    end
  end
end
