# Task 1

Develope web-server on ruby, which will return current time in UTC.
Also server could take the City Name as argument, and should return it's current time.

Server mast be fast and support of big amount connections.

## Query examples:
```
/time

UTC: 2015-04-11 10:30:50

/time?Moscow,New%20York

UTC: 2015-04-11 10:30:50
Moscow: 2015-04-11 13:30:50
New York: 2015-04-11 02:30:50
```