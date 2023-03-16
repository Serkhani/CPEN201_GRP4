--Creates table for 'books' entity set
CREATE TABLE IF NOT EXISTS books (    
  isbn char(13) PRIMARY KEY NOT NULL,
  title varchar(80) NOT NULL,
  author varchar(80) NOT NULL,
  category varchar(80) NOT NULL,
  price INT NOT NULL,
  copies INT NOT NULL
);

INSERT INTO books (isbn, title, author, category, price, copies)
VALUES
  ('9788654552277', 'X-Men: God Loves, Man Kills', 'Chris', 'Comics', 98, 39),
  ('0964161484100', 'Mike Tyson : Undisputed Truth', 'Larry Sloman, Mike Tyson', 'Sports', 654, 79),
  ('6901142585540', 'V for Vendetta', 'Alan Moore', 'Comics', 600, 23),
  ('9094996245442', 'When Breath Becomes Air', 'Paul Kalanithi', 'Medical', 500, 94),
  ('8653491200700', 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 432, 120);

--Creates table for 'staff' entity set
CREATE TABLE IF NOT EXISTS staff (
  staff_id INT PRIMARY KEY NOT NULL,
  username varchar(20) NOT NULL,
  staff_job_type char(40) NOT NULL
);

INSERT INTO staff (staff_id, username, staff_job_type)
VALUES (175849, 'Vani', 'librarian');

--Creates table for 'students' entity set
CREATE TABLE IF NOT EXISTS students (
  student_id BIGINT PRIMARY KEY NOT NULL,
  username varchar(20) NOT NULL,
  student_email varchar(80) NOT NULL,
  dept VARCHAR(100) NOT NULL,
  balance INT NOT NULL DEFAULT 0 
);

--Creates table for book_issue entity set which records borrowed books and their borrowers
CREATE TABLE IF NOT EXISTS book_issue (
  issue_id BIGSERIAL PRIMARY KEY NOT NULL,
  student_id BIGINT NOT NULL,
  book_isbn varchar(13) NOT NULL,
  due_date date NOT NULL,
  CONSTRAINT fk_student_book FOREIGN KEY(book_isbn) REFERENCES books(isbn)
);

--Creates function to control how data recorded into 'book_issue' table affects 'students' and 'books' tables 
CREATE FUNCTION issue_book_func()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
  NEW.due_date := NEW.due_date + INTERVAL '20 day';
  UPDATE students SET balance = balance + (SELECT price FROM books WHERE isbn = NEW.book_isbn) WHERE student_id = NEW.student_id; 
  UPDATE books SET copies = copies - 1 WHERE isbn = NEW.book_isbn; 
  RETURN NEW;
END;
$$;

--Trigger for issue_book_func() 
CREATE TRIGGER issue_book BEFORE INSERT ON book_issue
FOR EACH ROW
EXECUTE PROCEDURE issue_book_func();

--Creates function to control how data deleted from 'book_issue' table affects 'students' and 'books' tables 
CREATE FUNCTION return_book_func()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
  UPDATE students SET balance = balance - (SELECT price FROM books WHERE isbn = OLD.book_isbn) WHERE student_id = OLD.student_id; -- updated table name and column name
  UPDATE books SET copies = copies + 1 WHERE isbn = OLD.book_isbn;
  RETURN OLD;
END;
$$;

--Trigger for return_book_func() 
CREATE TRIGGER return_book BEFORE DELETE ON book_issue
FOR EACH ROW
EXECUTE PROCEDURE return_book_func();

INSERT INTO students(student_id, username, student_email, dept)
VALUES (1044444, 'Boniface', 'boni@st.ug.edu.gh', 'FPEN'),
(1088888, 'Sedick', 'sed@st.ug.edu.gh', 'CPEN'),
(1077777, 'Umar', 'umar@st.ug.edu.gh', 'MTEN'),
(1066666, 'Beres', 'ber@st.ug.edu.gh', 'BMEN'),
(1055555, 'Luqman', 'luq@st.ug.edu.gh', 'AREN');

ALTER TABLE staff
ADD COLUMN email VARCHAR(80);

SELECT * FROM staff;

SELECT * FROM students;

SELECT * FROM books;

SELECT * FROM book_issue;

INSERT INTO book_issue(student_id, book_isbn, due_date)
VALUES (1044444, '0964161484100', DATE('2023-03-25'));

DELETE FROM book_issue WHERE student_id = 1044444;


