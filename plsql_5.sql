@/home/student/Data/cit325/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit325/oracle/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Create sequence
CREATE SEQUENCE rating_agency_s start with 1001;

 -- Create table
CREATE TABLE rating_agency AS
  SELECT rating_agency_s.NEXTVAL AS rating_agency_id
  ,      il.item_rating AS rating
  ,      il.item_rating_agency AS rating_agency
  FROM  (SELECT DISTINCT
                i.item_rating
         ,      i.item_rating_agency
         FROM   item i) il;

  ALTER TABLE item
  ADD rating_agency_id NUMBER;

-- Add column to table
  SET NULL ''
COLUMN table_name   FORMAT A18
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

-- Create object type.
CREATE OR REPLACE 
  TYPE struct IS OBJECT
  ( rating_agency_id       NUMBER
  , rating                 VARCHAR2(8)
  , rating_agency          VARCHAR2(4));
/

-- Create collection of object type.
CREATE OR REPLACE
  TYPE rating_agency_col IS TABLE OF struct;
  /

DECLARE 
 CURSOR c IS 
 SELECT rating_agency_id, rating, rating_agency
 FROM rating_agency;
 lv_rating_agency_daz RATING_AGENCY_COL := rating_agency_col();
BEGIN
 /* Implement assignment of variables inside a loop, which mimics
     how you would handle them if they were read from a cursor loop. */
  FOR i IN c LOOP
    lv_rating_agency_daz.EXTEND;
    lv_rating_agency_daz(lv_rating_agency_daz.COUNT) := 
                  struct( i.rating_agency_id
                        , i.rating
                        , i.rating_agency);
  END LOOP;
  FOR j IN 1..lv_rating_agency_daz.COUNT LOOP
    UPDATE item
    SET rating_agency_id = lv_rating_agency_daz(j).rating_agency_id
    WHERE (lv_rating_agency_daz(j).rating = item.item_rating) 
    AND (lv_rating_agency_daz(j).rating_agency = item.item_rating_agency);
  END LOOP;
END;
/
-- Test
SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;