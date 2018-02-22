@/home/student/Data/cit325/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit325/oracle/lab9/apply_plsql_lab9.sql

-- Part 1
/* Create logger table. */
CREATE TABLE logger
(LOGGER_ID				            NUMBER        NOT NULL
 ,OLD_ITEM_ID					    NUMBER
 ,OLD_ITEM_BARCODE				    VARCHAR2(20)
 ,OLD_ITEM_TYPE					    NUMBER
 ,OLD_ITEM_TITLE 				    VARCHAR2(60)
 ,OLD_ITEM_SUBTITLE				    VARCHAR2(60)
 ,OLD_ITEM_RATING				    VARCHAR2(8)
 ,OLD_ITEM_RATING_AGENCY 			VARCHAR2(4)
 ,OLD_ITEM_RELEASE_DATE				DATE
 ,OLD_CREATED_BY 				    NUMBER
 ,OLD_CREATION_DATE				    DATE
 ,OLD_LAST_UPDATED_BY				NUMBER
 ,OLD_LAST_UPDATE_DATE				DATE
 ,OLD_TEXT_FILE_NAME				VARCHAR2(40)
 ,NEW_ITEM_ID					    NUMBER
 ,NEW_ITEM_BARCODE				    VARCHAR2(20)
 ,NEW_ITEM_TYPE					    NUMBER
 ,NEW_ITEM_TITLE 				    VARCHAR2(60)
 ,NEW_ITEM_SUBTITLE				    VARCHAR2(60)
 ,NEW_ITEM_RATING				    VARCHAR2(8)
 ,NEW_ITEM_RATING_AGENCY 			VARCHAR2(4)
 ,NEW_ITEM_RELEASE_DATE				DATE
 ,NEW_CREATED_BY 				    NUMBER
 ,NEW_CREATION_DATE				    DATE
 ,NEW_LAST_UPDATED_BY				NUMBER
 ,NEW_LAST_UPDATE_DATE				DATE
 ,NEW_TEXT_FILE_NAME				VARCHAR2(40));

desc logger

-- Create sequence
CREATE SEQUENCE logger_s;

DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'Brave Heart';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP

   /* ... insert the data into the logger table ... */

   INSERT INTO logger 
   VALUES
   ( logger_s.NEXTVAL
   	,i.item_id
   	,i.item_barcode
   	,i.item_type 
   	,i.item_title 
   	,i.item_subtitle 
   	,i.item_rating 
   	,i.item_rating_agency 
   	,i.item_release_date 
   	,i.created_by 
   	,i.creation_date 
   	,i.last_updated_by 
   	,i.last_update_date 
   	,i.text_file_name 
   	,i.item_id
   	,i.item_barcode
   	,i.item_type 
   	,i.item_title 
   	,i.item_subtitle 
   	,i.item_rating 
   	,i.item_rating_agency 
   	,i.item_release_date 
   	,i.created_by 
   	,i.creation_date 
   	,i.last_updated_by 
   	,i.last_update_date 
   	,i.text_file_name);

  END LOOP;
END;
/

/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- Part2

