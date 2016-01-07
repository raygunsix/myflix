# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: "TV Comedies")
Category.create(name: "TV Dramas")

family_guy = Video.create(title: 'Family Guy',
  description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
  small_cover_url: '',
  large_cover_url: '',
  category: Category.find(1))
Video.create(title: 'Futurama',
  description: 'Another funny show. Please insert girder.',
  small_cover_url: '',
  large_cover_url: '',
  category: Category.find(2))
Video.create(title: 'Monk',
  description: 'Never watched this one.',
  small_cover_url: '',
  large_cover_url: '',
  category: Category.find(2))
Video.create(title: 'South Park',
  description: 'Is this show still on?',
  small_cover_url: '',
  large_cover_url: '',
  category: Category.find(1))
Video.create(title: 'Family Guy',
  description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.',
  small_cover_url: '',
  large_cover_url: '',
  category: Category.find(1))
Video.create(title: 'Futurama',
  description: 'Another funny show. Please insert girder.',
  small_cover_url: '',
  large_cover_url: '',
  category: Category.find(2))
Video.create(title: 'Monk',
  description: 'Never watched this one.',
  small_cover_url: '',
  large_cover_url: '',
  category: Category.find(2))
Video.create(title: 'South Park',
  description: 'Is this show still on?',
  small_cover_url: '',
  large_cover_url: '',
  category: Category.find(1))
Video.create(title: 'South Park',
  description: 'Is this show still on?',
  small_cover_url: '',
  large_cover_url: '',
  category: Category.find(1))

bob = User.create(full_name: 'bob', password: 'bob', email: 'bob@bob.com')

Review.create(user: bob, video: family_guy, rating: 5, content: 'This is a really great movie!')
Review.create(user: bob, video: family_guy, rating: 1, content: 'This is a really terrible movie!')
