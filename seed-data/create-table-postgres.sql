 CREATE TABLE books (
    book_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(100) NOT NULL
 );