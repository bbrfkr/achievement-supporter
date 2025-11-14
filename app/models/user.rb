class User < ApplicationRecord
  validates :name
  validates :email, presence: true, uniqueness: true
  validates :discord_id, uniqueness: true
end