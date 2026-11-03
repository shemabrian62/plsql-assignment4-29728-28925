CREATE OR REPLACE FUNCTION get_student_id_by_name (
    p_first_name IN VARCHAR2,
    p_last_name  IN VARCHAR2
) RETURN NUMBER IS
    v_student_id students.student_id%TYPE;
BEGIN
    SELECT student_id INTO v_student_id
      FROM students
     WHERE first_name = p_first_name AND last_name = p_last_name;
    RETURN v_student_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20080, 'No student named ' ||
            p_first_name || ' ' || p_last_name || '.');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20081, 'Multiple students named ' ||
            p_first_name || ' ' || p_last_name || '; ID is ambiguous.');
END;
/