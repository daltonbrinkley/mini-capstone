class CreateNames < ActiveRecord::Migration[5.1]
  def change
    create_table :names do |t|
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
