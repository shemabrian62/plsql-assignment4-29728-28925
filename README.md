# PL/SQL Assignment IV – Student Registration and Grading

## Group Members
- Shema Brian – Student ID: 29728
- Rubayiza Bonfils Gael – Student ID: 28925

## Application Description
This application manages student registration, course enrollment, and grading. It demonstrates Oracle PL/SQL records, collections, implicit and explicit cursors, bulk processing with BULK COLLECT and FORALL, stored procedures, stored functions, and exception handling.

## Main Features
- Register students with unique email validation.
- Enroll students into courses with capacity checks.
- Assign grades to enrollments.
- Calculate student GPA.
- Print enrollments using explicit cursors.
- Bulk enroll students using FORALL with SAVE EXCEPTIONS.
- Bulk fetch enrollments using BULK COLLECT.
- Handle predefined, user-defined, and application errors.

## How to Run
1. Run `00_schema/01_create_tables.sql`.
2. Run `00_schema/02_insert_sample_data.sql`.
3. Compile procedures in `01_procedures/`.
4. Compile functions in `02_functions/`.
5. Run `03_tests/test_success_cases.sql`.
6. Run `03_tests/test_error_cases.sql`.
7. Capture screenshots into `screenshots/`.

## Test Cases
- Successful student registration.
- Successful enrollment.
- Grade assignment.
- GPA calculation.
- Explicit cursor report.
- BULK COLLECT report.
- FORALL bulk enrollment.
- Duplicate email error.
- Missing student/course error.
- Full course error.
- Missing enrollment error.
- No graded enrollments error.
- TOO_MANY_ROWS error.
- Bulk DML error handling.

## Group Work
Both members contributed to the design, implementation, testing, and presentation of this project.