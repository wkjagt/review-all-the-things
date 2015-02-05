class CreateGithubUsers < ActiveRecord::Migration
  def change
    create_table :github_users do |t|
      t.string :github_username, null: false
      t.string :secret, null: false
      t.timestamps null: false
    end
  end
end
