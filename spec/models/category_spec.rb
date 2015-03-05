require 'spec_helper'

describe Category do

  it "saves itself" do
    category = Category.new(name: 'News')
    category.save
    expect(Category.first.name).to eq('News')
  end

  it "has many videos" do
    scifi = Category.create(name: 'Sci-Fi')
    space_war = Video.create(title: 'Space War',
      description: 'Best film of 1972',
      category: scifi)
    space_war_2 = Video.create(title: 'Space War II',
      description: 'Best film of 1974',
      category: scifi)
    expect(scifi.videos).to eq([space_war, space_war_2])
  end

end