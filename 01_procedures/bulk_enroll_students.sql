CREATE OR REPLACE PROCEDURE bulk_enroll_students (
    p_student_ids   IN number_table,
    p_course_id     IN NUMBER,
    p_semester      IN VARCHAR2,
    p_success_count OUT NUMBER,
    p_error_count   OUT NUMBER
) IS
    TYPE enrollment_rec_type IS RECORD (
        student_id NUMBER,
        course_id  NUMBER,
        semester   VARCHAR2(15)
    );
    TYPE enrollment_tab_type IS TABLE OF enrollment_rec_type INDEX BY PLS_INTEGER;
    v_enrollments enrollment_tab_type;

    e_bulk_errors EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_bulk_errors, -24381);

    v_course_exists NUMBER;
    v_max_capacity  courses.max_capacity%TYPE;
    v_current_count NUMBER;
BEGIN
    IF p_student_ids IS NULL OR p_student_ids.COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20030, 'No student IDs supplied for bulk enrollment.');
    END IF;
    IF p_semester IS NULL THEN
        RAISE_APPLICATION_ERROR(-20031, 'Semester is required.');
    END IF;

    SELECT COUNT(*) INTO v_course_exists FROM courses WHERE course_id = p_course_id;
    IF v_course_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20032, 'Course ID ' || p_course_id || ' does not exist.');
    END IF;

    SELECT max_capacity INTO v_max_capacity FROM courses WHERE course_id = p_course_id;

    SELECT COUNT(*) INTO v_current_count
      FROM enrollments WHERE course_id = p_course_id AND semester = p_semester;

    IF v_current_count + p_student_ids.COUNT > v_max_capacity THEN
        RAISE_APPLICATION_ERROR(-20033, 'Bulk enrollment exceeds capacity. Available=' ||
            (v_max_capacity - v_current_count) ||
            ', requested=' || p_student_ids.COUNT || '.');
    END IF;

    FOR i IN 1 .. p_student_ids.COUNT LOOP
        v_enrollments(i).student_id := p_student_ids(i);
        v_enrollments(i).course_id  := p_course_id;
        v_enrollments(i).semester   := p_semester;
    END LOOP;

    FORALL i IN 1 .. v_enrollments.COUNT SAVE EXCEPTIONS
        INSERT INTO enrollments (enrollment_id, student_id, course_id, semester, grade, enrollment_date)
        VALUES (seq_enrollments.NEXTVAL, v_enrollments(i).student_id,
                v_enrollments(i).course_id, v_enrollments(i).semester, NULL, SYSDATE);

    p_success_count := v_enrollments.COUNT;
    p_error_count   := 0;
    DBMS_OUTPUT.PUT_LINE('FORALL inserted ' || p_success_count || ' enrollment(s).');
EXCEPTION
    WHEN e_bulk_errors THEN
        p_error_count   := SQL%BULK_EXCEPTIONS.COUNT;
        p_success_count := v_enrollments.COUNT - p_error_count;
        DBMS_OUTPUT.PUT_LINE('FORALL completed with ' || p_error_count ||
            ' error(s); success count=' || p_success_count || '.');
        FOR i IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                '  Bulk error index ' || SQL%BULK_EXCEPTIONS(i).ERROR_INDEX ||
                ' (student ID ' || v_enrollments(SQL%BULK_EXCEPTIONS(i).ERROR_INDEX).student_id || '): ' ||
                SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
        END LOOP;
    WHEN OTHERS THEN
        RAISE;
END;
/