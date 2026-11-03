CREATE OR REPLACE FUNCTION calculate_grade_points (p_grade IN VARCHAR2)
RETURN NUMBER IS
BEGIN
    CASE p_grade
        WHEN 'A'  THEN RETURN 4.0;
        WHEN 'A-' THEN RETURN 3.7;
        WHEN 'B+' THEN RETURN 3.3;
        WHEN 'B'  THEN RETURN 3.0;
        WHEN 'B-' THEN RETURN 2.7;
        WHEN 'C+' THEN RETURN 2.3;
        WHEN 'C'  THEN RETURN 2.0;
        WHEN 'C-' THEN RETURN 1.7;
        WHEN 'D+' THEN RETURN 1.3;
        WHEN 'D'  THEN RETURN 1.0;
        WHEN 'F'  THEN RETURN 0.0;
        ELSE RAISE_APPLICATION_ERROR(-20040, 'Invalid grade: ' || p_grade);
    END CASE;
END;
/