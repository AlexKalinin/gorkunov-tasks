MIGRATION_ID = '[Migration 1002_fill_with_data.rb]'

$logger.info "#{MIGRATION_ID}: Strarting migration"

db = DbHelper.new $APP_CONFIG['pg_host'], $APP_CONFIG['pg_port'], $APP_CONFIG['pg_login'],
                  $APP_CONFIG['pg_password'], $APP_CONFIG['pg_database']
n = $APP_CONFIG['table_like_records_amount']
$logger.info "#{MIGRATION_ID}: fill table likes with #{n} rows..."
time_before_generation = Time.now
1.upto n do
  user_id = rand 1..n
  post_id = rand 1..n

  t1 = Time.parse('2000-01-15 00:00:00')
  t2 = Time.parse('2016-05-29 23:59:59')
  created_at = rand t1..t2
  updated_at = rand t1..t2

  query = 'INSERT INTO likes(user_id, post_id, created_at, updated_at)VALUES ($1, $2, $3, $4);'
  db.exec_params(query, [user_id, post_id, created_at, updated_at])
end
$logger.info "#{MIGRATION_ID}: done at #{Time.now - time_before_generation} seconds".colorize(:light_cyan)
db.disconnect