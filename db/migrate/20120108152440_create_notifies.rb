class CreateNotifies < ActiveRecord::Migration
  def self.up
    create_table :notifies do |t|
      t.integer :status
      t.integer :topic
      t.integer :repository_id
      t.references :user
      t.references :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :notifies
  end
end
