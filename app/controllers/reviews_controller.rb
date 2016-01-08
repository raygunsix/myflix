class ReviewsController < ApplicationController
  before_action :require_user
  before_action :set_video, only: [:create]

  def create
    review = @video.reviews.build(post_params.merge!(user: current_user))
    if review.save
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end

  def post_params
    params.require(:review).permit(:video_id, :content, :rating)
  end

end