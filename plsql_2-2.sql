SET SERVEROUTPUT ON SIZE UNLIMITED

SET VERIFY OFF
DECLARE
     lv_raw_input VARCHAR2(4000);
     lv_input VARCHAR2(10);
BEGIN
     lv_raw_input :='&1';
   IF Length(lv_raw_input) < 10 THEN
     lv_input := lv_raw_input;
     dbms_output.put_line('Hello '||lv_input||'!');
   ELSIF Length(lv_raw_input) > 11 THEN
     lv_input := SUBSTR(lv_raw_input,1,10);
     dbms_output.put_line('Hello '||lv_input||'!');
   ELSE
     dbms_output.put_line('Hello World!');
   END IF;
END;
/
QUIT;
