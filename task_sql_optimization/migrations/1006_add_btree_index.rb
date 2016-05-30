migration_id = '[Migration 1006_add_btree_index.rb]'

$logger.info "#{migration_id}: Strarting migration"

sql = <<END_SQL.gsub(/\s+/, ' ').strip

  CREATE INDEX likes_post_id_idx
    ON likes
    USING btree
    (post_id NULLS FIRST);

  CREATE INDEX likes_user_id_idx
    ON likes
    USING btree
    (user_id NULLS FIRST);

END_SQL


db = DbHelper.new $APP_CONFIG['pg_host'], $APP_CONFIG['pg_port'], $APP_CONFIG['pg_login'],
                  $APP_CONFIG['pg_password'], $APP_CONFIG['pg_database']
db.exec_query(sql)
db.disconnect