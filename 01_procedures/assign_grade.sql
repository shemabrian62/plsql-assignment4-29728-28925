CREATE OR REPLACE PROCEDURE assign_grade (
    p_student_id IN NUMBER,
    p_course_id  IN NUMBER,
    p_semester   IN VARCHAR2,
    p_grade      IN VARCHAR2
) IS
BEGIN
    UPDATE enrollments
       SET grade = p_grade
     WHERE student_id = p_student_id
       AND course_id  = p_course_id
       AND semester   = p_semester;

    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20020, 'No enrollment found for student ' ||
            p_student_id || ', course ' || p_course_id ||
            ', semester ' || p_semester || '.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Grade updated. SQL%ROWCOUNT = ' || SQL%ROWCOUNT);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2290 THEN
            RAISE_APPLICATION_ERROR(-20021, 'Invalid grade value: ' || p_grade || '.');
        ELSE
            RAISE;
        END IF;
END;
/