CREATE OR REPLACE PROCEDURE print_student_enrollments (
    p_student_id IN NUMBER
) IS
    CURSOR c_enrollments IS
        SELECT e.enrollment_id, c.course_code, c.course_title, e.semester, e.grade
          FROM enrollments e
          JOIN courses c ON c.course_id = e.course_id
         WHERE e.student_id = p_student_id
         ORDER BY e.semester, c.course_code;

    v_found BOOLEAN := FALSE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Enrollments for student ' || p_student_id || ':');
    FOR r IN c_enrollments LOOP
        v_found := TRUE;
        DBMS_OUTPUT.PUT_LINE(
            '  ' || r.enrollment_id || ' | ' || r.course_code || ' - ' ||
            r.course_title || ' | ' || r.semester ||
            ' | grade=' || NVL(r.grade, '(none)'));
    END LOOP;
    IF NOT v_found THEN
        DBMS_OUTPUT.PUT_LINE('  No enrollments found.');
    END IF;
END;
/