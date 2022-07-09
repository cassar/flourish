class StaticPagesController < ApplicationController
  def welcome
    @member_count = Profile.count
  end
end
