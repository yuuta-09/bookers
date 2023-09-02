class NoticeMailer < ApplicationMailer
  # 全員に一斉送信
  # def send_mail(mail_title, mail_content, group_users)
  #   @mail_title = mail_title
  #   @mail_content = mail_content
  #   mail bcc: group_users.pluck(:email), subject: mail_title
  # end

  # 一人ひとりに一斉送信
  def create_notification(member, event)
    @group = event[:group]
    @title = event[:title]
    @body = event[:body]

    mail(
      from: ENV['MAILER_ADDRESS'],
      to: member.email,
      subject: 'New Event Notice!'
    )
  end


  def send_notification(event)
    mailer = self.new
    group = event[:group]
    group.users.each do |member|
      mailer.create_notification(member, event).deliver_now
    end
  end
end
