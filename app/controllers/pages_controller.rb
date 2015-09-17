class PagesController < ApplicationController
  before_action :require_user, :except => [:front]
end