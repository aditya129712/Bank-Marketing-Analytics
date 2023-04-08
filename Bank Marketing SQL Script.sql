CREATE WAREHOUSE AG_BANK_DATA_ANALYTICS
WITH WAREHOUSE_SIZE = 'SMALL' WAREHOUSE_TYPE = 'STANDARD' AUTO_SUSPEND = 300 AUTO_RESUME = TRUE; 
  
CREATE DATABASE AG_BANK_DATA;
USE AG_BANK_DATA;


CREATE OR REPLACE TABLE  (
age	INTEGER,
job VARCHAR(20),
marital VARCHAR(20),
education VARCHAR(20),
default	VARCHAR(5),
balance INTEGER,
housing	VARCHAR(5),
loan	VARCHAR(5),
contact	VARCHAR(20),
day	INTEGER,
month	VARCHAR(5),
duration INTEGER,	
campaign INTEGER,	
pdays	INTEGER,
previous INTEGER,
poutcome VARCHAR(20),	
y VARCHAR(5));


SELECT * FROM AG_BANK_TABLE;

CREATE OR REPLACE TABLE AG_BANK_TABLE_ADDITIONAL(
age	INTEGER,
job	VARCHAR(100),
marital	VARCHAR(100),
education VARCHAR(100),	
default VARCHAR(10),
housing	VARCHAR(10),
loan	VARCHAR(10),
contact	VARCHAR(100),
month	VARCHAR(10),
day_of_week	VARCHAR(10),
duration INTEGER,	
campaign INTEGER,	
pdays INTEGER,	
previous INTEGER,	
poutcome VARCHAR(100),		
emp_var_rate DECIMAL(10,5),
cons_price_idx	DECIMAL(10,5),
cons_conf_idx	DECIMAL(10,5),
euribor3m	DECIMAL(10,5),
nr_employed	INTEGER,
y 	VARCHAR(10));


SELECT * FROM AG_BANK_TABLE_ADDITIONAL;


\*Attribute Information:

Input variables:
# bank client data:
1 - age (numeric)
2 - job : type of job (categorical: 'admin.','blue-collar','entrepreneur','housemaid','management','retired','self-employed','services','student','technician','unemployed','unknown')
3 - marital : marital status (categorical: 'divorced','married','single','unknown'; note: 'divorced' means divorced or widowed)
4 - education (categorical: 'basic.4y','basic.6y','basic.9y','high.school','illiterate','professional.course','university.degree','unknown')
5 - default: has credit in default? (categorical: 'no','yes','unknown')
6 - housing: has housing loan? (categorical: 'no','yes','unknown')
7 - loan: has personal loan? (categorical: 'no','yes','unknown')
# related with the last contact of the current campaign:
8 - contact: contact communication type (categorical: 'cellular','telephone')
9 - month: last contact month of year (categorical: 'jan', 'feb', 'mar', ..., 'nov', 'dec')
10 - day_of_week: last contact day of the week (categorical: 'mon','tue','wed','thu','fri')
11 - duration: last contact duration, in seconds (numeric). Important note: this attribute highly affects the output target (e.g., if duration=0 then y='no'). Yet, the duration is not known before a call is performed. Also, after the end of the call y is obviously known. Thus, this input should only be included for benchmark purposes and should be discarded if the intention is to have a realistic predictive model.
# other attributes:
12 - campaign: number of contacts performed during this campaign and for this client (numeric, includes last contact)
13 - pdays: number of days that passed by after the client was last contacted from a previous campaign (numeric; 999 means client was not previously contacted)
14 - previous: number of contacts performed before this campaign and for this client (numeric)
15 - poutcome: outcome of the previous marketing campaign (categorical: 'failure','nonexistent','success')
# social and economic context attributes
16 - emp.var.rate: employment variation rate - quarterly indicator (numeric)
17 - cons.price.idx: consumer price index - monthly indicator (numeric)
18 - cons.conf.idx: consumer confidence index - monthly indicator (numeric)
19 - euribor3m: euribor 3 month rate - daily indicator (numeric)
20 - nr.employed: number of employees - quarterly indicator (numeric)

Output variable (desired target):
21 - y - has the client subscribed a term deposit? (binary: 'yes','no')*/

----(1) CHECK THE MINIMUM BALANCE AND MAXIMUM BALANCE----
SELECT job,MIN(balance),MAX(balance)
FROM AG_BANK_TABLE
GROUP BY job;


----(2) CREATING A PRICE BUCKET USING CASE STATEMENT--------------

CREATE OR REPLACE TABLE AG_BANK_TABLE AS
SELECT *,
 CASE
   WHEN balance > -10000 AND balance < 0 THEN 'NEGATIVE_BALANCE'
   WHEN balance >= 0 AND balance < 20000 THEN 'GRADE_E'
   WHEN balance >= 20000 AND balance < 40000 THEN 'GRADE_D'
   WHEN balance >= 40000 AND balance < 60000 THEN'GRADE_C'
   WHEN balance >= 60000 AND balance < 80000 THEN'GRADE_B'
   WHEN balance >= 80000 AND balance < 100000 THEN 'GRADE_A'
   WHEN balance >= 100000 THEN 'GRADE_A+_EARNER'
 END AS BALANCE_BUCKET
 FROM AG_BANK_TABLE;
 
 SELECT * FROM AG_BANK_TABLE LIMIT 10;
 
------(3) CHECK THE TOP 10 BALANCE OF THE BANK STATEMENT-----

CREATE OR REPLACE TABLE AG_BANK_TABLE AS 
SELECT *,
DENSE_RANK() OVER(PARTITION BY BALANCE ORDER BY JOB DESC) AS TOP_BALANCE
FROM AG_BANK_TABLE;

----(4) CHECK HIGHEST BALANCE ACCORDING TO THE JOB PROFILE -----

SELECT JOB ,MAX(BALANCE)
FROM AG_BANK_TABLE 
GROUP BY JOB,BALANCE
HAVING BALANCE > 100
ORDER BY JOB,BALANCE DESC;

SELECT JOB,BALANCE,
MAX(BALANCE) OVER(PARTITION BY BALANCE ORDER BY JOB DESC) AS MAX_BALANCE,
DENSE_RANK() OVER(PARTITION BY BALANCE ORDER BY JOB DESC) AS TOP_BALANCE
FROM AG_BANK_TABLE
WHERE TOP_BALANCE<5
ORDER BY JOB,BALANCE DESC LIMIT 10;

-----(5) CHECKING THE COUNT OFJOB PROFILE AND DITINCT COUNT OF JOB PROFILE--------------
SELECT JOB,
COUNT(DISTINCT JOB)
FROM AG_BANK_TABLE
GROUP BY JOB;

SELECT JOB,
COUNT(JOB)
FROM AG_BANK_TABLE
GROUP BY JOB;

---(6) CHECK THE UNEMPLOYED PERSON AND BALANCE----------

SELECT JOB,BALANCE
FROM AG_BANK_TABLE
WHERE JOB = 'unemployed'
ORDER BY JOB DESC LIMIT 10;



