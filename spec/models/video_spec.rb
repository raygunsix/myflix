require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: 'Space War', description: 'Best film of 1972')
    video.save
    expect(Video.first.title).to eq('Space War')
  end

  it "belongs to a category" do
    scifi = Category.create(name: 'Sci-Fi')
    space_war = Video.create(title: 'Space War',
      description: 'Best film of 1972',
      category: scifi)
    expect(space_war.category).to eq(scifi)
  end

  it "requires a title" do
    space_war = Video.new(description: 'Best film of 1972')
    space_war.valid?
    expect(space_war.errors.messages[:title]).to include("can't be blank")
  end

  it "requires a description" do
    space_war = Video.new(title: 'Space War')
    space_war.valid?
    expect(space_war.errors.messages[:description]).to include("can't be blank")
  end
end