-- The Christmas Package
CREATE OR REPLACE
  PACKAGE manage_item IS

  PROCEDURE item_insert
  (  PV_NEW_ITEM_ID 		    NUMBER
   , PV_NEW_ITEM_BARCODE		VARCHAR2
   , PV_NEW_ITEM_TYPE		    NUMBER
   , PV_NEW_ITEM_TITLE		    VARCHAR2
   , PV_NEW_ITEM_SUBTITLE		VARCHAR2
   , PV_NEW_ITEM_RATING		    VARCHAR2
   , PV_NEW_ITEM_RATING_AGENCY	VARCHAR2
   , PV_NEW_ITEM_RELEASE_DATE	DATE
   , PV_NEW_CREATED_BY		    NUMBER
   , PV_NEW_CREATION_DATE		DATE
   , PV_NEW_LAST_UPDATED_BY 	NUMBER
   , PV_NEW_LAST_UPDATE_DATE	DATE
   , PV_NEW_TEXT_FILE_NAME		VARCHAR2);

  PROCEDURE item_insert
  ( PV_NEW_ITEM_ID 		NUMBER
   ,PV_NEW_ITEM_BARCODE		VARCHAR2
   ,PV_NEW_ITEM_TYPE		NUMBER
   ,PV_NEW_ITEM_TITLE		VARCHAR2
   ,PV_NEW_ITEM_SUBTITLE		VARCHAR2
   ,PV_NEW_ITEM_RATING		VARCHAR2
   ,PV_NEW_ITEM_RATING_AGENCY	VARCHAR2
   ,PV_NEW_ITEM_RELEASE_DATE	DATE
   ,PV_NEW_CREATED_BY		NUMBER
   ,PV_NEW_CREATION_DATE		DATE
   ,PV_NEW_LAST_UPDATED_BY 	NUMBER
   ,PV_NEW_LAST_UPDATE_DATE	DATE
   ,PV_NEW_TEXT_FILE_NAME		VARCHAR2
   ,PV_OLD_ITEM_ID 		        NUMBER
   ,PV_OLD_ITEM_BARCODE		    VARCHAR2
   ,PV_OLD_ITEM_TYPE		    NUMBER
   ,PV_OLD_ITEM_TITLE		    VARCHAR2
   ,PV_OLD_ITEM_SUBTITLE		VARCHAR2
   ,PV_OLD_ITEM_RATING		    VARCHAR2
   ,PV_OLD_ITEM_RATING_AGENCY	VARCHAR2
   ,PV_OLD_ITEM_RELEASE_DATE	DATE
   ,PV_OLD_CREATED_BY		NUMBER
   ,PV_OLD_CREATION_DATE		DATE
   ,PV_OLD_LAST_UPDATED_BY 	NUMBER
   ,PV_OLD_LAST_UPDATE_DATE	DATE
   ,PV_OLD_TEXT_FILE_NAME		VARCHAR2);

  PROCEDURE item_insert
  (PV_OLD_ITEM_ID 		NUMBER
   ,PV_OLD_ITEM_BARCODE		VARCHAR2
   ,PV_OLD_ITEM_TYPE		NUMBER
   ,PV_OLD_ITEM_TITLE		VARCHAR2
   ,PV_OLD_ITEM_SUBTITLE		VARCHAR2
   ,PV_OLD_ITEM_RATING		VARCHAR2
   ,PV_OLD_ITEM_RATING_AGENCY	VARCHAR2
   ,PV_OLD_ITEM_RELEASE_DATE	DATE
   ,PV_OLD_CREATED_BY		NUMBER
   ,PV_OLD_CREATION_DATE		DATE
   ,PV_OLD_LAST_UPDATED_BY 	NUMBER
   ,PV_OLD_LAST_UPDATE_DATE	DATE
   ,PV_OLD_TEXT_FILE_NAME		VARCHAR2);

END manage_item;
/

-- BODY

