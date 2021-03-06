class CreateNotificationMessages < ActiveRecord::Migration
  def self.up
    create_table :notification_messages, :force => :id do |t|
      t.integer "id", :limit => 64, :null => false
      t.integer "user_id", :limit => 64, :null => false
      t.integer "initiator_id", :limit => 64, :null => false
      t.integer "target_id", :limit => 64, :null => false
      t.integer "type", :null => false
      t.datetime "create_at"
    end
    
    add_index :notification_messages, :user_id
  end

  def self.down
    drop_table :notification_messages
  end
end
