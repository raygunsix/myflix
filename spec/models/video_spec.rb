require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order('created_at DESC') }

  describe "search by title" do
    let!(:empire) { Fabricate(:video, title: 'Star Wars: Empire Strikes Back')}
    let!(:rotj) { Fabricate(:video, title: 'Star Wars: Return of the Jedi') }

    it "returns an empty array if there is no match" do
      Video.search_by_title("Star Wars: A New Hope").should == []
    end

    it "returns an array of one video for an exact match" do
      Video.search_by_title("Star Wars: Empire Strikes Back").length.should == 1
    end

    it "returns an array of two videos for a partial match" do
      Video.search_by_title("Star").length.should == 2
    end

    it "returns an array of all matches ordered by created_at" do
      Video.search_by_title("Star").should match_array([rotj, empire])
    end
  end
end