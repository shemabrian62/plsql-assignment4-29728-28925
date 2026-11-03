CREATE OR REPLACE FUNCTION get_student_full_name (p_student_id IN NUMBER)
RETURN VARCHAR2 IS
    v_name VARCHAR2(120);
BEGIN
    SELECT first_name || ' ' || last_name
      INTO v_name FROM students WHERE student_id = p_student_id;
    RETURN v_name;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20070, 'Student ID ' || p_student_id || ' not found.');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20071, 'Multiple students found for ID ' || p_student_id || '.');
END;
/