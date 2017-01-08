-- Authors
--
-- Daniel Gon�alves - 1151452
-- Eric Amaral - 1141570
-- Ivo Ferro - 1151159
-- Tiago Correia - 1151031

-- Procedure that creates an aircraft model into a given project
CREATE OR REPLACE PROCEDURE PC_CREATE_AIRCRAFT_MODEL
  (ID_PROJECT IN INTEGER, -- project to be inserted in
  ID_AIRCRAFT_MODEL IN VARCHAR,
  DESCRIPTION IN VARCHAR,
  MAKER IN VARCHAR,
  AIRCRAFT_TYPE IN VARCHAR,
  MOTOR IN VARCHAR,
  NUMBER_MOTORS IN INTEGER,
  MOTOR_TYPE IN VARCHAR,
  CRUISE_ALTITUDE IN DOUBLE PRECISION,
  CRUISE_SPEED IN DOUBLE PRECISION,
  TSFC IN DOUBLE PRECISION,
  LAPSE_RATE_FACTOR IN DOUBLE PRECISION,
  THRUST_0 IN DOUBLE PRECISION,
  THRUST_MAX_SPEED IN DOUBLE PRECISION,
  MAX_SPEED IN DOUBLE PRECISION,
  EMPTY_WEIGHT IN DOUBLE PRECISION,
  MTOW IN DOUBLE PRECISION,
  MAX_PAYLOAD IN DOUBLE PRECISION,
  FUEL_CAPACITY IN DOUBLE PRECISION,
  VMO IN DOUBLE PRECISION,
  MMO IN DOUBLE PRECISION,
  WING_AREA IN DOUBLE PRECISION,
  WING_SPAN IN DOUBLE PRECISION,
  ASPECT_RATIO IN DOUBLE PRECISION,
  E IN DOUBLE PRECISION)
IS
  ID_THRUST_FUNCTION INTEGER;
BEGIN
  -- Insert thrust function
  INSERT INTO THRUST_FUNCTION (THRUST_0, THRUST_MAX_SPEED, MAX_SPEED)
  VALUES (THRUST_0, THRUST_MAX_SPEED, MAX_SPEED)
  RETURNING ID_THRUST_FUNCTION
  INTO ID_THRUST_FUNCTION;
  
  -- Insert motorization
  INSERT INTO MOTORIZATION
  (MOTOR, NUMBER_MOTORS, CRUISE_ALTITUDE, CRUISE_SPEED,
  TSFC, LAPSE_RATE_FACTOR, ID_THRUST_FUNCTION)
  VALUES
  (MOTOR, NUMBER_MOTORS, CRUISE_ALTITUDE, CRUISE_SPEED,
  TSFC, LAPSE_RATE_FACTOR, ID_THRUST_FUNCTION);
  
  -- Insert aircraft model
  INSERT INTO AIRCRAFT_MODEL
  (ID_PROJECT, ID_AIRCRAFT_MODEL, DESCRIPTION, MAKER, AIRCRAFT_TYPE, 
  MOTOR, EMPTY_WEIGHT, MTOW, FUEL_CAPACITY, VMO, MMO, WING_AREA, 
  WING_SPAN, ASPECT_RATIO, E)
  VALUES
  (ID_PROJECT, ID_AIRCRAFT_MODEL, DESCRIPTION, MAKER, AIRCRAFT_TYPE, 
  MOTOR, EMPTY_WEIGHT, MTOW, FUEL_CAPACITY, VMO, MMO, WING_AREA, 
  WING_SPAN, ASPECT_RATIO, E);
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
END;
/

-- Procedure that creates a cdrag function
CREATE OR REPLACE PROCEDURE PC_CREATE_CDRAG_FUNCTION
  (CDRAG_0 IN DOUBLE PRECISION,
  SPEED IN DOUBLE PRECISION,
  ID_AIRCRAFT_MODEL IN VARCHAR)
IS
BEGIN
  INSERT INTO CDRAG_FUNCTION (CDRAG_0, SPEED, ID_AIRCRAFT_MODEL)
  VALUES (CDRAG_0, SPEED, ID_AIRCRAFT_MODEL);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
END;
/

-- Procedure that creates an empty project
CREATE OR REPLACE PROCEDURE PC_CREATE_EMPTY_PROJECT
(ID_PROJECT OUT INTEGER, NAME OUT VARCHAR, DESCRIPTION OUT VARCHAR) IS
BEGIN
  INSERT INTO PROJECT (NAME, DESCRIPTION)
  VALUES ('Empty project', 'This is an empty project')
  RETURNING ID_PROJECT, NAME, DESCRIPTION
  INTO ID_PROJECT, NAME, DESCRIPTION;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('There was no data found'||SYSDATE);
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Too many rows'||SYSDATE);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occured'||SYSDATE);
END;
/