class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy

  before_create :generate_token

  def to_param
    token
  end

  private

  def generate_token
    self.token = SecureRandom.hex(4)
  end
end
