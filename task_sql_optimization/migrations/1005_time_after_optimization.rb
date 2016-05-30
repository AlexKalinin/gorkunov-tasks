migration_id = '[Migration 1005_time_after_optimization.rb]'

$logger.info "#{migration_id}: Strarting migration"

db = DbHelper.new $APP_CONFIG['pg_host'], $APP_CONFIG['pg_port'], $APP_CONFIG['pg_login'],
                  $APP_CONFIG['pg_password'], $APP_CONFIG['pg_database']
TOTAL_RECORDS = $APP_CONFIG['table_like_records_amount']
AVRG_NUM = $APP_CONFIG['table_like_reads_amount_for_average_val']


q1 = 'SELECT COUNT(*) FROM likes WHERE user_id = $1'
$logger.info "#{migration_id}: calculating query #{q1}..."
q1_start_time = Time.now
q1_times = []
1.upto AVRG_NUM do
  t_before = Time.now
  user_id = rand 1..TOTAL_RECORDS # because of 1002_fill_with_data.rb migration
  db.exec_params(q1, [user_id])
  t_after = Time.now
  q1_times << {before: t_before, after: t_after, diff: (t_after - t_before)}
end
StatsHelper.print_stats q1_start_time, Time.now, q1, q1_times


# ----------------------------


q2 = 'SELECT COUNT(*) FROM likes WHERE post_id = $1'
$logger.info "#{migration_id}: calculating query #{q2}..."
q2_start_time = Time.now
q2_times = []
1.upto AVRG_NUM do
  t_before = Time.now
  post_id = rand 1..TOTAL_RECORDS # because of 1002_fill_with_data.rb migration
  db.exec_params(q2, [post_id])
  t_after = Time.now
  q2_times << {before: t_before, after: t_after, diff: (t_after - t_before)}
end
StatsHelper.print_stats q2_start_time, Time.now, q2, q2_times


# ----------------------------
q3 = 'SELECT * FROM likes WHERE user_id = $1 AND post_id = $2'
$logger.info "#{migration_id}: calculating query #{q3}..."
q3_start_time = Time.now
q3_times = []
1.upto AVRG_NUM do
  t_before = Time.now
  user_id = rand 1..TOTAL_RECORDS # because of 1002_fill_with_data.rb migration
  post_id = rand 1..TOTAL_RECORDS # because of 1002_fill_with_data.rb migration
  db.exec_params(q3, [user_id, post_id])
  t_after = Time.now
  q3_times << {before: t_before, after: t_after, diff: (t_after - t_before)}
end
StatsHelper.print_stats q3_start_time, Time.now, q3, q3_times



db.disconnect