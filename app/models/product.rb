class Product < ApplicationRecord
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
      image_url: image_url,
      description: description,
      is_discounted: is_discounted
    }
  end
end
