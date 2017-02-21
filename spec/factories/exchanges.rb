FactoryGirl.define do
  factory :exchange do
    from_currency 1
    to_currency 1
    amount_before "9.99"
    amount_after "9.99"
    quotation "9.99"
    description "MyText"
  end
end
