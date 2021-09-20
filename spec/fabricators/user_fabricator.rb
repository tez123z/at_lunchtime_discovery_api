Fabricator(:user) do
  name = Faker::Name.name
  email { Faker::Internet.email(name: name) }
  password { Faker::Internet.password }
end