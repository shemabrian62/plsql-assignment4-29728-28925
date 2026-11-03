SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
    v_student_id    NUMBER;
    v_enrollment_id NUMBER;
    v_success       NUMBER;
    v_errors        NUMBER;
    v_bad_ids       number_table := number_table(3, 999);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- ERROR TEST CASES ---');

    BEGIN register_student('Alice', 'Mutoni', 'alice.mutoni@example.com', v_student_id);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Expected duplicate email error: ' || SQLERRM); END;

    BEGIN enroll_student(999, 2, '2027-SPRING', v_enrollment_id);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Expected missing student error: ' || SQLERRM); END;

    BEGIN enroll_student(5, 1, '2026-FALL', v_enrollment_id);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Expected full course error: ' || SQLERRM); END;

    BEGIN assign_grade(5, 99, '2027-SPRING', 'A');
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Expected missing enrollment error: ' || SQLERRM); END;

    BEGIN DBMS_OUTPUT.PUT_LINE(get_student_gpa(5));
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Expected no graded enrollments error: ' || SQLERRM); END;

    BEGIN DBMS_OUTPUT.PUT_LINE(get_student_id_by_name('John', 'Doe'));
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Expected TOO_MANY_ROWS error: ' || SQLERRM); END;

    BEGIN bulk_enroll_students(v_bad_ids, 2, '2027-SPRING', v_success, v_errors);
          DBMS_OUTPUT.PUT_LINE('Bulk success count: ' || v_success ||
              ', error count: ' || v_errors);
    EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unexpected bulk error: ' || SQLERRM); END;

    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('--- ERROR TESTS COMPLETED ---');
END;
/