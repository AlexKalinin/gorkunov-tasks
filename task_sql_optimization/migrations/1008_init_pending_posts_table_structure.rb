migration_id = '[Migration 1008_init_pending_posts_table_structure.rb]'

$logger.info "#{migration_id}: Strarting migration"

sql = <<END_SQL.gsub(/\s+/, ' ').strip

CREATE TABLE posts
(
  id serial NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  CONSTRAINT posts_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);


CREATE TABLE users
(
  id serial NOT NULL,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  CONSTRAINT users_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);



CREATE TABLE pending_posts
(
  id serial NOT NULL,
  post_id integer NOT NULL,
  user_id integer NOT NULL,
  approved smallint NOT NULL,
  banned smallint NOT NULL,
  CONSTRAINT pending_posts_pkey PRIMARY KEY (id),
  CONSTRAINT pending_posts_post_id_fkey FOREIGN KEY (post_id)
      REFERENCES posts (id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT pending_posts_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES users (id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);




CREATE TABLE viewed_posts
(
  id serial NOT NULL,
  user_id integer NOT NULL,
  pending_post_id integer NOT NULL,
  CONSTRAINT viewed_posts_pkey PRIMARY KEY (id),
  CONSTRAINT viewed_posts_pending_post_id_fkey FOREIGN KEY (pending_post_id)
      REFERENCES pending_posts (id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT viewed_posts_user_id_fkey FOREIGN KEY (user_id)
      REFERENCES users (id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);

END_SQL


db = DbHelper.new $APP_CONFIG['pg_host'], $APP_CONFIG['pg_port'], $APP_CONFIG['pg_login'],
                  $APP_CONFIG['pg_password'], $APP_CONFIG['pg_database']
db.exec_query(sql)
db.disconnect