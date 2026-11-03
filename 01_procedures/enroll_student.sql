CREATE OR REPLACE PROCEDURE enroll_student (
    p_student_id     IN NUMBER,
    p_course_id      IN NUMBER,
    p_semester       IN VARCHAR2,
    p_enrollment_id  OUT NUMBER
) IS
    CURSOR c_student IS
        SELECT student_id FROM students WHERE student_id = p_student_id;
    CURSOR c_course IS
        SELECT * FROM courses WHERE course_id = p_course_id;

    v_student_id      students.student_id%TYPE;
    v_course          courses%ROWTYPE;
    v_current_count   NUMBER;
    v_new_enrollment  NUMBER;

    e_student_not_found EXCEPTION;
    e_course_not_found  EXCEPTION;
    e_course_full       EXCEPTION;
BEGIN
    IF p_semester IS NULL THEN
        RAISE_APPLICATION_ERROR(-20010, 'Semester is required.');
    END IF;

    OPEN c_student;
    FETCH c_student INTO v_student_id;
    IF c_student%NOTFOUND THEN
        CLOSE c_student;
        RAISE e_student_not_found;
    END IF;
    CLOSE c_student;

    OPEN c_course;
    FETCH c_course INTO v_course;
    IF c_course%NOTFOUND THEN
        CLOSE c_course;
        RAISE e_course_not_found;
    END IF;
    CLOSE c_course;

    SELECT COUNT(*)
      INTO v_current_count
      FROM enrollments
     WHERE course_id = p_course_id
       AND semester = p_semester;

    IF v_current_count >= v_course.max_capacity THEN
        RAISE e_course_full;
    END IF;

    v_new_enrollment := seq_enrollments.NEXTVAL;

    INSERT INTO enrollments (enrollment_id, student_id, course_id, semester, grade, enrollment_date)
    VALUES (v_new_enrollment, p_student_id, p_course_id, p_semester, NULL, SYSDATE);

    p_enrollment_id := v_new_enrollment;
    DBMS_OUTPUT.PUT_LINE('Enrollment inserted. SQL%ROWCOUNT = ' || SQL%ROWCOUNT);
EXCEPTION
    WHEN e_student_not_found THEN
        RAISE_APPLICATION_ERROR(-20011, 'Student ID ' || p_student_id || ' does not exist.');
    WHEN e_course_not_found THEN
        RAISE_APPLICATION_ERROR(-20012, 'Course ID ' || p_course_id || ' does not exist.');
    WHEN e_course_full THEN
        RAISE_APPLICATION_ERROR(-20013, 'Course ' || p_course_id ||
            ' is full for semester ' || p_semester || '.');
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20014, 'Student ' || p_student_id ||
            ' is already enrolled in course ' || p_course_id ||
            ' for semester ' || p_semester || '.');
    WHEN OTHERS THEN
        RAISE;
END;
/