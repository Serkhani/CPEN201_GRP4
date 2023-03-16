# Library Management System

This is a PostgreSQL database for a library management system. It contains tables for books, staff, students, and book issues.

# Getting Started
To use this database, you will need to have PostgreSQL installed on your machine.

# Clone this repository.
* Create a new database called "library" in PostgreSQL.
* Execute the SQL code in the file library.sql in your PostgreSQL client of choice. This will create the necessary tables, triggers, and functions.
* Start querying the database!

## Tables
* Books
* ISBN (primary key)
* Title
* Author
* Category
* Price
* Copies
## Staff
* Staff ID (primary key)
* Username
* Staff Job Type
* Email
## Students
* Student ID (primary key)
* Username
* Student Email
* Department
* Balance (default 0)
## Book Issue
* Issue ID (primary key)
* Student ID (foreign key to Students table)
* Book ISBN (foreign key to Books table)
* Due Date

# Functions
## issue_book_func
When a new book issue is added, this function updates the due date to 20 days from the issue date, increments the student's balance by the price of the borrowed book, and decrements the number of copies of the borrowed book.

## return_book_func
When a book issue is deleted, this function decrements the student's balance by the price of the returned book, and increments the number of copies of the returned book.

# Triggers
## issue_book
* Before inserting a new book issue, this trigger executes the issue_book_func function.

## return_book
* Before deleting a book issue, this trigger executes the return_book_func function.
# Notes
The default port for PostgreSQL is 5432.



