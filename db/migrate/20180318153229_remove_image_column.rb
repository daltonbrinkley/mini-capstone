class RemoveImageColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :image_url, :string
  end
end
