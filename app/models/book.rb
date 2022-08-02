# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites

  # set the relationship between book and favorites
  has_many :favorited_users, through: :favorites, source: :user

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  # PV
  is_impressionable counter_cache: true

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # ratyjs
  validates :rate, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true

  # tag
  acts_as_taggable
end
