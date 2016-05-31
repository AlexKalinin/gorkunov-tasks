migration_id = '[Migration 1009_fill_pending_posts_with_data.rb]'

$logger.info "#{migration_id}: Strarting migration"

db = DbHelper.new $APP_CONFIG['pg_host'], $APP_CONFIG['pg_port'], $APP_CONFIG['pg_login'],
                  $APP_CONFIG['pg_password'], $APP_CONFIG['pg_database']

# Table posts
posts_ids = []
N_POSTS = $APP_CONFIG['table_posts_records_amount']
$logger.info "#{migration_id}: fill table 'posts' with #{N_POSTS} rows..."
time_before_generation = Time.now
1.upto N_POSTS do
  t1 = Time.parse('2000-01-15 00:00:00')
  t2 = Time.parse('2016-05-29 23:59:59')
  created_at = rand t1..t2
  updated_at = rand t1..t2

  query = 'INSERT INTO posts(created_at, updated_at)VALUES ($1, $2);'
  db.exec_params(query, [created_at, updated_at])

  pg_res_id = db.exec_query('SELECT last_value FROM posts_id_seq;')
  posts_ids << pg_res_id.first['last_value'].to_i
end
$logger.info "#{migration_id}: done at #{Time.now - time_before_generation} seconds".colorize(:light_cyan)





# Table users
users_ids = []
N_USERS = $APP_CONFIG['table_users_records_amount']
$logger.info "#{migration_id}: fill table 'users' with #{N_USERS} rows..."
time_before_generation = Time.now
1.upto N_USERS do
  t1 = Time.parse('2000-01-15 00:00:00')
  t2 = Time.parse('2016-05-29 23:59:59')
  created_at = rand t1..t2
  updated_at = rand t1..t2

  query = 'INSERT INTO users(created_at, updated_at)VALUES ($1, $2);'
  db.exec_params(query, [created_at, updated_at])

  pg_res_id = db.exec_query('SELECT last_value FROM users_id_seq;')
  users_ids << pg_res_id.first['last_value'].to_i
end
$logger.info "#{migration_id}: done at #{Time.now - time_before_generation} seconds".colorize(:light_cyan)


# Table pending_posts
pending_posts_ids = []
$logger.info "#{migration_id}: fill table 'pending_posts' with maximum #{N_POSTS * N_USERS} rows..."
time_before_generation = Time.now
for i in 0..(N_POSTS - 1) do
  post_id = posts_ids[i]
  for j in 0..(N_USERS - 1) do
    # Not all posts are in pending status
    next if [true, false].sample

    user_id = users_ids[j]
    approved = [1, 0].sample
    banned = [1, 0].sample
    query = 'INSERT INTO pending_posts(post_id, user_id, approved, banned)VALUES ($1, $2, $3, $4);'
    db.exec_params(query, [post_id, user_id, approved, banned])

    pg_res_id = db.exec_query('SELECT last_value FROM pending_posts_id_seq;')
    pending_posts_ids << pg_res_id.first['last_value'].to_i
  end
end
$logger.info "#{migration_id}: done at #{Time.now - time_before_generation} seconds. Generated #{pending_posts_ids.count} rows".colorize(:light_cyan)


# Table viewed_posts
viewed_posts_ids = []
$logger.info "#{migration_id}: fill table 'viewed_posts' with maximum #{N_POSTS * N_USERS} rows..."
time_before_generation = Time.now
for i in 0..(N_POSTS - 1) do
  #post_id = posts_ids[i]
  for j in 0..(N_USERS - 1) do
    # Some users didn't see this posts
    next if [true, false].sample

    # # if maybe this viewed_post is not pending...
    # pending_post_id = [nil, pending_posts_ids.sample].sample
    pending_post_id = pending_posts_ids.sample

    user_id = users_ids[j]
    query = 'INSERT INTO viewed_posts(user_id, pending_post_id)VALUES ($1, $2);'
    db.exec_params(query, [user_id, pending_post_id])

    pg_res_id = db.exec_query('SELECT last_value FROM pending_posts_id_seq;')
    viewed_posts_ids << pg_res_id.first['last_value'].to_i
  end
end
$logger.info "#{migration_id}: done at #{Time.now - time_before_generation} seconds. Generated #{viewed_posts_ids.count} rows".colorize(:light_cyan)


db.disconnect
