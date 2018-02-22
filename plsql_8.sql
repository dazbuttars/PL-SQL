@/home/student/Data/cit325/oracle/lab7/apply_plsql_lab7.sql

-- 1

CREATE OR REPLACE PACKAGE contact_package IS
PROCEDURE insert_contact
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
, pv_user_name           VARCHAR2);

-- Create insert_contact 

PROCEDURE insert_contact
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
, pv_user_id              NUMBER); 
END contact_package;
/

desc contact_package

-- 2a
INSERT INTO system_user
  ( system_user_id
  , system_user_name
  , system_user_group_id
  , system_user_type
  , first_name
  , middle_initial
  , last_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  (  6
  , 'BONDSB'
  ,  1
  , (SELECT common_lookup_id 
     FROM common_lookup 
     WHERE common_lookup_type = 'DBA')
  , 'Barry'
  , 'L'
  , 'Bonds'
  ,  1
  ,  SYSDATE
  ,  1
  ,  SYSDATE);
  

INSERT INTO system_user
  ( system_user_id
  , system_user_name
  , system_user_group_id
  , system_user_type
  , first_name
  , middle_initial
  , last_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  (  7
  , 'OWENSR'
  ,  1
  , (SELECT common_lookup_id 
     FROM common_lookup 
     WHERE common_lookup_type = 'DBA')
  , 'Wardell'
  , 'S'
  , 'Curry'
  ,  1
  ,  SYSDATE
  ,  1
  ,  SYSDATE);
  

  INSERT INTO system_user
  ( system_user_id
  , system_user_name
  , system_user_group_id
  , system_user_type
  , first_name
  , middle_initial
  , last_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  (  -1
  , 'ANONYMOUS'
  ,  1
  , (SELECT common_lookup_id 
     FROM common_lookup 
     WHERE common_lookup_type = 'DBA')
  , ' '
  , ' '
  , ' '
  ,  1
  ,  SYSDATE
  ,  1
  ,  SYSDATE);
  

  -- Comfirm the inserts with the following query:

  COL system_user_id  FORMAT 9999  HEADING "System|User ID"
COL system_user_name FORMAT A12  HEADING "System|User Name"
COL first_name       FORMAT A10  HEADING "First|Name"
COL middle_initial   FORMAT A2   HEADING "MI"
COL last_name        FORMAT A10  HeADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      middle_initial
,      last_name
FROM   system_user
WHERE  last_name IN ('Bonds','Curry')
OR     system_user_name = 'ANONYMOUS';

-- 2b

CREATE OR REPLACE PACKAGE BODY contact_package IS
PROCEDURE insert_contact
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



-- Local variables, to leverage subquery assignments in INSERT statements.
lv_system_user_name     NUMBER;
lv_contact_type         NUMBER;
lv_member_type          NUMBER;
lv_credit_card_type     NUMBER;
lv_address_type         NUMBER;
lv_telephone_type       NUMBER;
lv_creation_date        DATE := SYSDATE;

-- lab8 lv values
lv_member_id            NUMBER;

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

CURSOR get_member
( cv_account_number VARCHAR2) IS
SELECT member_id
FROM   member
WHERE  account_number = cv_account_number;

  /* Set procedure to be autonomous. */
  PRAGMA AUTONOMOUS_TRANSACTION;  

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

  OPEN get_member
  (pv_account_number);
  FETCH get_member
  INTO  lv_member_id;

  IF get_member %NOTFOUND 
  THEN 

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
  END IF;
  CLOSE get_member;

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

-- 2c
PROCEDURE insert_contact
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
, pv_user_id           NUMBER) IS

  /* Set procedure to be autonomous. */
  PRAGMA AUTONOMOUS_TRANSACTION;

-- Local variables, to leverage subquery assignments in INSERT statements.
lv_system_user_name     NUMBER := NVL(pv_user_id, -1);
lv_contact_type         NUMBER;
lv_member_type          NUMBER;
lv_credit_card_type     NUMBER;
lv_address_type         NUMBER;
lv_telephone_type       NUMBER;
lv_creation_date        DATE := SYSDATE;

-- lab8 lv values
lv_member_id            NUMBER;

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

CURSOR get_member
( cv_account_number VARCHAR2) IS
SELECT member_id
FROM   member
WHERE  account_number = cv_account_number;



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

    -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;

  -- Insert statments

  OPEN get_member
  (pv_account_number);
  FETCH get_member 
  INTO  lv_member_id;

  IF get_member %NOTFOUND 
  THEN 

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
  END IF;
  CLOSE get_member;

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
END contact_package;
/

-- TARDIS

BEGIN
contact_package.insert_contact( PV_FIRST_NAME => 'Charlie'
, PV_MIDDLE_NAME                  => NULL
, PV_LAST_NAME                    => 'Brown'
, PV_CONTACT_TYPE                 => 'CUSTOMER'
, PV_ACCOUNT_NUMBER               => 'SLC-000011'
, PV_MEMBER_TYPE                  => 'GROUP'
, PV_CREDIT_CARD_NUMBER           => '8888-6666-8888-4444'
, PV_CREDIT_CARD_TYPE             => 'VISA_CARD'
, PV_CITY                         => 'Lehi'
, PV_STATE_PROVINCE               => 'Utah'
, PV_POSTAL_CODE                  => '84043'
, PV_ADDRESS_TYPE                 => 'HOME'
, PV_COUNTRY_CODE                 => '001'
, PV_AREA_CODE                    => '207'
, PV_TELEPHONE_NUMBER             => '877-4321'
, PV_TELEPHONE_TYPE               => 'HOME'
, PV_USER_NAME                    => 'DBA 3');
END;
/

BEGIN
contact_package.insert_contact( PV_FIRST_NAME => 'Peppermint'
, PV_MIDDLE_NAME                  => NULL
, PV_LAST_NAME                    => 'Patty'
, PV_CONTACT_TYPE                 => 'CUSTOMER'
, PV_ACCOUNT_NUMBER               => 'SLC-000011'
, PV_MEMBER_TYPE                  => 'GROUP'
, PV_CREDIT_CARD_NUMBER           => '8888-6666-8888-4444'
, PV_CREDIT_CARD_TYPE             => 'VISA_CARD'
, PV_CITY                         => 'Lehi'
, PV_STATE_PROVINCE               => 'Utah'
, PV_POSTAL_CODE                  => '84043'
, PV_ADDRESS_TYPE                 => 'HOME'
, PV_COUNTRY_CODE                 => '001'
, PV_AREA_CODE                    => '207'
, PV_TELEPHONE_NUMBER             => '877-4321'
, PV_TELEPHONE_TYPE               => 'HOME'
, PV_USER_ID                    => NULL);
END;
/

BEGIN
contact_package.insert_contact( PV_FIRST_NAME => 'Sally'
, PV_MIDDLE_NAME                  => NULL
, PV_LAST_NAME                    => 'Brown'
, PV_CONTACT_TYPE                 => 'CUSTOMER'
, PV_ACCOUNT_NUMBER               => 'SLC-000011'
, PV_MEMBER_TYPE                  => 'GROUP'
, PV_CREDIT_CARD_NUMBER           => '8888-6666-8888-4444'
, PV_CREDIT_CARD_TYPE             => 'VISA_CARD'
, PV_CITY                         => 'Lehi'
, PV_STATE_PROVINCE               => 'Utah'
, PV_POSTAL_CODE                  => '84043'
, PV_ADDRESS_TYPE                 => 'HOME'
, PV_COUNTRY_CODE                 => '001'
, PV_AREA_CODE                    => '207'
, PV_TELEPHONE_NUMBER             => '877-4321'
, PV_TELEPHONE_TYPE               => 'HOME'
, PV_USER_ID                    => '6');
END;
/

-- Test Case 2

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
WHERE  c.last_name IN ('Brown','Patty');

-- 3 package
CREATE OR REPLACE PACKAGE contact_package IS
FUNCTION insert_contact
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
, pv_user_name           VARCHAR2) RETURN NUMBER;

-- Create insert_contact 

FUNCTION insert_contact
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
, pv_user_id              NUMBER) RETURN NUMBER; 
END contact_package;
/
-- 3 body
CREATE OR REPLACE PACKAGE BODY contact_package IS
FUNCTION insert_contact
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
, pv_user_name           VARCHAR2) RETURN NUMBER IS


