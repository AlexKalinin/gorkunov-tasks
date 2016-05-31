migration_id = '[Migration 1012_time_after_optimization_pending_posts.rb]'

$logger.info "#{migration_id}: Strarting migration"

db = DbHelper.new $APP_CONFIG['pg_host'], $APP_CONFIG['pg_port'], $APP_CONFIG['pg_login'],
                  $APP_CONFIG['pg_password'], $APP_CONFIG['pg_database']



q = db.exec_query('SELECT last_value FROM users_id_seq;')
NUM_USERS = q.first['last_value'].to_i

q = <<END_SQL.gsub(/\s+/, ' ').strip

SELECT id, user_id, post_id from pending_posts
    WHERE user_id <> $1
      AND approved = 0
      AND banned = 0
      AND pending_posts.id NOT IN(
        SELECT pending_post_id FROM viewed_posts
          WHERE user_id = $2)

END_SQL

AVRG_NUM = $APP_CONFIG['table_pending_posts_reads_amount_for_average_val']
$logger.info "#{migration_id}: calculating query #{q}..."
q_start_time = Time.now
q_times = []
1.upto AVRG_NUM do
  t_before = Time.now
  db.exec_params(q, [(rand 1..NUM_USERS), (rand 1..NUM_USERS)])
  t_after = Time.now
  q_times << {before: t_before, after: t_after, diff: (t_after - t_before)}
end
StatsHelper.print_stats q_start_time, Time.now, q, q_times



db.disconnect