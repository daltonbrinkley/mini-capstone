class Product < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, length: { in: 10..500 }

  has_many :orders

  has_many :category_products
  has_many :categories, through: :category_products

  has_many :carted_products

# A product has many images:
  has_many :images
  # def images
  #   Image.where(product_id: id)
  # end

# A product belongs to a supplier:
  belongs_to :supplier
  # def supplier
  #   supplier = Supplier.find_by(id: supplier_id)
  # end

  def is_discounted
    if price < 2
      return "True"
    else
      return "False"
    end
  end

  def tax
    return price*0.09
  end

  def total
    return price+tax
  end

  def as_json
    {
      id: id,
      name: name,
      price: price,
      tax: tax,
      total: total,
      description: description,
      is_discounted: is_discounted,
      supplier: supplier.as_json,
      image: images[0] ? images[0].url : "no image",
      categories: categories.map { |category| category.name}
      # images: images.map { |image| image.url }
    }
  end
end
