require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: 'Space War', description: 'Best film of 1972')
    video.save
    expect(Video.first.title).to eq('Space War')
  end
end