-- Local variables, to leverage subquery assignments in INSERT statements.
lv_system_user_name     NUMBER;
lv_contact_type         NUMBER;
lv_member_type          NUMBER;
lv_credit_card_type     NUMBER;
lv_address_type         NUMBER;
lv_telephone_type       NUMBER;
lv_creation_date        DATE := SYSDATE;

-- lab8 lv values
lv_member_id            NUMBER;

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

CURSOR get_member
( cv_account_number VARCHAR2) IS
SELECT member_id
FROM   member
WHERE  account_number = cv_account_number;

  /* Set procedure to be autonomous. */
  PRAGMA AUTONOMOUS_TRANSACTION;

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

  OPEN get_member
  (pv_account_number);
  FETCH get_member 
  INTO  lv_member_id;

  IF get_member %NOTFOUND 
  THEN 

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
    END IF;
  CLOSE get_member;


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

-- 3b

FUNCTION insert_contact
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
, pv_user_id          NUMBER) RETURN NUMBER IS

  /* Set procedure to be autonomous. */
  PRAGMA AUTONOMOUS_TRANSACTION;

-- Local variables, to leverage subquery assignments in INSERT statements.
lv_system_user_name     NUMBER := NVL(pv_user_id, -1);
lv_contact_type         NUMBER;
lv_member_type          NUMBER;
lv_credit_card_type     NUMBER;
lv_address_type         NUMBER;
lv_telephone_type       NUMBER;
lv_creation_date        DATE := SYSDATE;

