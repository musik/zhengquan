# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store do
    name "MyString"
    address "MyString"
    contact "MyString"
    phone "MyString"
    email "MyString"
    tousu "MyString"
    company nil
    city nil
    province nil
  end
end
