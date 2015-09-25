Fabricator(:user) do
  email { Faker::Internet.email }
  password { Faker::Lorem.words(1) }
  full_name { Faker::Name.name }
end