CREATE OR REPLACE
  PACKAGE BODY manage_item IS

  PROCEDURE item_insert
  (  PV_NEW_ITEM_ID 		    NUMBER
   , PV_NEW_ITEM_BARCODE		VARCHAR2
   , PV_NEW_ITEM_TYPE		    NUMBER
   , PV_NEW_ITEM_TITLE		    VARCHAR2
   , PV_NEW_ITEM_SUBTITLE		VARCHAR2
   , PV_NEW_ITEM_RATING		    VARCHAR2
   , PV_NEW_ITEM_RATING_AGENCY	VARCHAR2
   , PV_NEW_ITEM_RELEASE_DATE	DATE
   , PV_NEW_CREATED_BY		    NUMBER
   , PV_NEW_CREATION_DATE		DATE
   , PV_NEW_LAST_UPDATED_BY 	NUMBER
   , PV_NEW_LAST_UPDATE_DATE	DATE
   , PV_NEW_TEXT_FILE_NAME		VARCHAR2) IS

    /* Set an autonomous transaction. */
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    /* Insert log entry for an avenger. */
    manage_item.item_insert(
       PV_OLD_ITEM_ID 	=> NULL
   ,PV_OLD_ITEM_BARCODE	=> NULL
   ,PV_OLD_ITEM_TYPE 	=> NULL
   ,PV_OLD_ITEM_TITLE   => NULL
   ,PV_OLD_ITEM_SUBTITLE => NULL
   ,PV_OLD_ITEM_RATING  => NULL
   ,PV_OLD_ITEM_RATING_AGENCY => NULL
   ,PV_OLD_ITEM_RELEASE_DATE => NULL
   ,PV_OLD_CREATED_BY   => NULL
   ,PV_OLD_CREATION_DATE => NULL
   ,PV_OLD_LAST_UPDATED_BY => NULL
   ,PV_OLD_LAST_UPDATE_DATE => NULL
   ,PV_OLD_TEXT_FILE_NAME => NULL
   ,PV_NEW_ITEM_ID => PV_NEW_ITEM_ID
   ,PV_NEW_ITEM_BARCODE => PV_NEW_ITEM_BARCODE
   ,PV_NEW_ITEM_TYPE => PV_NEW_ITEM_TYPE
   ,PV_NEW_ITEM_TITLE => PV_NEW_ITEM_TITLE
   ,PV_NEW_ITEM_SUBTITLE => PV_NEW_ITEM_SUBTITLE
   ,PV_NEW_ITEM_RATING => PV_NEW_ITEM_RATING
   ,PV_NEW_ITEM_RATING_AGENCY => PV_NEW_ITEM_RATING_AGENCY
   ,PV_NEW_ITEM_RELEASE_DATE => PV_NEW_ITEM_RELEASE_DATE
   ,PV_NEW_CREATED_BY => PV_NEW_CREATED_BY
   ,PV_NEW_CREATION_DATE => PV_NEW_CREATION_DATE
   ,PV_NEW_LAST_UPDATED_BY => PV_NEW_LAST_UPDATED_BY
   ,PV_NEW_LAST_UPDATE_DATE => PV_NEW_LAST_UPDATE_DATE
   ,PV_NEW_TEXT_FILE_NAME => PV_NEW_TEXT_FILE_NAME);
  EXCEPTION
    /* Exception handler. */
    WHEN OTHERS THEN
     RETURN;
  END item_insert;

