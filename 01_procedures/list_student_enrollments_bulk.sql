CREATE OR REPLACE PROCEDURE list_student_enrollments_bulk (
    p_student_id IN NUMBER
) IS
    TYPE enrollment_tab_type IS TABLE OF enrollments%ROWTYPE INDEX BY PLS_INTEGER;
    v_enrollments enrollment_tab_type;
BEGIN
    SELECT *
      BULK COLLECT INTO v_enrollments
      FROM enrollments
     WHERE student_id = p_student_id
     ORDER BY semester, course_id;

    IF v_enrollments.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('BULK COLLECT: no enrollments for student ' || p_student_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('BULK COLLECT returned ' || v_enrollments.COUNT ||
            ' row(s) for student ' || p_student_id || ':');
        FOR i IN 1 .. v_enrollments.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                '  Enrollment ' || v_enrollments(i).enrollment_id ||
                ' | course ' || v_enrollments(i).course_id ||
                ' | semester ' || v_enrollments(i).semester ||
                ' | grade ' || NVL(v_enrollments(i).grade, '(none)'));
        END LOOP;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in list_student_enrollments_bulk: ' || SQLERRM);
        RAISE;
END;
/