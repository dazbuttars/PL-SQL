@/home/student/Data/cit325/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit325/oracle/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- 0
-- Validate the state of system_user table
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';

-- update to ensure the iterative test cases all start at the same point 
UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';

-- A small anonymous block PL/SQL program lets you fix this mistake:
DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;

  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;

  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);

BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;

    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

-- It should update four rows, and you can verify the update with the following query:
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';

-- The part I dont need but I do need????
BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

-- 1
-- Create insert_contact 
-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE insert_contact
( pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_account_number      VARCHAR2
, pv_member_type         VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_address_type        VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_user_name           VARCHAR2) IS

-- Local variables, to leverage subquery assignments in INSERT statements.
lv_system_user_name     NUMBER;
lv_contact_type         NUMBER;
lv_member_type          NUMBER;
lv_credit_card_type     NUMBER;
lv_address_type         NUMBER;
lv_telephone_type       NUMBER;
lv_creation_date        DATE := SYSDATE;

-- Create Cursor to insert common_lookup valuse into username values.
CURSOR c 
( cv_table_name    VARCHAR2
, cv_column_name   VARCHAR2
, cv_lookup_type   VARCHAR2) IS
SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_table = cv_table_name
AND   common_lookup_column = cv_column_name
AND   common_lookup_type = cv_lookup_type;

BEGIN

  -- Loop1
  FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
    lv_contact_type := i.common_lookup_id;
  END LOOP;

  -- Loop2
  FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
    lv_member_type := i.common_lookup_id;
  END LOOP;

  -- Loop3
  FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
    lv_credit_card_type := i.common_lookup_id;
  END LOOP;

  -- Loop4
  FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
    lv_address_type := i.common_lookup_id;
  END LOOP; 

  -- Loop5
  FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
    lv_telephone_type := i.common_lookup_id;
  END LOOP; 

  -- SELECT INTO statment
  SELECT system_user_id
  INTO lv_system_user_name
  FROM system_user
  WHERE system_user_name = pv_user_name;

    -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;

  -- Insert statments

   INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_s1.NEXTVAL
  ,lv_member_type
  , pv_account_number
  , pv_credit_card_number
  , lv_credit_card_type
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date );

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  , lv_contact_type
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date );  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  , lv_address_type
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date );  

  
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  , lv_telephone_type
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date );                             -- LAST_UPDATE_DATE

  COMMIT;
  EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END insert_contact;
/

-- TARDIS
BEGIN
  insert_contact( PV_FIRST_NAME   => 'Charles'
, PV_MIDDLE_NAME                  => 'Francis'
, PV_LAST_NAME                    => 'Xavier'
, PV_CONTACT_TYPE                 => 'CUSTOMER'
, PV_ACCOUNT_NUMBER               => 'SLC-000008'
, PV_MEMBER_TYPE                  => 'INDIVIDUAL'
, PV_CREDIT_CARD_NUMBER           => '7777-6666-5555-4444'
, PV_CREDIT_CARD_TYPE             => 'DISCOVER_CARD'
, PV_CITY                         => 'Milbridge'
, PV_STATE_PROVINCE               => 'Maine'
, PV_POSTAL_CODE                  => '04658'
, PV_ADDRESS_TYPE                 => 'HOME'
, PV_COUNTRY_CODE                 => '001'
, PV_AREA_CODE                    => '207'
, PV_TELEPHONE_NUMBER             => '111-1234'
, PV_TELEPHONE_TYPE               => 'HOME'
, PV_USER_NAME                    => 'DBA 2');
END;
/

-- Add query check
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Xavier';

-- 2
-- Create insert_contact 
-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE insert_contact
( pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2 
, pv_account_number      VARCHAR2
, pv_member_type         VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_address_type        VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_user_name           VARCHAR2) IS
  
  lv_system_user_name NUMBER;
  lv_contact_type     NUMBER;
  lv_member_type      NUMBER;
  lv_credit_card_type NUMBER;
  lv_address_type     NUMBER;
  lv_telephone_type   NUMBER;
  lv_creation_date    date := SYSDATE;

  Cursor c
  ( cv_table_name     VARCHAR2
   ,cv_column_name    VARCHAR2
   ,cv_lookup_type    VARCHAR2) IS

  SELECT common_lookup_id
  FROM   common_lookup
  WHERE  common_lookup_table = cv_table_name
  and    common_lookup_column = cv_column_name
  and    common_lookup_type = cv_lookup_type;

PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
  lv_contact_type := i.common_lookup_id;
END LOOP;
FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
  lv_member_type := i.common_lookup_id;
END LOOP;

FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
  lv_credit_card_type := i.common_lookup_id;
END LOOP;

FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
  lv_address_type := i.common_lookup_id;
END LOOP;

FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
  lv_telephone_type := i.common_lookup_id;
END LOOP;

SELECT system_user_id
INTO lv_system_user_name
FROM system_user
WHERE system_user_name = pv_user_name;

  SAVEPOINT starting_point;

  INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( member_s1.NEXTVAL
  , lv_member_type
  , pv_account_number
  , pv_credit_card_number
  , lv_credit_card_type
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date);

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  , lv_contact_type
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date);

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  , lv_address_type
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date); 

  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL
  , contact_s1.CURRVAL
  , address_s1.CURRVAL
  , lv_telephone_type
  , pv_country_code
  , pv_area_code
  , pv_telephone_number
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date);

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
END insert_contact;
/
BEGIN
    insert_contact
    ( pv_first_name     => 'Maura'
    , pv_middle_name     => 'Jane'
    , pv_last_name     => 'Haggerty'
    , pv_contact_type     => 'CUSTOMER'
    , pv_account_number     => 'SLC-000009'
    , pv_member_type     => 'INDIVIDUAL'
    , pv_credit_card_number => '8888-7777-6666-5555'
    , pv_credit_card_type   => 'MASTER_CARD'
    , pv_city             => 'Bangor'
    , pv_state_province     => 'Maine'
    , pv_postal_code     => '04401'
    , pv_address_type     => 'HOME'
    , pv_country_code     => '001'
    , pv_area_code     => '207'
    , pv_telephone_number   => '111-1234'
    , pv_telephone_type     => 'HOME'
    , pv_user_name     => 'DBA 2');
