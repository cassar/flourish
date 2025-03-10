module Admin
  class ContributionsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorise_admin!

    after_action :send_notification, only: :create, if: -> { contribution.persisted? }

    def new
      @contribution = member.contributions.new
      @user = member.user
    end

    def preview
      contribution.created_at = Time.zone.now
      @user = member.user
    end

    def create
      if contribution.save
        flash[:success] = I18n.t('controllers.admin.contributions.create.success')
        redirect_to active_admin_members_path
      else
        @user = member.user
        flash.now[:alert] = contribution_error_message
        render :new
      end
    end

    private

    def contribution
      @contribution ||= member.contributions.new(contribution_params)
    end

    def member
      Member.find params[:member_id]
    end

    def contribution_params
      params.expect(contribution: %i[currency amount_in_base_units fees_in_base_units
                                     transaction_identifier])
    end

    def contribution_error_message
      contribution.errors.full_messages.to_sentence
    end

    def send_notification
      return unless member.notification_preferences.contribution_received.all?(&:enabled)

      NotificationMailer.with(contribution:).contribution_received.deliver_later
    end

    def authorise_admin!
      return if current_user.admin?

      redirect_to root_path, alert: I18n.t('controllers.admin.not_authorised')
    end
  end
end
