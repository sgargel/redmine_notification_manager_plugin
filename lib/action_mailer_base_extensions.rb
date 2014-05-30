# Patch ActionMailer to disable Notifications of Issue changes only if
# a) Thread.current[:send_notification_email] = false
#    and Thread.current[:is_issue_change] = true

module MailNotifications
  class MailInterceptor

    def self.delivering_email(mail)
      mail ||= instance_variable_get(:@mail)
      if (Thread.current[:is_issue_change] && !Thread.current[:send_notification_email])
        mail.perform_deliveries = false
        Rails.logger.info("Squelching notification: #{mail.subject}")
      end
    end

    ::ActionMailer::Base.register_interceptor(self)
  end

end

