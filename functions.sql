-- Authors
--
-- Daniel Gon�alves - 1151452
-- Eric Amaral - 1141570
-- Ivo Ferro - 1151159
-- Tiago Correia - 1151031

-- get all projects
CREATE OR REPLACE FUNCTION GET_PROJECTS
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  SELECT * FROM PROJECT;
  
  RETURN C1;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
END;
/