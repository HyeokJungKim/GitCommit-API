class CreateCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :commits do |t|
      t.integer :user_id
      t.string :repository_name
      t.string :commit_reference

      t.timestamps
    end
  end
end
