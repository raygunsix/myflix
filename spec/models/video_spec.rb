require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search by title" do

    it "returns an exmpty array if there is no match" do
      Video.search_by_title("Family Guy").should == []
    end

    it "returns an array of one video for an exact match" do
      family_guy = Video.create(title: "Family Guy", description: "Funny Show")
      Video.search_by_title("Family Guy").length.should == 1
    end

    it "returns an array of one video for a partial match" do
      family_guy = Video.create(title: "Family Guy", description: "Funny Show")
      Video.search_by_title("Fam").length.should == 1
    end

    it "returns an array of all matches ordered by created_at" do
      family_ties = Video.create(title: "Family Ties", description: "Old Show")
      family_guy = Video.create(title: "Family Guy", description: "Funny Show")
      Video.search_by_title("Fam").should match_array([family_ties, family_guy])
    end
  end
end