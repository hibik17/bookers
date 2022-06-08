class EventMailer < ApplicationMailer
  default from: 'bookers_admin@example.com'

  def notice_email
    @event_title = params[:title]
    @event_content = params[:content]

    @user = User.find(params[:user_id])

    mail(
      subject: @event_title,
      to: @user.email
    )
  end
end
