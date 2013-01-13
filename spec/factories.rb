FactoryGirl.define do
  factory :user do
    first_name "Example"
    last_name  "User"
    email      "user@example.com"
    password   "foobar"
    password_confirmation "foobar"

    factory :admin do
      email "admin@example.com"
      admin true
    end
  end

  factory :restaurant do
    name     "Example Restaurant"
    address1 "123 Main St."
    address2 " "
    city     "Hayward"
    state    "CA"
    zip      "94544"
    phone    "(510)123-4567"
  end
end