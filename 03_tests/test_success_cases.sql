SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
    v_student_id    NUMBER;
    v_enrollment_id NUMBER;
    v_gpa           NUMBER;
    v_count         NUMBER;
    v_success       NUMBER;
    v_errors        NUMBER;
    v_ids           number_table := number_table(3, 4, 5);
    v_random_email  VARCHAR2(100);
BEGIN
    DELETE FROM enrollments WHERE semester = '2027-SPRING';

    DBMS_OUTPUT.PUT_LINE('--- SUCCESS TEST CASES ---');

    v_random_email := 'test_' || DBMS_RANDOM.STRING('X', 5) || '@example.com';
    register_student('New', 'Student', v_random_email, v_student_id);
    DBMS_OUTPUT.PUT_LINE('Registered student ID: ' || v_student_id);

    enroll_student(1, 4, '2027-SPRING', v_enrollment_id);
    DBMS_OUTPUT.PUT_LINE('Created enrollment ID: ' || v_enrollment_id);

    assign_grade(1, 4, '2027-SPRING', 'B');
    DBMS_OUTPUT.PUT_LINE('Grade assigned successfully.');

    DBMS_OUTPUT.PUT_LINE('Full name for student 1: ' || get_student_full_name(1));

    v_count := get_course_enrollment_count(2);
    DBMS_OUTPUT.PUT_LINE('Enrollment count for course 2: ' || v_count);

    v_gpa := get_student_gpa(1);
    DBMS_OUTPUT.PUT_LINE('GPA for student 1: ' || v_gpa);

    DBMS_OUTPUT.PUT_LINE('Grade points for A: ' || calculate_grade_points('A'));

    print_student_enrollments(1);
    list_student_enrollments_bulk(1);

    bulk_enroll_students(v_ids, 2, '2027-SPRING', v_success, v_errors);
    DBMS_OUTPUT.PUT_LINE('Bulk success count: ' || v_success ||
        ', error count: ' || v_errors);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('--- SUCCESS TESTS COMPLETED ---');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error in success test: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/