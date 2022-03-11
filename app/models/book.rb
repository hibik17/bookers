class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: {maximum: 200}
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search(word)
    @result_title = self.where("title LIKE?", "%#{word}")
    @result_body = self.where("body LIKE?", "%#{word}")
    @books = @result_title + @result_body
    return @books
  end

end
