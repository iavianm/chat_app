class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :nickname
      t.boolean :is_online, default: false, null: false

      t.timestamps
    end
  end
end
