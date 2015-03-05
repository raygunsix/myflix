require 'spec_helper'

describe Category do

  it "saves itself" do
    category = Category.new(name: 'News')
    category.save
    expect(Category.first.name).to eq('News')
  end

end