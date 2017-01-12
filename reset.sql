-- Authors
--
-- Daniel Gon�alves - 1151452
-- Eric Amaral - 1141570
-- Ivo Ferro - 1151159
-- Tiago Correia - 1151031

-- ### DELETE TABLES ###

DROP TABLE FLIGHT_PLAN;
DROP TABLE AIRCRAFT_CLASS;
DROP TABLE FLIGHT_SIMULATION;
DROP TABLE WAYPOINT;
DROP TABLE FLIGHT_STOP;
DROP TABLE FLIGHT_INFO;
DROP TABLE FLIGHT_TYPE;
DROP TABLE CLASS;
DROP TABLE FLIGHT_PATTERN;
DROP TABLE AIRCRAFT;
DROP TABLE STOP;
DROP TABLE AIRPORT;
DROP TABLE SEGMENT;
DROP TABLE COORDINATE;
DROP TABLE CDRAG_FUNCTION;
DROP TABLE AIRCRAFT_MODEL;
DROP TABLE AIRCRAFT_TYPE;
DROP TABLE MOTORIZATION;
DROP TABLE THRUST_FUNCTION;
DROP TABLE MOTOR_TYPE;
DROP TABLE PROJECT;

-- ### CREATE TABLES ###

CREATE TABLE PROJECT (
  ID_PROJECT INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  NAME VARCHAR(50) NOT NULL,
  DESCRIPTION VARCHAR(150)
);

CREATE TABLE MOTOR_TYPE (
  TYPE VARCHAR(25) PRIMARY KEY
);

CREATE TABLE THRUST_FUNCTION (
  ID_THRUST_FUNCTION INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  THRUST_0 DOUBLE PRECISION NOT NULL,
  THRUST_MAX_SPEED DOUBLE PRECISION NOT NULL,
  MAX_SPEED DOUBLE PRECISION NOT NULL
);

CREATE TABLE MOTORIZATION (
  ID_MOTORIZATION INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  MOTOR VARCHAR(50) NOT NULL,
  NUMBER_MOTORS INTEGER NOT NULL,
  MOTOR_TYPE VARCHAR(25) NOT NULL REFERENCES MOTOR_TYPE(TYPE),
  CRUISE_ALTITUDE DOUBLE PRECISION NOT NULL,
  CRUISE_SPEED DOUBLE PRECISION NOT NULL,
  TSFC DOUBLE PRECISION NOT NULL,
  LAPSE_RATE_FACTOR DOUBLE PRECISION NOT NULL,
  ID_THRUST_FUNCTION INTEGER NOT NULL REFERENCES THRUST_FUNCTION(ID_THRUST_FUNCTION) ON DELETE CASCADE
);

CREATE TABLE AIRCRAFT_TYPE (
  TYPE VARCHAR(25) PRIMARY KEY
);

CREATE TABLE AIRCRAFT_MODEL (
  ID_AIRCRAFT_MODEL INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  MODEL_NAME VARCHAR(25) NOT NULL,
  DESCRIPTION VARCHAR(150) NOT NULL,
  MAKER VARCHAR(50) NOT NULL,
  AIRCRAFT_TYPE VARCHAR(25) NOT NULL REFERENCES AIRCRAFT_TYPE(TYPE),
  ID_MOTORIZATION INTEGER NOT NULL REFERENCES MOTORIZATION(ID_MOTORIZATION) ON DELETE CASCADE,
  EMPTY_WEIGHT DOUBLE PRECISION NOT NULL,
  MTOW DOUBLE PRECISION NOT NULL,
  MAX_PAYLOAD DOUBLE PRECISION NOT NULL,
  FUEL_CAPACITY DOUBLE PRECISION NOT NULL,
  VMO DOUBLE PRECISION NOT NULL,
  MMO DOUBLE PRECISION NOT NULL,
  WING_AREA DOUBLE PRECISION NOT NULL,
  WING_SPAN DOUBLE PRECISION NOT NULL,
  ASPECT_RATIO DOUBLE PRECISION NOT NULL,
  E DOUBLE PRECISION NOT NULL,
  ID_PROJECT INTEGER NOT NULL REFERENCES PROJECT(ID_PROJECT) ON DELETE CASCADE
);

