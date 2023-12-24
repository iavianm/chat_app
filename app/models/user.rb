class User < ApplicationRecord
  has_many :messages, dependent: :destroy

  before_validation :generate_nickname, on: :create

  private

  def generate_nickname
    unless self.nickname.present?
      self.nickname = "#{Faker::Name.first_name.downcase}_#{Faker::Name.last_name.downcase}"
    end
  end
end
