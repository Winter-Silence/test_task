FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    nickname { Faker::Name.first_name }
    password { 'password' }
    password_confirmation { 'password' }
    sign { Faker::ChuckNorris.fact }
    provider { 'email' }
    email { Faker::Internet.email }
    uid { Faker::Internet.email }
  end

  factory :news, class: News do
    title { Faker::Lorem.sentence }
    preview { Faker::Lorem.sentence }
    text { Faker::Lorem.paragraph }
    status { true }
    user { User.first }
  end

  factory :second_news, class: News do
    title { Faker::Lorem.sentence }
    preview { Faker::Lorem.sentence }
    text { Faker::Lorem.paragraph }
    status { true }
    user { User.first }
  end

  factory :third_news, class: News do
    title { Faker::Lorem.sentence }
    preview { Faker::Lorem.sentence }
    text { Faker::Lorem.paragraph }
    status { true }
    user { User.first }
  end

  factory :random_user, class: User do
    name { Faker::Name.name }
    nickname { Faker::Name.first_name }
    password { 'password' }
    password_confirmation { 'password' }
    sign { Faker::ChuckNorris.fact }
    provider { 'email' }
    email { Faker::Internet.email }
    uid { Faker::Internet.email }
  end

  factory :list_favorite_news do

  end

  factory :list_read_news do

  end
end