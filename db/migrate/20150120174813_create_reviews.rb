class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :github_user
      t.references :pull_request
      t.string :status, default: :to_review
      t.timestamps
    end
  end
end
