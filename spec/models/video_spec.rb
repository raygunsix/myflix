require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search by title" do
    let!(:family_guy) { Fabricate(:video, title: 'Family Guy')}
    let(:family_ties) { Fabricate(:video, title: 'Family Ties') }

    it "returns an empty array if there is no match" do
      Video.search_by_title("Star Wars").should == []
    end

    it "returns an array of one video for an exact match" do
      Video.search_by_title("Family Guy").length.should == 1
    end

    it "returns an array of one video for a partial match" do
      Video.search_by_title("Fam").length.should == 1
    end

    it "returns an array of all matches ordered by created_at" do
      Video.search_by_title("Fam").should match_array([family_ties, family_guy])
    end
  end
end