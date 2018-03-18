class Image < ApplicationRecord
  # An image belongs to a product
  belongs_to :product
  
  def as_json
    {
      id: id,
      title: title,
      url: url,
      description: description
    }
  end
end
