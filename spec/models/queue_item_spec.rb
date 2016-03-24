require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

  describe '#video_title' do
    it 'returns the title of the associated video' do
      video = Fabricate(:video, title: 'Family Guy')
      queue_item = Fabricate(:queue_item, video: video)
      queue_item.video_title.should == 'Family Guy'
    end
  end

  describe '#rating' do
    it 'returns the rating from the review when the review is present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 5)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating.should == 5
    end
    it 'returns nil when the review is not present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating.should be_nil
    end
  end

  describe '#rating=' do
    it 'changes the rating if the review is present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      Review.first.rating.should == 4
    end
    it 'clears the rating if the review is present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      Review.first.rating.should be_nil
    end
    it 'creates a review and rating if the review is not present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 3
      Review.first.rating.should == 3
    end
  end

  describe '#category_name' do
    it 'returns videos category name' do
      category = Fabricate(:category, name: 'comedies')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      queue_item.category_name.should == 'comedies'
    end
  end

  describe '#category' do
    it 'returns videos category' do
      category = Fabricate(:category, name: 'comedies')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      queue_item.category.should == category
    end
  end

end