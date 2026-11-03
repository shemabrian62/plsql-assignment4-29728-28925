# Implementation and Performance Notes

**Group:** Shema Brian (29728) and Rubayiza Bonfils Gael (28925)

## Records
The `register_student` procedure uses a user-defined PL/SQL record type `student_rec_type` to hold related student fields before insertion. The `enroll_student` procedure uses `courses%ROWTYPE` to fetch a full course row with an explicit cursor.

## Collections
The solution uses:
- A SQL nested table type `number_table` as a stored procedure parameter for bulk enrollment.
- An associative array of a user-defined record type in `bulk_enroll_students`.
- An associative array of `enrollments%ROWTYPE` in `list_student_enrollments_bulk`.

## Implicit Cursors
Implicit cursor attributes are used:
- `SQL%ROWCOUNT` after INSERT and UPDATE.
- `SQL%FOUND` after registration insert.
- `SQL%NOTFOUND` after grade update to detect a missing enrollment.

## Explicit Cursors
`enroll_student` uses explicit cursors with `OPEN`, `FETCH`, `CLOSE` to validate the student and course. `print_student_enrollments` uses an explicit cursor FOR loop to process multiple enrollment rows.

## Bulk Processing
`list_student_enrollments_bulk` uses `BULK COLLECT` to fetch multiple rows in one operation.

`bulk_enroll_students` uses `FORALL ... SAVE EXCEPTIONS` to insert multiple rows. Bulk processing reduces context switches between PL/SQL and SQL, improving performance compared with row-by-row DML.

Bulk DML errors are handled with exception code `-24381`, and `SQL%BULK_EXCEPTIONS` reports failing student IDs and Oracle error messages.

## Exception Handling
- Predefined: `NO_DATA_FOUND`, `TOO_MANY_ROWS`, `DUP_VAL_ON_INDEX`.
- User-defined: missing student, missing course, full course.
- `RAISE_APPLICATION_ERROR` for business errors.
- `WHEN OTHERS THEN RAISE` to avoid hiding unexpected errors.

## Testing
Success tests cover registration, enrollment, grading, GPA, explicit cursors, BULK COLLECT, and FORALL. Error tests cover duplicate email, missing student, full course, missing enrollment, no graded enrollments, TOO_MANY_ROWS, and bulk DML errors.