CREATE TABLE CDRAG_FUNCTION (
  CDRAG_0 DOUBLE PRECISION NOT NULL,
  SPEED DOUBLE PRECISION NOT NULL,
  ID_AIRCRAFT_MODEL INTEGER NOT NULL REFERENCES AIRCRAFT_MODEL(ID_AIRCRAFT_MODEL) ON DELETE CASCADE,
  CONSTRAINT PK_CDRAG_FUNCTION PRIMARY KEY (CDRAG_0, SPEED, ID_AIRCRAFT_MODEL)
);

CREATE TABLE COORDINATE (
  ID_COORDINATE INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  COORDINATE_CODE VARCHAR(25) NOT NULL,
  LATITUDE VARCHAR(12) NOT NULL,
  LONGITUDE VARCHAR(12) NOT NULL,
  ID_PROJECT INTEGER NOT NULL REFERENCES PROJECT(ID_PROJECT) ON DELETE CASCADE
);

CREATE TABLE SEGMENT (
  ID_SEGMENT INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  SEGMENT_CODE VARCHAR(25) NOT NULL,
  ORIGIN_COORDINATE INTEGER NOT NULL REFERENCES COORDINATE(ID_COORDINATE) ON DELETE CASCADE,
  DEST_COORDINATE INTEGER NOT NULL REFERENCES COORDINATE(ID_COORDINATE) ON DELETE CASCADE,
  WIND_DIRECTION DOUBLE PRECISION NOT NULL,
  WIND_INTENSITY DOUBLE PRECISION NOT NULL,
  ALTITUDE DOUBLE PRECISION NOT NULL,
  ID_PROJECT INTEGER NOT NULL REFERENCES PROJECT(ID_PROJECT) ON DELETE CASCADE
);

CREATE TABLE AIRPORT (
  ID_AIRPORT INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  IATA CHAR(3) NOT NULL,
  NAME VARCHAR(50) NOT NULL,
  TOWN VARCHAR(50) NOT NULL,
  COUNTRY VARCHAR(50) NOT NULL,
  ALTITUDE DOUBLE PRECISION,
  ID_COORDINATE INTEGER NOT NULL REFERENCES COORDINATE(ID_COORDINATE) ON DELETE CASCADE,
  ID_PROJECT INTEGER NOT NULL REFERENCES PROJECT(ID_PROJECT) ON DELETE CASCADE
);

CREATE TABLE STOP (
  ID_STOP INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ID_AIRPORT INTEGER NOT NULL REFERENCES AIRPORT(ID_AIRPORT) ON DELETE CASCADE,
  MIN_STOP_MINUTES INTEGER NOT NULL,
  DEPARTURE_TIME DATE,
  SCHEDULED_ARRIVAL DATE
);

CREATE TABLE AIRCRAFT (
  ID_AIRCRAFT INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ID_AIRCRAFT_MODEL INTEGER NOT NULL REFERENCES AIRCRAFT_MODEL(ID_AIRCRAFT_MODEL) ON DELETE CASCADE,
  COMPANY VARCHAR(50) NOT NULL,
  MAX_CARGO DOUBLE PRECISION NOT NULL,
  MAX_CREW DOUBLE PRECISION NOT NULL
);

CREATE TABLE FLIGHT_PATTERN (
  ID_FLIGHT_PATTERN INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ID_AIRCRAFT INTEGER NOT NULL REFERENCES AIRCRAFT(ID_AIRCRAFT) ON DELETE CASCADE,
  ALTITUDE DOUBLE PRECISION NOT NULL,
  V_CLIMB DOUBLE PRECISION NOT NULL,
  V_DESC DOUBLE PRECISION NOT NULL,
  R_DESC DOUBLE PRECISION NOT NULL
);

CREATE TABLE CLASS (
  ID_CLASS INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ID_AIRCRAFT INTEGER NOT NULL REFERENCES AIRCRAFT(ID_AIRCRAFT) ON DELETE CASCADE,
  MAX_NUMBER_PASSENGERS INTEGER NOT NULL
);

