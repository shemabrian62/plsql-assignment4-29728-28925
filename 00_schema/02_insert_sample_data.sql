INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, status)
VALUES (1, 'Alice', 'Mutoni', 'alice.mutoni@example.com', DATE '2026-08-15', 'ACTIVE');
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, status)
VALUES (2, 'Bob', 'Kagabo', 'bob.kagabo@example.com', DATE '2026-08-15', 'ACTIVE');
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, status)
VALUES (3, 'John', 'Doe', 'john.doe1@example.com', DATE '2026-08-16', 'ACTIVE');
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, status)
VALUES (4, 'John', 'Doe', 'john.doe2@example.com', DATE '2026-08-16', 'ACTIVE');
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, status)
VALUES (5, 'Grace', 'Uwase', 'grace.uwase@example.com', DATE '2026-08-17', 'ACTIVE');

INSERT INTO courses (course_id, course_code, course_title, credits, max_capacity)
VALUES (1, 'CS101', 'Introduction to Programming', 3, 2);
INSERT INTO courses (course_id, course_code, course_title, credits, max_capacity)
VALUES (2, 'DB201', 'Database Systems', 4, 30);
INSERT INTO courses (course_id, course_code, course_title, credits, max_capacity)
VALUES (3, 'MATH101', 'Calculus I', 3, 30);
INSERT INTO courses (course_id, course_code, course_title, credits, max_capacity)
VALUES (4, 'ENG101', 'Academic English', 2, 30);

INSERT INTO enrollments (enrollment_id, student_id, course_id, semester, grade, enrollment_date)
VALUES (1, 3, 1, '2026-FALL', NULL, DATE '2026-09-01');
INSERT INTO enrollments (enrollment_id, student_id, course_id, semester, grade, enrollment_date)
VALUES (2, 4, 1, '2026-FALL', NULL, DATE '2026-09-01');
INSERT INTO enrollments (enrollment_id, student_id, course_id, semester, grade, enrollment_date)
VALUES (3, 1, 2, '2026-FALL', 'A', DATE '2026-09-02');
INSERT INTO enrollments (enrollment_id, student_id, course_id, semester, grade, enrollment_date)
VALUES (4, 2, 2, '2026-FALL', 'B+', DATE '2026-09-02');
INSERT INTO enrollments (enrollment_id, student_id, course_id, semester, grade, enrollment_date)
VALUES (5, 1, 3, '2026-FALL', 'A-', DATE '2026-09-03');

COMMIT;