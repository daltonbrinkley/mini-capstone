class Image < ApplicationRecord
  def as_json
    {
      id: id,
      title: title,
      url: url,
      description: description
    }
  end
end
