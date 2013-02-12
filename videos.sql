create table videos
  (
    id serial8 primary key,
    title varchar(250),
    description varchar(2000),
    url text,
    genre varchar(250)
  );