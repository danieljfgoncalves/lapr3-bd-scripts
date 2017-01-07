CREATE TABLE PROJECT (
  ID_PROJECT INTEGER GENERATED ALWAYS AS IDENTITY primary key,
  NAME VARCHAR(50) NOT NULL,
  DESCRIPTION VARCHAR(150)
);

create or replace function ConvertDoubleToNumber(nv in NUMBER) return VARCHAR is
OUTP VARCHAR(255);
begin
SELECT REGEXP_REPLACE(nv, '\.', ',') into OUTP from dual;
RETURN OUTP;

   EXCEPTION
    WHEN NOT_LOGGED_ON THEN
      RAISE_APPLICATION_ERROR(-1012, 'Your program issues a database call without being connected to Oracle. '||SYSDATE);
    WHEN PROGRAM_ERROR THEN
      RAISE_APPLICATION_ERROR(-6501, 'THERE WAS A PROBLEM WITH THE DATABASE, PLEASE TRY AGAIN '||SYSDATE);
    WHEN TIMEOUT_ON_RESOURCE THEN
      RAISE_APPLICATION_ERROR(-51, 'CONNECTION EXPIRED'||SYSDATE);
   WHEN INVALID_NUMBER THEN
     raise_application_error (-1722,'the conversion of a character string into a number fails  '||SYSDATE);
    WHEN OTHERS THEN
      raise_application_error (-20002,'An error has occurred on ConvertDoubleToNumber '||SYSDATE);
      
end ConvertDoubleToNumber;


latAux number;
lonAux number;

SELECT to_number(ConvertDoubleToNumber(latitude))into latAux FROM dual;	