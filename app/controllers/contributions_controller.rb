class ContributionsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @member = current_user.member
  end

  def update
    @member = current_user.member

    if @member.update(member_params)
      flash[:success] = I18n.t('controllers.contributions.update.success')
      redirect_to root_path
    else
      flash.now[:error] = @member.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def member_params
    params.require(:member).permit(:contribution_amount)
  end
end