-- lab8 lv values
lv_member_id            NUMBER;

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

CURSOR get_member
( cv_account_number VARCHAR2) IS
SELECT member_id
FROM   member
WHERE  account_number = cv_account_number;

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

    -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;

  -- Insert statments

  OPEN get_member
  (pv_account_number);
  FETCH get_member 
  INTO  lv_member_id;

  IF get_member %NOTFOUND 
  THEN 

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
    END IF;
  CLOSE get_member;


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
END contact_package;
/

BEGIN
IF ( contact_package.insert_contact( PV_FIRST_NAME => 'Shirley'
, PV_MIDDLE_NAME                  => NULL
, PV_LAST_NAME                    => 'Partridge'
, PV_CONTACT_TYPE                 => 'CUSTOMER'
, PV_ACCOUNT_NUMBER               => 'SLC-000012'
, PV_MEMBER_TYPE                  => 'GROUP'
, PV_CREDIT_CARD_NUMBER           => '8888-6666-8888-4444'
, PV_CREDIT_CARD_TYPE             => 'VISA_CARD'
, PV_CITY                         => 'Lehi'
, PV_STATE_PROVINCE               => 'Utah'
, PV_POSTAL_CODE                  => '84043'
, PV_ADDRESS_TYPE                 => 'HOME'
, PV_COUNTRY_CODE                 => '001'
, PV_AREA_CODE                    => '207'
, PV_TELEPHONE_NUMBER             => '111-4321'
, PV_TELEPHONE_TYPE               => 'HOME'
, PV_USER_NAME                    => 'DBA 3')) = 0 THEN 
 dbms_output.put_line('Successful');
 ELSE
 dbms_output.put_line('Unsuccessful');
 END IF;
END;
/

BEGIN
IF ( contact_package.insert_contact( PV_FIRST_NAME => 'Keith'
, PV_MIDDLE_NAME                  => NULL
, PV_LAST_NAME                    => 'Partridge'
, PV_CONTACT_TYPE                 => 'CUSTOMER'
, PV_ACCOUNT_NUMBER               => 'SLC-000012'
, PV_MEMBER_TYPE                  => 'GROUP'
, PV_CREDIT_CARD_NUMBER           => '8888-6666-8888-4444'
, PV_CREDIT_CARD_TYPE             => 'VISA_CARD'
, PV_CITY                         => 'Lehi'
, PV_STATE_PROVINCE               => 'Utah'
, PV_POSTAL_CODE                  => '84043'
, PV_ADDRESS_TYPE                 => 'HOME'
, PV_COUNTRY_CODE                 => '001'
, PV_AREA_CODE                    => '207'
, PV_TELEPHONE_NUMBER             => '111-4321'
, PV_TELEPHONE_TYPE               => 'HOME'
, PV_USER_ID                    => 6)) = 1 THEN 
 dbms_output.put_line('Successful');
 ELSE
 dbms_output.put_line('Unsuccessful');
 END IF;
END;
/

BEGIN
IF ( contact_package.insert_contact( PV_FIRST_NAME => 'Laurie'
, PV_MIDDLE_NAME                  => NULL
, PV_LAST_NAME                    => 'Partridge'
, PV_CONTACT_TYPE                 => 'CUSTOMER'
, PV_ACCOUNT_NUMBER               => 'SLC-000012'
, PV_MEMBER_TYPE                  => 'GROUP'
, PV_CREDIT_CARD_NUMBER           => '8888-6666-8888-4444'
, PV_CREDIT_CARD_TYPE             => 'VISA_CARD'
, PV_CITY                         => 'Lehi'
, PV_STATE_PROVINCE               => 'Utah'
, PV_POSTAL_CODE                  => '84043'
, PV_ADDRESS_TYPE                 => 'HOME'
, PV_COUNTRY_CODE                 => '001'
, PV_AREA_CODE                    => '207'
, PV_TELEPHONE_NUMBER             => '111-4321'
, PV_TELEPHONE_TYPE               => 'HOME'
, PV_USER_ID                    => -1)) = 1 THEN 
 dbms_output.put_line('Successful');
 ELSE
 dbms_output.put_line('Unsuccessful');
 END IF;
END;
/
-- Test Case 3
COL full_name      FORMAT A18   HEADING "Full Name"
COL created_by     FORMAT 9999  HEADING "System|User ID"
COL account_number FORMAT A12   HEADING "Account|Number"
COL address        FORMAT A16   HEADING "Address"
COL telephone      FORMAT A16   HEADING "Telephone"
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      c.created_by 
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';

