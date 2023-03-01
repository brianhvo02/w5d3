PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;


CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes(
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO 
    users (fname,lname)

VALUES
    ('Brian','Vo'),
    ('Ryder','Aguilera');

INSERT INTO
    questions (title,body,author_id)
VALUES 
    ('SQL','Why does my database crash?', 1),
    ('Ruby','Where is my extra end?', 2);

INSERT INTO 
    question_follows (question_id,user_id)
VALUES 
    (1,1),
    (1,2),
    (2,1),
    (2,2);

INSERT INTO 
    replies (body,user_id,question_id,parent_reply_id)
VALUES 
    ('Run SQL Lite',2,1,NULL),
    ('Thanks for your help',1,1,1),
    ('At the end',1,2,NULL);

INSERT INTO 
    question_likes (user_id,question_id)
VALUES 
    (2,1),
    (1,1),
    (1,2);



