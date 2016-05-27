# Ruby on Rails Employment Test Tasks

## Task 1

Develope web-server on ruby, which will return current time in UTC.
Also server could take the City Name as argument, and should return it's current time.

Server mast be fast and support of big amount connections.

**Query examples:**
```
/time

UTC: 2015-04-11 10:30:50

/time?Moscow,New%20York

UTC: 2015-04-11 10:30:50
Moscow: 2015-04-11 13:30:50
New York: 2015-04-11 02:30:50
```


## Task 2

There is table `likes`:

```
user_id: integer, 
post_id: integer, 
created_at: datetime, 
updated_at: datetime
```

This table contains about several millions records.
Server executes serveral different queries by this table with execution time greater then 1 second.

Queries are:

```sql
 SELECT COUNT(*) FROM likes WHERE user_id = ?
  SELECT COUNT(*) FROM likes WHERE post_id = ?
  SELECT * FROM likes WHERE user_id = ? AND post_id = ?
```

How to know, why queries are slow? How to speed up them? Provide all possible variants

You can use any of the relative DBMS (like PostgreSQL, MySQL, Oracle, etc)

## Task 3

There is query:

```sql
  SELECT * from pending_posts 
    WHERE user_id <> ?
      AND NOT approved
      AND NOT banned
      AND pending_posts.id NOT IN(
        SELECT pending_post_id FROM viewed_posts
          WHERE user_id = ?)
```


Which indexes we shuld create? How to change the query for maximum performance?

You can use any of the relative DBMS (like PostgreSQL, MySQL, Oracle, etc)