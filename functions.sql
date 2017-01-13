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
create or replace FUNCTION FC_GET_ID_COORDINATE 
(PARAM_LATITUDE IN VARCHAR2, PARAM_LONGITUDE IN VARCHAR2, PARAM_ID_PROJECT IN INTEGER) 
RETURN VARCHAR2
IS
COORDINATE_CODE_RET VARCHAR2(25);

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
/

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
  where ar.IATA = L_IATA
  and ar.ID_PROJECT = L_ID_PROJECT
  and ar.ID_COORDINATE = cd.ID_COORDINATE
  and ar.ID_PROJECT = cd.ID_PROJECT;
  
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

-------------------------------------------------------------------

-- function that get the airports
create or replace FUNCTION FC_GET_AIRPORTS (L_ID_PROJECT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  select ar.IATA, ar.NAME, ar.TOWN, ar.COUNTRY, ar.ALTITUDE, cd.COORDINATE_CODE, cd.LATITUDE, cd.LONGITUDE
  from AIRPORT ar, COORDINATE cd
  where ar.ID_PROJECT = L_ID_PROJECT
  and ar.ID_PROJECT = cd.ID_PROJECT
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
/

-- function that get the segment 
CREATE OR REPLACE FUNCTION FC_GET_SEGMENT (L_SEGMENT_CODE IN VARCHAR, L_ID_PROJECT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  SELECT seg.SEGMENT_CODE, seg.WIND_DIRECTION, seg.WIND_INTENSITY, seg.ALTITUDE, c1.COORDINATE_CODE, c1.LATITUDE, c1.LONGITUDE, c2.COORDINATE_CODE, c2.LATITUDE, c2.LONGITUDE 
  FROM SEGMENT seg, COORDINATE c1, COORDINATE c2
  WHERE seg.SEGMENT_CODE = L_SEGMENT_CODE
  AND seg.ID_PROJECT = L_ID_PROJECT
  AND seg.ORIGIN_COORDINATE = c1.ID_COORDINATE
  AND seg.DEST_COORDINATE = c2.ID_COORDINATE;
  
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

-- function that gets the segments 
CREATE OR REPLACE FUNCTION FC_GET_SEGMENTS (L_ID_PROJECT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  SELECT seg.SEGMENT_CODE, seg.WIND_DIRECTION, seg.WIND_INTENSITY, seg.ALTITUDE, c1.COORDINATE_CODE, c1.LATITUDE, c1.LONGITUDE, c2.COORDINATE_CODE, c2.LATITUDE, c2.LONGITUDE 
  FROM SEGMENT seg, COORDINATE c1, COORDINATE c2
  WHERE seg.ID_PROJECT = L_ID_PROJECT
  AND seg.ORIGIN_COORDINATE = c1.ID_COORDINATE
  AND seg.DEST_COORDINATE = c2.ID_COORDINATE;
  
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

-- function that gets a coordinate
CREATE OR REPLACE FUNCTION FC_GET_COORDINATE (L_COORDINATE_CODE IN VARCHAR2, L_ID_PROJECT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN 
  OPEN C1 FOR
  SELECT c.COORDINATE_CODE, c.LATITUDE, c.LONGITUDE, c.ID_PROJECT
  FROM COORDINATE c
  WHERE c.COORDINATE_CODE = L_COORDINATE_CODE
  AND c.ID_PROJECT = L_ID_PROJECT;
  
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

-- function that gets the coordinates of a project
CREATE OR REPLACE FUNCTION FC_GET_COORDINATES (L_ID_PROJECT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN 
  OPEN C1 FOR
  SELECT c.COORDINATE_CODE, c.LATITUDE, c.LONGITUDE, c.ID_PROJECT
  FROM COORDINATE c
  WHERE c.ID_PROJECT = L_ID_PROJECT;
  
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

-- function that gets a project
CREATE OR REPLACE FUNCTION FC_GET_PROJECT (L_ID_PROJECT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  SELECT p.ID_PROJECT, p.NAME, p.DESCRIPTION
  FROM PROJECT p
  WHERE p.ID_PROJECT = L_ID_PROJECT;
  
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