FactoryGirl.define do
  factory :user do
    first_name "Andrew"
    last_name  "Wu"
    email      "michael@example.com"
    password   "foobar"
    password_confirmation "foobar"
  end
end