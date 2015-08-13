# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: "TV Comedies")
Category.create(name: "TV Dramas")

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
