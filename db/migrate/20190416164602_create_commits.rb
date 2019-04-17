class CreateCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :commits do |t|
      t.integer :user_id
      t.string :date_reference

      t.timestamps
    end
  end
end
