CREATE OR REPLACE FUNCTION FC_GET_FLIGHTS_INFO
  (L_ID_PROJECT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  SELECT  FI.ID_FLIGHT_INFO, FI.DESIGNATOR, FI.FLIGHT_TYPE,
          AO.IATA, AO.NAME, AO.TOWN, AO.COUNTRY, AO.ALTITUDE,
          CAO.COORDINATE_CODE, CAO.LATITUDE, CAO.LONGITUDE,
          AD.IATA, AD.NAME, AD.TOWN, AD.COUNTRY, AD.ALTITUDE,
          CAD.COORDINATE_CODE, CAD.LATITUDE, CAD.LONGITUDE,
          AIRC.ID_AIRCRAFT, AM.MODEL_NAME,
          AIRC.COMPANY, AIRC.MAX_CARGO, AIRC.MAX_CREW
  FROM  FLIGHT_INFO FI, AIRPORT AO, COORDINATE CAO, AIRPORT AD, COORDINATE CAD,
        AIRCRAFT AIRC, AIRCRAFT_MODEL AM
  WHERE FI.ORIGIN_AIRPORT = AO.ID_AIRPORT AND AO.ID_COORDINATE = CAO.ID_COORDINATE
    AND FI.DEST_AIRPORT = AD.ID_AIRPORT AND AD.ID_COORDINATE = CAD.ID_COORDINATE
    AND FI.ID_AIRCRAFT = AIRC.ID_AIRCRAFT
    AND AIRC.ID_AIRCRAFT_MODEL = AM.ID_AIRCRAFT_MODEL
    AND FI.ID_PROJECT = L_ID_PROJECT;

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

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FC_GET_FLIGHT_INFO
  (L_DESIGNATOR IN VARCHAR, L_ID_PROJECT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  SELECT  FI.ID_FLIGHT_INFO, FI.DESIGNATOR, FI.FLIGHT_TYPE,
          AO.IATA, AO.NAME, AO.TOWN, AO.COUNTRY, AO.ALTITUDE,
          CAO.COORDINATE_CODE, CAO.LATITUDE, CAO.LONGITUDE,
          AD.IATA, AD.NAME, AD.TOWN, AD.COUNTRY, AD.ALTITUDE,
          CAD.COORDINATE_CODE, CAD.LATITUDE, CAD.LONGITUDE,
          AIRC.ID_AIRCRAFT, AM.MODEL_NAME,
          AIRC.COMPANY, AIRC.MAX_CARGO, AIRC.MAX_CREW
  FROM  FLIGHT_INFO FI, AIRPORT AO, COORDINATE CAO, AIRPORT AD, COORDINATE CAD,
        AIRCRAFT AIRC, AIRCRAFT_MODEL AM
  WHERE FI.ORIGIN_AIRPORT = AO.ID_AIRPORT AND AO.ID_COORDINATE = CAO.ID_COORDINATE
    AND FI.DEST_AIRPORT = AD.ID_AIRPORT AND AD.ID_COORDINATE = CAD.ID_COORDINATE
    AND FI.ID_AIRCRAFT = AIRC.ID_AIRCRAFT
    AND AIRC.ID_AIRCRAFT_MODEL = AM.ID_AIRCRAFT_MODEL
    AND FI.DESIGNATOR = L_DESIGNATOR AND FI.ID_PROJECT = L_ID_PROJECT;

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

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FC_GET_FLIGHT_STOPS
  (L_ID_FLIGHT_INFO IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  SELECT  A.IATA, A.NAME, A.TOWN, A.COUNTRY, A.ALTITUDE,
          C.COORDINATE_CODE, C.LATITUDE, C.LONGITUDE,
          S.MIN_STOP_MINUTES, S.DEPARTURE_TIME, S.SCHEDULED_ARRIVAL
  FROM  FLIGHT_STOP FS, STOP S, AIRPORT A, COORDINATE C
  WHERE FS.ID_STOP = S.ID_STOP
    AND S.ID_AIRPORT = A.ID_AIRPORT
    AND A.ID_COORDINATE = C.ID_COORDINATE
    AND FS.ID_FLIGHT_INFO = L_ID_FLIGHT_INFO;

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

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FC_GET_WAYPOINTS
  (L_ID_FLIGHT_INFO IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  SELECT  C.COORDINATE_CODE, C.LATITUDE, C.LONGITUDE
  FROM  WAYPOINT W, COORDINATE C
  WHERE W.ID_COORDINATE = C.ID_COORDINATE
    AND W.ID_FLIGHT_INFO = L_ID_FLIGHT_INFO;
  
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

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FC_GET_CLASSES_MAX
  (L_ID_AIRCRAFT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN
  OPEN C1 FOR
  SELECT  MAX_NUMBER_PASSENGERS
  FROM  CLASS
  WHERE ID_AIRCRAFT = L_ID_AIRCRAFT;

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

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION FC_GET_FLIGHT_PATTERNS
  (L_ID_AIRCRAFT IN INTEGER)
RETURN SYS_REFCURSOR
IS
  C1 SYS_REFCURSOR;
BEGIN

  OPEN C1 FOR
  SELECT  ALTITUDE, V_CLIMB, V_DESC, R_DESC
  FROM  FLIGHT_PATTERN
  WHERE ID_AIRCRAFT = L_ID_AIRCRAFT;

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

--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PC_ADD_FLIGHT_INFO
  (L_ID_FLIGHT_INFO OUT INTEGER,
  L_ID_AIRCRAFT OUT INTEGER,
  L_ID_PROJECT IN INTEGER,
  L_DESIGNATOR IN VARCHAR,
  L_ORIGIN_AIRPORT_IATA IN VARCHAR,
  L_DEST_AIRPORT_IATA IN VARCHAR,
  L_FLIGHT_TYPE IN VARCHAR,
  L_AIRCRAFT_MODEL_NAME IN VARCHAR,
  L_COMPANY IN VARCHAR,
  L_MAX_CARGO IN DOUBLE PRECISION,
  L_MAX_CREW IN INTEGER)
IS
  L_ORIGIN_AIRPORT_ID INTEGER;
  L_DEST_AIRPORT_ID INTEGER;
  L_ID_AIRCRAFT_MODEL INTEGER;
BEGIN
  -- GETS ORIGIN ID_AIRPORT
  SELECT ID_AIRPORT INTO L_ORIGIN_AIRPORT_ID FROM AIRPORT
  WHERE IATA = L_ORIGIN_AIRPORT_IATA AND ID_PROJECT = L_ID_PROJECT;
  
  -- GETS DESTINATION ID_AIRPORT
  SELECT ID_AIRPORT INTO L_DEST_AIRPORT_ID FROM AIRPORT
  WHERE IATA = L_DEST_AIRPORT_IATA AND ID_PROJECT = L_ID_PROJECT;
  
  -- GETS ID_AIRCRAFT_MODEL
  SELECT ID_AIRCRAFT_MODEL INTO L_ID_AIRCRAFT_MODEL FROM AIRCRAFT_MODEL
  WHERE MODEL_NAME = L_AIRCRAFT_MODEL_NAME AND ID_PROJECT = L_ID_PROJECT;
  
  -- ADDS AIRCRAFT
  INSERT INTO AIRCRAFT (ID_AIRCRAFT_MODEL, COMPANY, MAX_CARGO, MAX_CREW)
  VALUES (L_ID_AIRCRAFT_MODEL, L_COMPANY, L_MAX_CARGO, L_MAX_CREW)
  RETURNING ID_AIRCRAFT INTO L_ID_AIRCRAFT;
  
  -- ADDS THE FLIGHT INFO
  INSERT INTO FLIGHT_INFO
  (DESIGNATOR, ORIGIN_AIRPORT, DEST_AIRPORT,
  FLIGHT_TYPE, ID_AIRCRAFT, ID_PROJECT)
  VALUES
  (L_DESIGNATOR, L_ORIGIN_AIRPORT_ID, L_DEST_AIRPORT_ID,
  L_FLIGHT_TYPE, L_ID_AIRCRAFT, L_ID_PROJECT)
  RETURNING ID_FLIGHT_INFO INTO L_ID_FLIGHT_INFO;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
END;
/

--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PC_ADD_FLIGHT_PATTERN
  (L_ID_AIRCRAFT IN INTEGER,
  L_ALTITUDE IN DOUBLE PRECISION,
  L_V_CLIMB IN DOUBLE PRECISION,
  L_V_DESC IN DOUBLE PRECISION,
  L_R_DESC IN DOUBLE PRECISION)
IS
BEGIN
  INSERT INTO FLIGHT_PATTERN (ID_AIRCRAFT, ALTITUDE, V_CLIMB, V_DESC, R_DESC)
  VALUES (L_ID_AIRCRAFT, L_ALTITUDE, L_V_CLIMB, L_V_DESC, L_R_DESC);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
END;
/

--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PC_ADD_CLASS
  (L_ID_AIRCRAFT IN INTEGER,
  L_MAX_NUMBER_PASSENGERS IN INTEGER)
IS
BEGIN
  INSERT INTO CLASS (ID_AIRCRAFT, MAX_NUMBER_PASSENGERS)
  VALUES (L_ID_AIRCRAFT, L_MAX_NUMBER_PASSENGERS);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
END;
/

--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PC_ADD_WAYPOINTS
  (L_ID_PROJECT IN INTEGER,
  L_COORDINATE_CODE IN VARCHAR,
  L_ID_FLIGHT_INFO IN INTEGER)
IS
  L_ID_COORDINATE INTEGER;
BEGIN
  -- GETS THE ID_COORDINATE
  SELECT ID_COORDINATE INTO L_ID_COORDINATE FROM COORDINATE
  WHERE ID_PROJECT = L_ID_PROJECT AND COORDINATE_CODE = L_COORDINATE_CODE;
  
  INSERT INTO WAYPOINT (ID_COORDINATE, ID_FLIGHT_INFO)
  VALUES (L_ID_COORDINATE, L_ID_FLIGHT_INFO);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
END;
/

--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE PC_ADD_FLIGHT_STOP
  (L_ID_PROJECT IN INTEGER,
  L_ID_FLIGHT_INFO IN INTEGER,
  L_IATA IN VARCHAR, 
  L_MIN_STOP_MINUTES IN INTEGER,
  L_DEPARTURE_TIME IN DATE, 
  L_SCHEDULED_ARRIVAL IN DATE)
IS
  L_ID_AIRPORT INTEGER;
  L_ID_STOP INTEGER;
BEGIN
  -- GETS THE ID_AIRPORT
  SELECT ID_AIRPORT INTO L_ID_AIRPORT FROM AIRPORT
  WHERE IATA = L_IATA AND ID_PROJECT = L_ID_PROJECT;
  
  -- ADDS STOP
  INSERT INTO STOP
  (ID_AIRPORT, MIN_STOP_MINUTES, DEPARTURE_TIME, SCHEDULED_ARRIVAL)
  VALUES
  (L_ID_AIRPORT, L_MIN_STOP_MINUTES, L_DEPARTURE_TIME, L_SCHEDULED_ARRIVAL)
  RETURNING ID_STOP INTO L_ID_STOP;
  
  -- ADDS FLIGHT STOP
  INSERT INTO FLIGHT_STOP (ID_FLIGHT_INFO, ID_STOP)
  VALUES (L_ID_FLIGHT_INFO, L_ID_STOP);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
END;
/