FactoryGirl.define do
    initialize_with { new(attributes) }
    factory :user do
        username                 "brownie3003"
        email                    "brownie3003@gmail.com"
        password                 "foobar28"
        password_confirmation    "foobar28"
    end
end
