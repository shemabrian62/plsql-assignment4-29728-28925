BEGIN EXECUTE IMMEDIATE 'DROP TABLE enrollments CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE courses CASCADE CONSTRAINTS';     EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE students CASCADE CONSTRAINTS';    EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_enrollments';              EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_courses';                  EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_students';                 EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TYPE number_table FORCE';               EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE SEQUENCE seq_students START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE seq_courses START WITH 100 INCREMENT BY 1;
CREATE SEQUENCE seq_enrollments START WITH 100 INCREMENT BY 1;

CREATE TABLE students (
    student_id      NUMBER PRIMARY KEY,
    first_name      VARCHAR2(50) NOT NULL,
    last_name       VARCHAR2(50) NOT NULL,
    email           VARCHAR2(100) NOT NULL,
    enrollment_date DATE DEFAULT SYSDATE NOT NULL,
    status          VARCHAR2(10) DEFAULT 'ACTIVE' NOT NULL,
    CONSTRAINT uq_students_email UNIQUE (email),
    CONSTRAINT ck_students_status CHECK (status IN ('ACTIVE','INACTIVE','GRADUATED'))
);

CREATE TABLE courses (
    course_id    NUMBER PRIMARY KEY,
    course_code  VARCHAR2(10) NOT NULL,
    course_title VARCHAR2(100) NOT NULL,
    credits      NUMBER(1) NOT NULL,
    max_capacity NUMBER(3) DEFAULT 30 NOT NULL,
    CONSTRAINT uq_courses_code UNIQUE (course_code),
    CONSTRAINT ck_courses_credits CHECK (credits BETWEEN 1 AND 6),
    CONSTRAINT ck_courses_capacity CHECK (max_capacity > 0)
);

CREATE TABLE enrollments (
    enrollment_id   NUMBER PRIMARY KEY,
    student_id      NUMBER NOT NULL,
    course_id       NUMBER NOT NULL,
    semester        VARCHAR2(10) NOT NULL,
    grade           VARCHAR2(2),
    enrollment_date DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_enr_student FOREIGN KEY (student_id)
        REFERENCES students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enr_course FOREIGN KEY (course_id)
        REFERENCES courses(course_id) ON DELETE CASCADE,
    CONSTRAINT uq_enr_student_course_sem UNIQUE (student_id, course_id, semester),
    CONSTRAINT ck_enr_grade CHECK (
        grade IN ('A','A-','B+','B','B-','C+','C','C-','D+','D','F')
        OR grade IS NULL
    )
);

CREATE OR REPLACE TYPE number_table AS TABLE OF NUMBER;
/