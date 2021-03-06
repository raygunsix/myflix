require 'spec_helper'

describe Category do

  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe "recent videos" do
    let(:comedies) { Fabricate(:category) }

    it "returns most recently created videos first" do
      family_guy = Fabricate(:video, category: comedies)
      family_ties = Fabricate(:video, category: comedies, created_at: 1.day.ago)
      comedies.recent_videos.first.created_at.should > comedies.recent_videos.last.created_at
    end

    it "returns only the most recent videos" do
      6.times { Fabricate(:video, category: comedies) }
      old_show = Fabricate(:video, category: comedies, created_at: 1.day.ago)
      comedies.recent_videos.should_not include(old_show)
    end

    it "returns no more than six videos" do
      7.times { Fabricate(:video, category: comedies) }
      comedies.recent_videos.length.should == 6
    end

    it "returns an empty array if there are no videos" do
      comedies.recent_videos.should == []
    end
  end

end