END;
/ 
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Haggerty';
-- 3
DROP PROCEDURE insert_contact;
-- Create insert_contact 
-- Transaction Management Example.
CREATE OR REPLACE FUNCTION insert_contact
( pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_account_number      VARCHAR2
, pv_member_type         VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_address_type        VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_user_name           VARCHAR2) RETURN NUMBER IS

  /* Set procedure to be autonomous. */
  PRAGMA AUTONOMOUS_TRANSACTION;

-- Local variables, to leverage subquery assignments in INSERT statements.
lv_system_user_name     NUMBER;
lv_contact_type         NUMBER;
lv_member_type          NUMBER;
lv_credit_card_type     NUMBER;
lv_address_type         NUMBER;
lv_telephone_type       NUMBER;
lv_creation_date        DATE := SYSDATE;

-- Create Cursor to insert common_lookup valuse into username values.
CURSOR c 
( cv_table_name    VARCHAR2
, cv_column_name   VARCHAR2
, cv_lookup_type   VARCHAR2) IS
SELECT common_lookup_id
FROM common_lookup
WHERE common_lookup_table = cv_table_name
AND   common_lookup_column = cv_column_name
AND   common_lookup_type = cv_lookup_type;

BEGIN

  -- Loop1
  FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
    lv_contact_type := i.common_lookup_id;
  END LOOP;

  -- Loop2
  FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
    lv_member_type := i.common_lookup_id;
  END LOOP;

  -- Loop3
  FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
    lv_credit_card_type := i.common_lookup_id;
  END LOOP;

  -- Loop4
  FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
    lv_address_type := i.common_lookup_id;
  END LOOP; 

  -- Loop5
  FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
    lv_telephone_type := i.common_lookup_id;
  END LOOP; 

  -- SELECT INTO statment
  SELECT system_user_id
  INTO lv_system_user_name
  FROM system_user
  WHERE system_user_name = pv_user_name;

    -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;

  -- Insert statments

   INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_s1.NEXTVAL
  ,lv_member_type
  , pv_account_number
  , pv_credit_card_number
  , lv_credit_card_type
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date );

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  , lv_contact_type
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date );  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  , lv_address_type
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date );  

  
  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  , lv_telephone_type
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_number                               -- TELEPHONE_NUMBER
  , lv_system_user_name
  , lv_creation_date
  , lv_system_user_name
  , lv_creation_date );                             -- LAST_UPDATE_DATE

  COMMIT;
  RETURN 0;
  EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
END insert_contact;
/

-- TARDIS

BEGIN
IF ( insert_contact( PV_FIRST_NAME => 'Harriet'
, PV_MIDDLE_NAME                  => 'Mary'
, PV_LAST_NAME                    => 'McDonnell'
, PV_CONTACT_TYPE                 => 'CUSTOMER'
, PV_ACCOUNT_NUMBER               => 'SLC-000010'
, PV_MEMBER_TYPE                  => 'INDIVIDUAL'
, PV_CREDIT_CARD_NUMBER           => '9999-8888-7777-6666'
, PV_CREDIT_CARD_TYPE             => 'VISA_CARD'
, PV_CITY                         => 'Orono'
, PV_STATE_PROVINCE               => 'Maine'
, PV_POSTAL_CODE                  => '04469'
, PV_ADDRESS_TYPE                 => 'HOME'
, PV_COUNTRY_CODE                 => '001'
, PV_AREA_CODE                    => '207'
, PV_TELEPHONE_NUMBER             => '111-1234'
, PV_TELEPHONE_TYPE               => 'HOME'
, PV_USER_NAME                    => 'DBA 2')) = 0 THEN 
 dbms_output.put_line('Successful');
 ELSE
 dbms_output.put_line('Unsuccessful');
 END IF;
END;
/

-- Test Case 

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'McDonnell';

-- 4
-- create a function 
CREATE OR REPLACE TYPE contact_obj IS OBJECT
 ( first_name         VARCHAR2(30)
 , middle_name        VARCHAR2(30)
 , last_name          VARCHAR2(30));
 /

-- Create a table
 CREATE OR REPLACE
   TYPE contact_tab IS TABLE OF contact_obj;
   /

   CREATE OR REPLACE FUNCTION get_contact RETURN contact_tab IS
   -- Declare d variable that uses the record structure 
     lv_counter    PLS_INTEGER := 1;
   -- Declare d variable that uses the record structure
     lv_collection CONTACT_TAB := contact_tab();

     CURSOR c IS
     SELECT first_name, middle_name, last_name
     FROM contact;

     BEGIN
       FOR i IN c LOOP
      lv_collection.EXTEND;
      lv_collection(lv_counter) := contact_obj( i.first_name, i.middle_name, i.last_name);
      lv_counter := lv_counter + 1;
       END LOOP;
       RETURN lv_collection;
      END;
      /

      -- Display any compilation errors.
LIST
 SHOW ERRORS

      SET PAGESIZE 999
COL full_name FORMAT A24
SELECT first_name || CASE
                       WHEN middle_name IS NOT NULL
                       THEN ' ' || middle_name || ' '
                       ELSE ' '
                     END || last_name AS full_name
FROM   TABLE(get_contact); 
