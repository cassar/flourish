class PaypalmeHandlesController < ApplicationController
  before_action :authenticate_user!

  def edit
    @member = current_user.member
  end

  def update
    @member = current_user.member
    if @member.update(member_params)
      flash[:success] = I18n.t('controllers.paypalme_handles.update.success')
      redirect_to membership_path
    else
      flash.now[:error] = @member.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def member_params
    params.expect(member: [:paypalme_handle])
  end
end
