DROP TABLE IF EXISTS authors;

CREATE TABLE authors(
    id         INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    first_name TEXT    NOT NULL,
    last_name  TEXT    NOT NULL,
    country    TEXT    NOT NULL
);

CREATE UNIQUE INDEX author_idx ON authors(first_name, last_name);

DROP TABLE IF EXISTS books;

CREATE TABLE books(
    id       INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title    TEXT    NOT NULL,
    author   INTEGER NOT NULL REFERENCES authors(id),
    pub_date DATE    NOT NULL,
    isbn     TEXT    NOT NULL
);

CREATE UNIQUE INDEX book_idx ON books(author, title);