CREATE TABLE FLIGHT_TYPE (
  TYPE VARCHAR(25) PRIMARY KEY
);

CREATE TABLE FLIGHT_INFO (
  ID_FLIGHT_INFO INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  DESIGNATOR VARCHAR(7) NOT NULL,
  ORIGIN_AIRPORT INTEGER NOT NULL REFERENCES AIRPORT(ID_AIRPORT) ON DELETE CASCADE,
  DEST_AIRPORT INTEGER NOT NULL REFERENCES AIRPORT(ID_AIRPORT) ON DELETE CASCADE,
  FLIGHT_TYPE VARCHAR(25) NOT NULL REFERENCES FLIGHT_TYPE(TYPE),
  ID_AIRCRAFT INTEGER NOT NULL REFERENCES AIRCRAFT(ID_AIRCRAFT) ON DELETE CASCADE,
  ID_PROJECT INTEGER NOT NULL REFERENCES PROJECT(ID_PROJECT) ON DELETE CASCADE
);

CREATE TABLE FLIGHT_STOP (
  ID_FLIGHT_INFO INTEGER NOT NULL REFERENCES FLIGHT_INFO(ID_FLIGHT_INFO) ON DELETE CASCADE,
  ID_STOP INTEGER NOT NULL REFERENCES STOP(ID_STOP) ON DELETE CASCADE,
  CONSTRAINT PK_FLIGHT_STOP PRIMARY KEY (ID_FLIGHT_INFO, ID_STOP)
);

CREATE TABLE WAYPOINT (
  ID_COORDINATE INTEGER NOT NULL REFERENCES COORDINATE(ID_COORDINATE) ON DELETE CASCADE,
  ID_FLIGHT_INFO INTEGER NOT NULL REFERENCES FLIGHT_INFO(ID_FLIGHT_INFO) ON DELETE CASCADE,
  CONSTRAINT PK_WAYPOINT PRIMARY KEY (ID_COORDINATE, ID_FLIGHT_INFO)
);

CREATE TABLE FLIGHT_SIMULATION (
  ID_FLIGHT_SIMULATION INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ID_FLIGHT_INFO INTEGER NOT NULL REFERENCES FLIGHT_INFO(ID_FLIGHT_INFO) ON DELETE CASCADE,
  SCHEDULED_ARRIVAL DATE NOT NULL,
  DEPARTURE_DATE DATE NOT NULL,
  EFFECTIVE_CREW INTEGER NOT NULL,
  EFFECTIVE_CARGO DOUBLE PRECISION NOT NULL,
  EFFECTIVE_FUEL DOUBLE PRECISION NOT NULL,
  ID_PROJECT INTEGER NOT NULL REFERENCES PROJECT(ID_PROJECT) ON DELETE CASCADE
);

CREATE TABLE AIRCRAFT_CLASS (
  ID_CLASS INTEGER NOT NULL REFERENCES CLASS(ID_CLASS) ON DELETE CASCADE,
  ID_FLIGHT_SIMULATION INTEGER NOT NULL REFERENCES FLIGHT_SIMULATION(ID_FLIGHT_SIMULATION) ON DELETE CASCADE,
  NUMBER_PASSENGERS INTEGER NOT NULL,
  CONSTRAINT PK_AIRCRAFT_CLASS PRIMARY KEY (ID_CLASS, ID_FLIGHT_SIMULATION)
);

CREATE TABLE FLIGHT_PLAN (
  ID_SEGMENT INTEGER NOT NULL REFERENCES SEGMENT(ID_SEGMENT) ON DELETE CASCADE,
  ID_FLIGHT_SIMULATION INTEGER NOT NULL REFERENCES FLIGHT_SIMULATION(ID_FLIGHT_SIMULATION) ON DELETE CASCADE,
  SEGMENT_ORDER INTEGER NOT NULL,
  CONSTRAINT PK_FLIGHT_PLAN PRIMARY KEY (ID_SEGMENT, ID_FLIGHT_SIMULATION)
);