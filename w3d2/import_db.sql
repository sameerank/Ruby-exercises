DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;


CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);


INSERT INTO
  users(fname, lname)
VALUES
  ('John', 'Doe'),
  ('Mary', 'Smith'),
  ('Clifford', 'Dog'),
  ('Garfield', 'Cat'),
  ('Hobbes', 'Tiger');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('Time', 'What time is it?', 1),
  ('Day', 'What day of the week is it?', 2),
  ('Food', 'Fish?', 4),
  ('Life', 'What is the meaning of life?', 4);

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  (1, 2),
  (2, 1),
  (3, 3),
  (3, 4),
  (3, 5);

INSERT INTO
  question_likes(question_id, user_id)
VALUES
  (1, 2),
  (2, 1),
  (3, 5),
  (3, 3),
  (4, 1),
  (4, 5);

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 2, 'It is 11:30'),
  (2, NULL, 1, 'Tuesday!'),
  (1, 1, 1, 'No it is not!'),
  (3, NULL, 2, 'No fish for dinner tonight'),
  (3, 4, 5, 'grrrrrr...rawr'),
  (3, 4, 3, 'veggies for dinner!');