PROCEDURE item_insert
  ( PV_NEW_ITEM_ID 		NUMBER
   ,PV_NEW_ITEM_BARCODE		VARCHAR2
   ,PV_NEW_ITEM_TYPE		NUMBER
   ,PV_NEW_ITEM_TITLE		VARCHAR2
   ,PV_NEW_ITEM_SUBTITLE		VARCHAR2
   ,PV_NEW_ITEM_RATING		VARCHAR2
   ,PV_NEW_ITEM_RATING_AGENCY	VARCHAR2
   ,PV_NEW_ITEM_RELEASE_DATE	DATE
   ,PV_NEW_CREATED_BY		NUMBER
   ,PV_NEW_CREATION_DATE		DATE
   ,PV_NEW_LAST_UPDATED_BY 	NUMBER
   ,PV_NEW_LAST_UPDATE_DATE	DATE
   ,PV_NEW_TEXT_FILE_NAME		VARCHAR2
   ,PV_OLD_ITEM_ID 		        NUMBER
   ,PV_OLD_ITEM_BARCODE		    VARCHAR2
   ,PV_OLD_ITEM_TYPE		    NUMBER
   ,PV_OLD_ITEM_TITLE		    VARCHAR2
   ,PV_OLD_ITEM_SUBTITLE		VARCHAR2
   ,PV_OLD_ITEM_RATING		    VARCHAR2
   ,PV_OLD_ITEM_RATING_AGENCY	VARCHAR2
   ,PV_OLD_ITEM_RELEASE_DATE	DATE
   ,PV_OLD_CREATED_BY		NUMBER
   ,PV_OLD_CREATION_DATE		DATE
   ,PV_OLD_LAST_UPDATED_BY 	NUMBER
   ,PV_OLD_LAST_UPDATE_DATE	DATE
   ,PV_OLD_TEXT_FILE_NAME		VARCHAR2) IS

    /* Declare local logging value. */
    lv_logger_id  NUMBER;

    /* Set an autonomous transaction. */
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    /* Get a sequence. */
    lv_logger_id := logger_s.NEXTVAL;

    /* Set a savepoint. */
    SAVEPOINT starting;

    /* Insert log entry for an avenger. */
    INSERT INTO logger
    ( logger_id
    ,NEW_ITEM_ID
 	,NEW_ITEM_BARCODE
 	,NEW_ITEM_TYPE
 	,NEW_ITEM_TITLE
 	,NEW_ITEM_SUBTITLE
 	,NEW_ITEM_RATING
 	,NEW_ITEM_RATING_AGENCY
 	,NEW_ITEM_RELEASE_DATE
 	,NEW_CREATED_BY
 	,NEW_CREATION_DATE
 	,NEW_LAST_UPDATED_BY
 	,NEW_LAST_UPDATE_DATE
 	,NEW_TEXT_FILE_NAME
 	,OLD_ITEM_ID 
    ,OLD_ITEM_BARCODE
    ,OLD_ITEM_TYPE
    ,OLD_ITEM_TITLE
    ,OLD_ITEM_SUBTITLE
    ,OLD_ITEM_RATING
    ,OLD_ITEM_RATING_AGENCY
    ,OLD_ITEM_RELEASE_DATE
    ,OLD_CREATED_BY
    ,OLD_CREATION_DATE
    ,OLD_LAST_UPDATED_BY
    ,OLD_LAST_UPDATE_DATE
    ,OLD_TEXT_FILE_NAME)
    VALUES
    ( lv_logger_id
   ,PV_NEW_ITEM_ID
   ,PV_NEW_ITEM_BARCODE
   ,PV_NEW_ITEM_TYPE
   ,PV_NEW_ITEM_TITLE
   ,PV_NEW_ITEM_SUBTITLE
   ,PV_NEW_ITEM_RATING
   ,PV_NEW_ITEM_RATING_AGENCY
   ,PV_NEW_ITEM_RELEASE_DATE
   ,PV_NEW_CREATED_BY
   ,PV_NEW_CREATION_DATE
   ,PV_NEW_LAST_UPDATED_BY
   ,PV_NEW_LAST_UPDATE_DATE
   ,PV_NEW_TEXT_FILE_NAME
   ,PV_OLD_ITEM_ID 
   ,PV_OLD_ITEM_BARCODE
   ,PV_OLD_ITEM_TYPE
   ,PV_OLD_ITEM_TITLE
   ,PV_OLD_ITEM_SUBTITLE
   ,PV_OLD_ITEM_RATING
   ,PV_OLD_ITEM_RATING_AGENCY
   ,PV_OLD_ITEM_RELEASE_DATE
   ,PV_OLD_CREATED_BY
   ,PV_OLD_CREATION_DATE
   ,PV_OLD_LAST_UPDATED_BY
   ,PV_OLD_LAST_UPDATE_DATE
   ,PV_OLD_TEXT_FILE_NAME);

    /* Commit the independent write. */
    COMMIT;
  EXCEPTION
    /* Exception handler. */
    WHEN OTHERS THEN
      ROLLBACK TO starting;
      RETURN;
  END item_insert;

