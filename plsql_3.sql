SET VERIFY OFF
DECLARE
   /*A loocal only scoped collection - that is a list. */
  TYPE listing IS TABLE OF VARCHAR2(100);

  /* After definging the type, declare a variable of the type.*/
   lv_listing LISTING;

  TYPE record_type IS RECORD
   (xnum NUMBER
   ,xdate DATE
   ,xstring VARCHAR2(30));

   /* Declare record */
   three_type   RECORD_TYPE;

   /* Creathe two scalar strings */
   lv_input1 VARCHAR2(100);
   lv_input2 VARCHAR2(100);
   lv_input3 VARCHAR2(100);

BEGIN
    /* assing local variables with subsition variables. */
   lv_input1 := '&1';
   lv_input2 := '&2';
   lv_input3 := '&3';

   /* Instantiate a listing variable, which means create it in me;mory and assign values. */
   /* I declared listing above */ 
   lv_listing := listing(lv_input1, lv_input2, lv_input3);
   
   /* Find date and print date */
   FOR i IN 1..lv_listing.COUNT LOOP

   /*For string*/
     IF REGEXP_LIKE(lv_listing(i),'^[[:digit:]]*$') THEN 
      three_type.xnum := lv_listing(i);

  /*For Number*/
      ELSIF REGEXP_LIKE(lv_listing(i),'^[[:alnum:]]*$') THEN
       three_type.xstring := lv_listing(i);

  /*For Date*/
      ELSIF verify_date(lv_listing(i)) IS NOT NULL THEN
      three_type.xdate := lv_listing(i);

    END IF;

   END LOOP;

       dbms_output.put_line(
            'Record ['||three_type.xnum||'] '||
            '['||three_type.xstring||'] '||
            '['||three_type.xdate||']');

END;
/
QUIT;
