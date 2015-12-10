require 'redmine'

require 'issue_patch'
require 'action_mailer_base_extensions'
require 'issue_hooks'

Redmine::Plugin.register :redmine_notification_manager_plugin do

  name        'Notification Manager'
  author      'Adrian Herzog, Applify'
  description 'Enables users to configure Redmine email notifications ' +
              'for their actions'
  version     '0.2.2'
  
  permission :notifications, { :notifications => [:index, :edit] }
  menu :project_menu, :notifications, { :controller => 'notifications', :action => 'index' }, :caption => :label_notification_tab, :after => :settings, :param => :project_id
end