PROCEDURE item_insert
  (PV_OLD_ITEM_ID 		NUMBER
   ,PV_OLD_ITEM_BARCODE		VARCHAR2
   ,PV_OLD_ITEM_TYPE		NUMBER
   ,PV_OLD_ITEM_TITLE		VARCHAR2
   ,PV_OLD_ITEM_SUBTITLE		VARCHAR2
   ,PV_OLD_ITEM_RATING		VARCHAR2
   ,PV_OLD_ITEM_RATING_AGENCY	VARCHAR2
   ,PV_OLD_ITEM_RELEASE_DATE	DATE
   ,PV_OLD_CREATED_BY		NUMBER
   ,PV_OLD_CREATION_DATE		DATE
   ,PV_OLD_LAST_UPDATED_BY 	NUMBER
   ,PV_OLD_LAST_UPDATE_DATE	DATE
   ,PV_OLD_TEXT_FILE_NAME		VARCHAR2) IS

    /* Set an autonomous transaction. */
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    /* Insert log entry for an avenger. */
    manage_item.item_insert(
    PV_OLD_ITEM_ID				=> PV_OLD_ITEM_ID 	
   ,PV_OLD_ITEM_BARCODE			=> PV_OLD_ITEM_BARCODE
   ,PV_OLD_ITEM_TYPE 			=> PV_OLD_ITEM_TYPE
   ,PV_OLD_ITEM_TITLE 			=> PV_OLD_ITEM_TITLE
   ,PV_OLD_ITEM_SUBTITLE 		=> PV_OLD_ITEM_SUBTITLE
   ,PV_OLD_ITEM_RATING 			=> PV_OLD_ITEM_RATING
   ,PV_OLD_ITEM_RATING_AGENCY 	=> PV_OLD_ITEM_RATING_AGENCY
   ,PV_OLD_ITEM_RELEASE_DATE 	=> PV_OLD_ITEM_RELEASE_DATE
   ,PV_OLD_CREATED_BY 			=> PV_OLD_CREATED_BY
   ,PV_OLD_CREATION_DATE 		=> PV_OLD_CREATION_DATE 
   ,PV_OLD_LAST_UPDATED_BY 		=> PV_OLD_LAST_UPDATED_BY
   ,PV_OLD_LAST_UPDATE_DATE 	=> PV_OLD_LAST_UPDATE_DATE
   ,PV_OLD_TEXT_FILE_NAME 		=> PV_OLD_TEXT_FILE_NAME
   ,PV_NEW_ITEM_ID 				=> NULL
   ,PV_NEW_ITEM_BARCODE 		=> NULL
   ,PV_NEW_ITEM_TYPE 			=> NULL
   ,PV_NEW_ITEM_TITLE 			=> NULL
   ,PV_NEW_ITEM_SUBTITLE 		=> NULL
   ,PV_NEW_ITEM_RATING 			=> NULL
   ,PV_NEW_ITEM_RATING_AGENCY 	=> NULL
   ,PV_NEW_ITEM_RELEASE_DATE 	=> NULL
   ,PV_NEW_CREATED_BY 			=> NULL
   ,PV_NEW_CREATION_DATE 		=> NULL
   ,PV_NEW_LAST_UPDATED_BY 		=> NULL
   ,PV_NEW_LAST_UPDATE_DATE 	=> NULL
   ,PV_NEW_TEXT_FILE_NAME 		=> NULL);
  EXCEPTION
    /* Exception handler. */
    WHEN OTHERS THEN
     RETURN;
  END item_insert;
END manage_item;
/

DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'King Arthur';
BEGIN
  /* Read the dynamic cursor. */

    FOR i IN get_row LOOP
  manage_item.item_insert(
     PV_NEW_ITEM_ID       => i.item_id
    ,PV_NEW_ITEM_BARCODE  => i.item_barcode
    ,PV_NEW_ITEM_TYPE     => i.item_type 
    ,PV_NEW_ITEM_TITLE       => i.item_title || '-Inserted'
    ,PV_NEW_ITEM_SUBTITLE    => i.item_subtitle 
    ,PV_NEW_ITEM_RATING      =>i.item_rating 
    ,PV_NEW_ITEM_RATING_AGENCY => i.item_rating_agency 
    ,PV_NEW_ITEM_RELEASE_DATE => i.item_release_date 
    ,PV_NEW_CREATED_BY => i.created_by 
    ,PV_NEW_CREATION_DATE => i.creation_date 
    ,PV_NEW_LAST_UPDATED_BY => i.last_updated_by 
    ,PV_NEW_LAST_UPDATE_DATE => i.last_update_date 
    ,PV_NEW_TEXT_FILE_NAME => i.text_file_name );



  END LOOP;

  FOR i IN get_row LOOP

   /* ... insert the data into the logger table ... */

   manage_item.item_insert(
   	 PV_OLD_ITEM_ID				=> i.item_id
   	,PV_OLD_ITEM_BARCODE	=> i.item_barcode
   	,PV_OLD_ITEM_TYPE     => i.item_type 
   	,PV_OLD_ITEM_TITLE       => i.item_title
   	,PV_OLD_ITEM_SUBTITLE    => i.item_subtitle 
   	,PV_OLD_ITEM_RATING      =>i.item_rating 
   	,PV_OLD_ITEM_RATING_AGENCY => i.item_rating_agency 
   	,PV_OLD_ITEM_RELEASE_DATE => i.item_release_date 
   	,PV_OLD_CREATED_BY => i.created_by 
   	,PV_OLD_CREATION_DATE => i.creation_date 
   	,PV_OLD_LAST_UPDATED_BY => i.last_updated_by 
   	,PV_OLD_LAST_UPDATE_DATE => i.last_update_date 
   	,PV_OLD_TEXT_FILE_NAME => i.text_file_name 
    ,PV_NEW_ITEM_ID       => i.item_id
    ,PV_NEW_ITEM_BARCODE  => i.item_barcode
    ,PV_NEW_ITEM_TYPE     => i.item_type 
    ,PV_NEW_ITEM_TITLE       => i.item_title || '-Changed'
    ,PV_NEW_ITEM_SUBTITLE    => i.item_subtitle 
    ,PV_NEW_ITEM_RATING      =>i.item_rating 
    ,PV_NEW_ITEM_RATING_AGENCY => i.item_rating_agency 
    ,PV_NEW_ITEM_RELEASE_DATE => i.item_release_date 
    ,PV_NEW_CREATED_BY => i.created_by 
    ,PV_NEW_CREATION_DATE => i.creation_date 
    ,PV_NEW_LAST_UPDATED_BY => i.last_updated_by 
    ,PV_NEW_LAST_UPDATE_DATE => i.last_update_date 
    ,PV_NEW_TEXT_FILE_NAME => i.text_file_name );



  END LOOP;

  FOR i IN get_row LOOP

   /* ... insert the data into the logger table ... */

   manage_item.item_insert(
     PV_OLD_ITEM_ID       => i.item_id
    ,PV_OLD_ITEM_BARCODE  => i.item_barcode
    ,PV_OLD_ITEM_TYPE     => i.item_type 
    ,PV_OLD_ITEM_TITLE       => i.item_title || '-Deleted'
    ,PV_OLD_ITEM_SUBTITLE    => i.item_subtitle 
    ,PV_OLD_ITEM_RATING      =>i.item_rating 
    ,PV_OLD_ITEM_RATING_AGENCY => i.item_rating_agency 
    ,PV_OLD_ITEM_RELEASE_DATE => i.item_release_date 
    ,PV_OLD_CREATED_BY => i.created_by 
    ,PV_OLD_CREATION_DATE => i.creation_date 
    ,PV_OLD_LAST_UPDATED_BY => i.last_updated_by 
    ,PV_OLD_LAST_UPDATE_DATE => i.last_update_date 
    ,PV_OLD_TEXT_FILE_NAME => i.text_file_name );

    END LOOP;
END;
/

/* Query the logger table. */
/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- Part3

CREATE OR REPLACE
  TRIGGER item_trig
  BEFORE INSERT OR UPDATE OR DELETE OF ITEM_TITLE ON item
  FOR EACH ROW
--  DECLARE
    /* Declare exception. */
