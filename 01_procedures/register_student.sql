CREATE OR REPLACE PROCEDURE register_student (
    p_first_name IN students.first_name%TYPE,
    p_last_name  IN students.last_name%TYPE,
    p_email      IN students.email%TYPE,
    p_student_id OUT students.student_id%TYPE
) IS
    TYPE student_rec_type IS RECORD (
        first_name students.first_name%TYPE,
        last_name  students.last_name%TYPE,
        email      students.email%TYPE,
        status     students.status%TYPE
    );
    v_student_rec student_rec_type;
    v_new_id      students.student_id%TYPE;
BEGIN
    IF p_first_name IS NULL OR p_last_name IS NULL OR p_email IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'First name, last name and email are required.');
    END IF;

    v_student_rec.first_name := p_first_name;
    v_student_rec.last_name  := p_last_name;
    v_student_rec.email      := LOWER(p_email);
    v_student_rec.status     := 'ACTIVE';

    v_new_id := seq_students.NEXTVAL;

    INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, status)
    VALUES (v_new_id, v_student_rec.first_name, v_student_rec.last_name,
            v_student_rec.email, SYSDATE, v_student_rec.status);

    IF SQL%ROWCOUNT = 1 AND SQL%FOUND THEN
        p_student_id := v_new_id;
        DBMS_OUTPUT.PUT_LINE('Student registered with ID ' || p_student_id);
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'Student registration did not insert exactly one row.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20003, 'A student with email ' || p_email || ' already exists.');
    WHEN OTHERS THEN
        RAISE;
END;
/