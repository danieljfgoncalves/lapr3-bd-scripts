-- Authors
--
-- Daniel Gon�alves - 1151452
-- Eric Amaral - 1141570
-- Ivo Ferro - 1151159
-- Tiago Correia - 1151031

-- get all projects
CREATE OR REPLACE FUNCTION FC_GET_PROJECTS
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  SELECT ID_PROJECT, NAME, DESCRIPTION
  FROM PROJECT;
  
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

----------------------------------------------------------

-- function that receives the latitude and longitude of a coordinate and returns its ID
CREATE OR REPLACE FUNCTION FC_GET_ID_COORDINATE 
(PARAM_LATITUDE IN FLOAT, PARAM_LONGITUDE IN FLOAT, PARAM_ID_PROJECT IN INTEGER) 
RETURN VARCHAR IS COORDINATE_CODE_RET VARCHAR(25);

BEGIN

  SELECT c.COORDINATE_CODE INTO COORDINATE_CODE_RET
  FROM COORDINATE c
  WHERE c.LATITUDE = PARAM_LATITUDE 
  AND c.LONGITUDE = PARAM_LONGITUDE
  AND c.ID_PROJECT = PARAM_ID_PROJECT;
  
  RETURN COORDINATE_CODE_RET;
 
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
   WHEN TOO_MANY_ROWS THEN
     DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
   WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
     
END FC_GET_ID_COORDINATE;

-------------------------------------------------------------------

-- function that get the airport 
create or replace FUNCTION FC_GET_AIRPORT (L_IATA IN VARCHAR, L_ID_PROJECT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  select ar.IATA, ar.NAME, ar.TOWN, ar.COUNTRY, ar.ALTITUDE, cd.COORDINATE_CODE, cd.LATITUDE, cd.LONGITUDE
  from AIRPORT ar, COORDINATE cd
  where ar.ID_PROJECT = cd.ID_PROJECT
  and ar.ID_COORDINATE = cd.ID_COORDINATE;
  
  RETURN C1;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
END;
