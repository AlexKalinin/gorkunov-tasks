migration_id = '[Migration 1001_init_likes_table_structure.rb]'

$logger.info "#{migration_id}: Strarting migration"

sql = <<END_SQL.gsub(/\s+/, ' ').strip
CREATE TABLE public.likes
(
   user_id integer,
   post_id integer,
   created_at timestamp without time zone,
   updated_at timestamp without time zone
)
WITH (
  OIDS = FALSE
)
;
END_SQL


db = DbHelper.new $APP_CONFIG['pg_host'], $APP_CONFIG['pg_port'], $APP_CONFIG['pg_login'],
                  $APP_CONFIG['pg_password'], $APP_CONFIG['pg_database']
db.exec_query(sql)
db.disconnect