class Post < ApplicationRecord
  has_rich_text :description
  has_many :comments

  validates_presence_of :title, :description
end
