CREATE OR REPLACE FUNCTION get_student_gpa (p_student_id IN NUMBER)
RETURN NUMBER IS
    v_student_count NUMBER;
    v_graded_count  NUMBER;
    v_gpa           NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_student_count FROM students WHERE student_id = p_student_id;
    IF v_student_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20060, 'Student ID ' || p_student_id || ' not found.');
    END IF;

    SELECT COUNT(*) INTO v_graded_count
      FROM enrollments WHERE student_id = p_student_id AND grade IS NOT NULL;
    IF v_graded_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20061, 'Student ' || p_student_id ||
            ' has no graded enrollments; GPA is undefined.');
    END IF;

    SELECT SUM(CASE e.grade
                   WHEN 'A'  THEN 4.0 WHEN 'A-' THEN 3.7
                   WHEN 'B+' THEN 3.3 WHEN 'B'  THEN 3.0
                   WHEN 'B-' THEN 2.7 WHEN 'C+' THEN 2.3
                   WHEN 'C'  THEN 2.0 WHEN 'C-' THEN 1.7
                   WHEN 'D+' THEN 1.3 WHEN 'D'  THEN 1.0
                   WHEN 'F'  THEN 0.0 END * c.credits) / SUM(c.credits)
      INTO v_gpa
      FROM enrollments e JOIN courses c ON c.course_id = e.course_id
     WHERE e.student_id = p_student_id AND e.grade IS NOT NULL;

    RETURN ROUND(v_gpa, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20062, 'Student ID ' || p_student_id || ' not found.');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20063, 'Unexpected multiple GPA rows for student ' || p_student_id || '.');
END;
/