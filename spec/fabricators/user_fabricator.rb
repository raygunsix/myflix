Fabricator(:user) do
  email { Faker::Internet.email }
  password { Faker::Lorem.word }
  full_name { Faker::Name.name }
end