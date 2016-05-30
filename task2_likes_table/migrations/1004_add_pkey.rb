migration_id = '[Migration 1004_add_pkey.rb]'

$logger.info "#{migration_id}: Strarting migration"

sql = <<END_SQL.gsub(/\s+/, ' ').strip
ALTER TABLE likes
  ADD COLUMN id serial;
ALTER TABLE likes
  ADD PRIMARY KEY (id);
END_SQL


db = DbHelper.new $APP_CONFIG['pg_host'], $APP_CONFIG['pg_port'], $APP_CONFIG['pg_login'],
                  $APP_CONFIG['pg_password'], $APP_CONFIG['pg_database']
db.exec_query(sql)
db.disconnect