FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "user%03d" % i }
  end
end
