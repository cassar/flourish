class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def show
    @member = current_user.member
  end

  def edit_payid
    @member = current_user.member
  end

  def update
    @member = current_user.member
    if @member.update(member_params)
      flash[:success] = I18n.t('controllers.memberships.update.success')
      redirect_to membership_path
    else
      flash.now[:error] = @member.errors.full_messages.to_sentence
      render :edit_payid
    end
  end

  def dividends
    @dividends = current_user.member.dividends
  end

  private

  def member_params
    params.require(:member).permit(:payid)
  end
end
