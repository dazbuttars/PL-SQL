SPOOL apply_plsql_lab4.txt
CREATE OR REPLACE
  TYPE struct AS OBJECT
   (day_name VARCHAR2(8)
   	,gift_name VARCHAR2(24));
/

DECLARE
  /*Declare an array of days and gifts*/
  TYPE days IS TABLE OF VARCHAR2(8);
  TYPE gifts IS TABLE OF STRUCT;

  /* Initialize the collecton of days. */
  lv_days DAYS := days('first'
  								,'second'
  						        ,'third'
  								,'fourth'
  								,'fifth'
 								,'sixth'
  								,'seventh'
  								,'eighth'
 								,'ninth'
  								,'tenth'
  								,'eleventh'
  								,'twelfth');
  /* Initialize the collection of gifts*/
  lv_gifts GIFTS := gifts(struct('and a','Partridge in a pare tree')
  										,struct('Two','Turtle doves')
  										,struct('Three','French hens')
  										,struct('Four','Calling birds')
  										,struct('Five','Golden rings')
  										,struct('Six','Geese a laying')
  										,struct('Seven','Swans a swimming')
  										,struct('Eight','Maids a milking')
  										,struct('Nive','Ladies dancing')
  										,struct('Ten','Lords a leaping')
  										,struct('Eleven','Pipers piping')
  										,struct('Twelve','Drummers drumming'));
BEGIN
  FOR i IN 1..lv_days.COUNT LOOP
    IF lv_days.EXISTS(i) THEN
      dbms_output.put_line('On the '||lv_days(i)||' day of Christmas');
      dbms_output.put_line('my true love sent to me:');
      FOR j IN REVERSE 1..i LOOP
         IF i = 1 THEN
        dbms_output.put_line('-A '||lv_gifts(j).gift_name);
        ELSE
        dbms_output.put_line('-'||lv_gifts(j).day_name||' '||lv_gifts(j).gift_name);
        END IF; 
      END LOOP;
      dbms_output.put_line(CHR(13));
    END IF;
  END LOOP;  
END;
/
SPOOL OFF