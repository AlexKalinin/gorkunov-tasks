# Executed commands

## Task 1

Create rails (I have rails5 active gemset)
```
rails new .
```

Install bundle to separate folder (non mounted VirtualBox Shared folder)

```
bundle install --path /home/hedin/GEMS/gorkunov-tasks/
```



Generated controllers

```
r g controller welcome index
r g controller time index
```


Will store timezone data in database

```
rails g model town name:string time_zone:integer
```


Create, migrate, seed:

```
rake db:create
rake db:migrate
rake db:seed
```


Testing cache. In rails 5 we have different way to enable it:
(see http://blog.bigbinary.com/2016/01/25/caching-in-development-environment-in-rails5.html)
```
rake tmp:clear
rails dev:cache  #this is the togle!
```

## Taks 1 (pure tcp sockets variant )

For creating binstubs:
```
bundle install --binstubs
```
