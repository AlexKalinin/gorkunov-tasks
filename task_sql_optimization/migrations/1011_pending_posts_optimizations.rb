migration_id = '[Migration 1011_add_indexes.rb]'

$logger.info "#{migration_id}: Strarting migration"

# sql = <<END_SQL.gsub(/\s+/, ' ').strip
#
#   CREATE INDEX pending_posts_post_id_user_id_approved_banned_idx
#   ON pending_posts
#   USING btree
#   (post_id DESC, user_id DESC, approved DESC, banned DESC);
#
#
# END_SQL


# sql = <<END_SQL.gsub(/\s+/, ' ').strip
#
#   CREATE INDEX pending_posts_post_id_user_id_approved_banned_idx
#   ON pending_posts
#   USING btree
#   (post_id, user_id, approved, banned);
#
#
# END_SQL


sql = <<END_SQL.gsub(/\s+/, ' ').strip

  CREATE INDEX ON pending_posts (approved, banned, id);
  CREATE INDEX ON viewed_posts (pending_post_id);
  CREATE INDEX ON viewed_posts (user_id);


END_SQL





db = DbHelper.new $APP_CONFIG['pg_host'], $APP_CONFIG['pg_port'], $APP_CONFIG['pg_login'],
                  $APP_CONFIG['pg_password'], $APP_CONFIG['pg_database']
db.exec_query(sql)
db.disconnect