--    e EXCEPTION;
--    PRAGMA EXCEPTION_INIT(e,-20001);
  BEGIN
    /* Check for an event and log accordingly. */
    IF INSERTING THEN
      /* Log the insert change to the item table in the logger table. */
      manage_item.item_insert(
     PV_NEW_ITEM_ID       => :new.item_id
    ,PV_NEW_ITEM_BARCODE  => :new.item_barcode
    ,PV_NEW_ITEM_TYPE     => :new.item_type 
    ,PV_NEW_ITEM_TITLE       => :new.item_title
    ,PV_NEW_ITEM_SUBTITLE    => :new.item_subtitle 
    ,PV_NEW_ITEM_RATING      => :new.item_rating 
    ,PV_NEW_ITEM_RATING_AGENCY => :new.item_rating_agency 
    ,PV_NEW_ITEM_RELEASE_DATE => :new.item_release_date 
    ,PV_NEW_CREATED_BY => :new.created_by 
    ,PV_NEW_CREATION_DATE => :new.creation_date 
    ,PV_NEW_LAST_UPDATED_BY => :new.last_updated_by 
    ,PV_NEW_LAST_UPDATE_DATE => :new.last_update_date 
    ,PV_NEW_TEXT_FILE_NAME => :new.text_file_name );

      /* Check for an empty item_id primary key column value,
         and assign the next sequence value when it is missing. */
      IF :new.item_id IS NULL THEN
        SELECT logger_s.NEXTVAL
        INTO   :new.item_id
        FROM   dual;
      END IF;
    ELSIF UPDATING THEN
      /* Log the update change to the item table in the logging table. */
      manage_item.item_insert(
     PV_OLD_ITEM_ID             => :old.item_id
    ,PV_OLD_ITEM_BARCODE        => :old.item_barcode
    ,PV_OLD_ITEM_TYPE           => :old.item_type 
    ,PV_OLD_ITEM_TITLE          => :old.item_title
    ,PV_OLD_ITEM_SUBTITLE       => :old.item_subtitle 
    ,PV_OLD_ITEM_RATING         => :old.item_rating 
    ,PV_OLD_ITEM_RATING_AGENCY  => :old.item_rating_agency 
    ,PV_OLD_ITEM_RELEASE_DATE   => :old.item_release_date 
    ,PV_OLD_CREATED_BY          => :old.created_by 
    ,PV_OLD_CREATION_DATE       => :old.creation_date 
    ,PV_OLD_LAST_UPDATED_BY     => :old.last_updated_by 
    ,PV_OLD_LAST_UPDATE_DATE    => :old.last_update_date 
    ,PV_OLD_TEXT_FILE_NAME      => :old.text_file_name 
    ,PV_NEW_ITEM_ID             => :new.item_id
    ,PV_NEW_ITEM_BARCODE        => :new.item_barcode
    ,PV_NEW_ITEM_TYPE           => :new.item_type 
    ,PV_NEW_ITEM_TITLE          => :new.item_title
    ,PV_NEW_ITEM_SUBTITLE       => :new.item_subtitle 
    ,PV_NEW_ITEM_RATING         => :new.item_rating 
    ,PV_NEW_ITEM_RATING_AGENCY  => :new.item_rating_agency 
    ,PV_NEW_ITEM_RELEASE_DATE   => :new.item_release_date 
    ,PV_NEW_CREATED_BY          => :new.created_by 
    ,PV_NEW_CREATION_DATE       => :new.creation_date 
    ,PV_NEW_LAST_UPDATED_BY     => :new.last_updated_by 
    ,PV_NEW_LAST_UPDATE_DATE    => :new.last_update_date 
    ,PV_NEW_TEXT_FILE_NAME      => :new.text_file_name );

ELSIF DELETING THEN
manage_item.item_insert(
     PV_OLD_ITEM_ID             => :old.item_id
    ,PV_OLD_ITEM_BARCODE        => :old.item_barcode
    ,PV_OLD_ITEM_TYPE           => :old.item_type 
    ,PV_OLD_ITEM_TITLE          => :old.item_title
    ,PV_OLD_ITEM_SUBTITLE       => :old.item_subtitle 
    ,PV_OLD_ITEM_RATING         => :old.item_rating 
    ,PV_OLD_ITEM_RATING_AGENCY  => :old.item_rating_agency 
    ,PV_OLD_ITEM_RELEASE_DATE   => :old.item_release_date 
    ,PV_OLD_CREATED_BY          => :old.created_by 
    ,PV_OLD_CREATION_DATE       => :old.creation_date 
    ,PV_OLD_LAST_UPDATED_BY     => :old.last_updated_by 
    ,PV_OLD_LAST_UPDATE_DATE    => :old.last_update_date 
    ,PV_OLD_TEXT_FILE_NAME      => :old.text_file_name); 

    END IF;
  END item_trig;
/

CREATE OR REPLACE
  TRIGGER item_trig_two
  BEFORE INSERT OR UPDATE ON item
  FOR EACH ROW
  FOLLOWS item_trig
  WHEN (REGEXP_INSTR(new.item_title,':') > 0)

  DECLARE
    lv_input_title VARCHAR2(40);
    /* Declare exception. */
    e EXCEPTION;
    PRAGMA EXCEPTION_INIT(e,-20001);

BEGIN
  IF INSERTING THEN
  lv_input_title := :new.item_title;
  :new.item_title    := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
  :new.item_subtitle := LTRIM(SUBSTR(lv_input_title,REGEXP_INSTR(lv_input_title,':') + 1, LENGTH(lv_input_title)));
  ELSE
   RAISE_APPLICATION_ERROR (-20001, 'No colons allowed in item titles.'); 
  END IF;

EXCEPTION 
  WHEN e THEN
  dbms_output.put_line(SQLERRM);
  RAISE;

  WHEN others THEN
  dbms_output.put_line(SQLERRM);

