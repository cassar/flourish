class StaticPagesController < ApplicationController
  def welcome
    @member_count = Member.count
  end
end
