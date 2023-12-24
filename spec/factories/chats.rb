FactoryBot.define do
  factory :chat do
    title { "Chat #{SecureRandom.hex(4)}" }
  end
end