END item_trig_two;
/
----------------------------------------Test Case------------------------------------------
-- 1
ALTER TABLE item
DROP CONSTRAINT fk_item_1;

ALTER TABLE item 
ADD CONSTRAINT fk_item_1
FOREIGN KEY(item_type) REFERENCES common_lookup(common_lookup_id) ON DELETE CASCADE; 

-- Query1
COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_type      FORMAT 9999 HEADING "Item|Type"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_type
,      i.item_rating
FROM   item i
WHERE  i.item_title = 'Star Wars';

-- 2

DELETE FROM common_lookup
WHERE common_lookup_table = 'ITEM'
AND common_lookup_column = 'ITEM_TYPE'
AND common_lookup_type = 'BLU-RAY';

-- Query2
COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_type      FORMAT 9999 HEADING "Item|Type"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_type
,      i.item_rating
FROM   item i
WHERE  i.item_title = 'Star Wars';

-- 3

ALTER TABLE item
DROP CONSTRAINT fk_item_1;

ALTER TABLE item 
ADD CONSTRAINT fk_item_1
FOREIGN KEY(item_type) REFERENCES common_lookup(common_lookup_id);

INSERT INTO common_lookup
VALUES
(common_lookup_s1.NEXTVAL
,'ITEM'
,'ITEM_TYPE'
,'BLU-RAY'
,' '
,'Blu-ray'
,3
,SYSDATE
,3
,SYSDATE);

--Query3
COL common_lookup_table   FORMAT A14 HEADING "Common Lookup|Table"
COL common_lookup_column  FORMAT A14 HEADING "Common Lookup|Column"
COL common_lookup_type    FORMAT A14 HEADING "Common Lookup|Type"
SELECT common_lookup_table
,      common_lookup_column
,      common_lookup_type
FROM   common_lookup
WHERE  common_lookup_table = 'ITEM'
AND    common_lookup_column = 'ITEM_TYPE'
AND    common_lookup_type = 'BLU-RAY';

-- 4

INSERT INTO item 
(ITEM_ID
,ITEM_BARCODE
,ITEM_TYPE
,ITEM_TITLE
,ITEM_DESC
,ITEM_RATING
,ITEM_RATING_AGENCY
,ITEM_RELEASE_DATE
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
VALUES
(ITEM_S1.NEXTVAL
,'B01IHVPA8'
,(SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type ='BLU-RAY')
,'Bourne'
,'I LIKE FISH'
,'PG-13'
,'MPAA'
,'06-DEC-16'
,3
,SYSDATE
,3
,SYSDATE);

INSERT INTO item 
(ITEM_ID
,ITEM_BARCODE
,ITEM_TYPE
,ITEM_TITLE
,ITEM_DESC
,ITEM_RATING
,ITEM_RATING_AGENCY
,ITEM_RELEASE_DATE
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
VALUES
(ITEM_S1.NEXTVAL
,'B01AT251XY'
,(SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'BLU-RAY')
,'Bourne Legacy:'
,'THIS AN A NOTHER DESC'
,'PG-13'
,'MPAA'
,'06-APR-16'
,3
,SYSDATE
,3
,SYSDATE);

INSERT INTO item 
(ITEM_ID
,ITEM_BARCODE
,ITEM_TYPE
,ITEM_TITLE
,ITEM_DESC
,ITEM_RATING
,ITEM_RATING_AGENCY
,ITEM_RELEASE_DATE
,CREATED_BY
,CREATION_DATE
,LAST_UPDATED_BY
,LAST_UPDATE_DATE)
VALUES
(ITEM_S1.NEXTVAL
,'B018FK66TU'
,(SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'BLU-RAY')
,'Star Wars: The Force Awakens'
,'THIS IS A DESC'
,'PG-13'
,'MPAA'
,'06-DEC-16'
,3
,SYSDATE
,3
,SYSDATE);

-- Query4
COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

-- 5
/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- 6

UPDATE item 
SET item_title = 'Star Wars: The Force Awakens'
WHERE item_id = '1096';

-- Query6
COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

-- 7
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- 8
DELETE FROM item 
WHERE item_id = '1096';

-- Q8
COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

-- Last Qu
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;
