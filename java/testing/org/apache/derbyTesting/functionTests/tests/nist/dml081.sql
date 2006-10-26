--
--   Licensed to the Apache Software Foundation (ASF) under one or more
--   contributor license agreements.  See the NOTICE file distributed with
--   this work for additional information regarding copyright ownership.
--   The ASF licenses this file to You under the Apache License, Version 2.0
--   (the "License"); you may not use this file except in compliance with
--   the License.  You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
--   Unless required by applicable law or agreed to in writing, software
--   distributed under the License is distributed on an "AS IS" BASIS,
--   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--   See the License for the specific language governing permissions and
--   limitations under the License.
--
AUTOCOMMIT OFF;

-- MODULE DML081  

-- SQL Test Suite, V6.0, Interactive SQL, dml081.sql
-- 59-byte ID
-- TEd Version #

-- AUTHORIZATION SCHANZLE
   set schema SCHANZLE;

--O   SELECT USER FROM HU.ECCO;
  VALUES USER;
-- RERUN if USER value does not match preceding AUTHORIZATION comment

-- date_time print

-- NOTE Direct support for SQLCODE or SQLSTATE is not required
-- NOTE    in Interactive Direct SQL, as defined in FIPS 127-2.
-- NOTE   ********************* instead ***************************
-- NOTE If a statement raises an exception condition,
-- NOTE    then the system shall display a message indicating that
-- NOTE    the statement failed, giving a textual description
-- NOTE    of the failure.
-- NOTE If a statement raises a completion condition that is a
-- NOTE    "warning" or "no data", then the system shall display
-- NOTE    a message indicating that the statement completed,
-- NOTE    giving a textual description of the "warning" or "no data."

-- TEST:0487 SQLSTATE 00000: successful completion!

--O   SELECT COUNT(*) 
   SELECT * 
         FROM HU.WORKS;
-- PASS:0487 If count = 12?
-- PASS:0487 OR SQLSTATE = 00000: successful completion?

-- END TEST >>> 0487 <<< END TEST
-- *********************************************

-- TEST:0488 SQLSTATE 21000: cardinality violation!

--O   SELECT COUNT(*) 
   SELECT * 
         FROM HU.WORKS
         WHERE PNUM = (SELECT PNUM 
                             FROM HU.WORKS
                             WHERE HOURS = 80);
-- PASS:0488 If ERROR, cardinality violation, 0 rows selected? 
-- PASS:0488 OR SQLSTATE = 21000 OR SQLCODE < 0?            
 
-- END TEST >>> 0488 <<< END TEST
-- *********************************************

-- TEST:0489 SQLSTATE 02000: no data!

   SELECT GRADE
         FROM HU.STAFF 
         WHERE EMPNUM = 'xx';
-- PASS:0489 If 0 rows selected?
-- PASS:0489 OR SQLSTATE = 02000: no data OR SQLCODE = 100? 

   DELETE FROM HU.STAFF
         WHERE GRADE = 11;
-- PASS:0489 If 0 rows deleted?
-- PASS:0489 OR SQLSTATE = 02000: no data OR SQLCODE = 100?

   INSERT INTO HU.STAFF (EMPNUM,GRADE)
         SELECT EMPNUM, 9 
               FROM HU.WORKS
               WHERE PNUM = 'x9';
-- PASS:0489 If 0 rows inserted?
-- PASS:0489 OR SQLSTATE = 02000: no data OR SQLCODE = 100?

   UPDATE HU.STAFF SET CITY = 'Ho'
         WHERE GRADE = 15;
-- PASS:0489 If 0 rows updated?
-- PASS:0489 OR SQLSTATE = 02000: no data OR SQLCODE = 100?

-- restore
   ROLLBACK WORK;

-- END TEST >>> 0489 <<< END TEST
-- *********************************************

-- TEST:0490 SQLSTATE 22012: data exception/division by zero!

-- setup
   INSERT INTO HU.STAFF
         VALUES ('E6','Fidel',0,'Havana');

--O   SELECT COUNT(*) 
   SELECT * 
         FROM HU.STAFF
         WHERE EMPNAME = 'Fidel' AND 16/GRADE > 2;
-- PASS:0490 If ERROR, data exception/division by zero, 0 rows selected?
-- PASS:0490 OR SQLSTATE = 22012 OR SQLCODE < 0?

   SELECT 16/GRADE 
         FROM HU.STAFF
         WHERE EMPNAME = 'Fidel';
-- PASS:0490 If ERROR, data exception/division by zero, 0 rows selected?
-- PASS:0490 OR SQLSTATE = 22012 OR SQLCODE < 0?

   SELECT COUNT(*) 
         FROM HU.STAFF
         GROUP BY CITY HAVING SUM(GRADE/0) > 44;
-- PASS:0490 If ERROR, data exception/division by zero, 0 rows selected?
-- PASS:0490 OR SQLSTATE = 22012 OR SQLCODE < 0?

--O   SELECT COUNT(*) 
   SELECT * 
         FROM HU.STAFF WHERE GRADE = 
                      (SELECT 16/GRADE 
                             FROM HU.STAFF 
                             WHERE EMPNUM = 'E6');
-- PASS:0490 If ERROR, data exception/division by zero, 0 rows selected?
-- PASS:0490 OR SQLSTATE = 22012 OR SQLCODE < 0?

   UPDATE HU.STAFF 
         SET GRADE = GRADE/0 
         WHERE GRADE = 12;
-- PASS:0490 If ERROR, data exception/division by zero, 0 rows updated?
-- PASS:0490 OR SQLSTATE = 22012 OR SQLCODE < 0?

   INSERT INTO HU.STAFF 
         SELECT 'X','Y',HOURS/0,'z' 
               FROM HU.WORKS 
               WHERE PNUM = 'P6';
-- PASS:0490 If ERROR, data exception/division by zero, 0 rows inserted?
-- PASS:0490 OR SQLSTATE = 22012 OR SQLCODE < 0?

-- restore
   ROLLBACK WORK;

-- END TEST >>> 0490 <<< END TEST
-- *********************************************

-- NO_TEST:0502 SQLSTATE 24000: invalid cursor state!

-- Testing cursors

-- *************************************************////END-OF-MODULE
