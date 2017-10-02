CREATE TABLE highschooler (
  id serial PRIMARY KEY,
  name text,
  grade int4
);

CREATE TABLE friend (
  id1 int4 REFERENCES highschooler(id),
  id2 int4 REFERENCES highschooler(id),
  PRIMARY KEY (id1, id2)
);

CREATE TABLE likes (
  id1 int4 REFERENCES highschooler(id),
  id2 int4 REFERENCES highschooler(id),
  PRIMARY KEY (id1, id2)
);

TRUNCATE TABLE highschooler CASCADE;
INSERT INTO public.highschooler(id, name, grade) VALUES
  (1, 'Gabriel', 9),
  (2, 'Cassandra', 7),
  (3, 'Olga', 5),
  (4, 'Petr', 2),
  (5, 'Konstantin', 7),
  (6, 'Alex', 7),
  (7, 'Bob', 9),
  (8, 'Max', 1),
  (9, 'Alice', 1),
  (10, 'Olga', 2),
  (11, 'Petr', 3);
    
TRUNCATE TABLE friend;
INSERT INTO public.friend(id1, id2) VALUES
  (1, 7),
  (7, 1),
  (2, 3),
  (3, 2),
  (2, 5),
  (5, 2),
  (3, 5),
  (5, 3),
  (5, 4),
  (4, 5),
  (3, 11),
  (11, 3),
  (4, 6),
  (6, 4),
  (7, 8),
  (8, 7);
    
TRUNCATE TABLE likes;
INSERT INTO public.likes(id1, id2) VALUES
  (2, 3),
  (1, 8),
  (9, 3),
  (7, 2),
  (5, 9),
  (9, 5),
  (6, 5);
