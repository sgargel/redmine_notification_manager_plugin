require 'redmine'
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

require 'issue_patch'
require 'action_mailer_base_extensions'
Rails.logger.info 'Starting Notification Manager plugin for Redmine'

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    require_dependency 'issue'
    # Guards against including the module multiple time (like in tests)
    # and registering multiple callbacks
    unless Issue.included_modules.include? Notification::IssuePatch
      Issue.send(:include, Notification::IssuePatch)
    end
  end
else
  Dispatcher.to_prepare do
    require_dependency 'issue'
    # Guards against including the module multiple time (like in tests)
    # and registering multiple callbacks
    unless Issue.included_modules.include? Notification::IssuePatch
      Issue.send(:include, Notification::IssuePatch)
    end
  end
end
require_dependency 'issue_hooks'

Redmine::Plugin.register :redmine_notification_manager_plugin do

  name        'Notification Manager'
  author      'Adrian Herzog, Applify'
  description 'Enables users to configure Redmine email notifications ' +
              'for their actions'
  version     '0.2.1'
  
  permission :notifications, {:notifications => [:index, :edit]}, :public => true
  menu :project_menu, :notifications, { :controller => 'notifications', :action => 'index' }, :caption => 'Notifications', :after => :settings, :param => :project_id

end

