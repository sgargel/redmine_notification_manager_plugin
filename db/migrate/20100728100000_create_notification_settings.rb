class CreateNotificationSettings < ActiveRecord::Migration

  def self.up
    create_table :notification_settings do |t|

      t.column :project_id, :integer, :null => false

      t.column :tracker_id, :integer, :null => false

      t.column :field, :string, :null => false

    end
    # This is a ugly way to achieve inheritance goal using mysql triggers
    # USE IN PRODUCTION AT YOUR OWN RISK
    execute <<-_SQL
    CREATE DEFINER=`redmine_default`@`localhost` TRIGGER `trg_upd_subproject_inherit_notification_settings` AFTER UPDATE ON `projects` FOR EACH ROW BEGIN
    INSERT INTO notification_settings
    select null,NEW.id,tracker_id,field
    From notification_settings
    where project_id = NEW.parent_id
    AND OLD.id NOT IN (SELECT DISTINCT project_id from notification_settings);
    END
    _SQL
  end

  def self.down
    drop_table :notification_settings

    # DROP the ugly trigger
    execute <<-SQL
      DROP TRIGGER `trg_upd_subproject_inherit_notification_settings`;
    SQL
  end
end
