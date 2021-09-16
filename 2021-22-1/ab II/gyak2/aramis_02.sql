
select * from dba_objects;


select distinct object_type from dba_objects order by 1;



-- 6. Kik azok a felhaszn�l�k, akiknek t�bb mint 10 f�le objektumuk van? (owner)



select owner from dba_objects group by owner having count( unique object_type ) > 10; -- distinct



select owner,count( unique object_type ) from dba_objects group by owner 
having count( unique object_type ) > 10; 


-- 7. Kik azok a felhaszn�l�k, akiknek van n�zete �s triggere is? (owner)


SELECT distinct owner FROM dba_objects WHERE object_type='VIEW';

SELECT distinct owner FROM dba_objects WHERE object_type='TRIGGER';



SELECT distinct owner FROM dba_objects WHERE object_type='VIEW' and object_type='TRIGGER'; -- ures, ez rossz

SELECT distinct owner FROM dba_objects WHERE object_type='VIEW' or object_type='TRIGGER';  -- union




SELECT distinct owner FROM dba_objects WHERE object_type='VIEW'
intersect
SELECT distinct owner FROM dba_objects WHERE object_type='TRIGGER';



-- 8. Kik azok a felhaszn�l�k, akiknek van n�zete, de nincs triggere? (owner)





SELECT distinct owner FROM dba_objects WHERE object_type='VIEW'
  MINUS
SELECT distinct owner FROM dba_objects WHERE object_type='TRIGGER';


-- 9. Kik azok a felhaszn�l�k, akiknek t�bb mint 40 t�bl�juk, de maximum 37 index�k van? (owner)


-- kinek van t�bb mint 40 t�bl�ja
select distinct owner from dba_objects where object_type = 'TABLE';


select owner from dba_objects where object_type='TABLE' group by owner having count(object_type)>40;

select owner,count( * ) from dba_objects where object_type = 'TABLE' group by owner;
-- having count( object_type ) > 40;

select owner from dba_objects where object_type = 'TABLE' group by owner
having count( * ) > 40
intersect
select owner from dba_objects where object_type = 'INDEX' group by owner
having count( * ) <= 37;


-- 9. Kik azok a felhaszn�l�k, akiknek t�bb mint 40 t�bl�juk, de maximum 37 index�k van? (owner)


select owner,count( * )  from dba_objects where object_type = 'TABLE' group by owner
/*having count( * ) > 40*/;


-- Mi�rt hib�s ez a megold�s, hogyan jav�that�?



-- j� v�ltozat pl_1:
SELECT distinct owner FROM dba_objects WHERE object_type='TABLE'
 GROUP BY owner HAVING count(*) > 40
  MINUS
 SELECT distinct owner FROM dba_objects WHERE object_type='INDEX'
 GROUP BY owner HAVING count(*) > 37;

 select owner from dba_objects where object_type = 'INDEX' group by owner
having count( * ) <= 37;
 
 -- pl_2:
 -- a metszet m�sodik r�sze helyett mindenki akinek nincs (�ssz minus akinek van) 
 -- vagy (union) kevesebb mint 37
 select owner from dba_objects where object_type = 'INDEX' group by owner
having count( * ) <= 37                 -- legal�bb 1 de max 37
union
(select username from dba_users
minus                                   -- 0 indexesek
select owner from dba_objects where object_type = 'INDEX');


select owner from dba_objects where object_type = 'TABLE' group by owner
having count( * ) > 40
intersect
( select owner from dba_objects where object_type = 'INDEX' group by owner
having count( * ) <= 37                 -- legal�bb 1 de max 37
union
(select username from dba_users
minus                                   -- 0 indexesek
select owner from dba_objects where object_type = 'INDEX'));

-- 10. Melyek azok az objektum t�pusok, amelyek t�nyleges t�rol�st ig�nyelnek, 
-- vagyis tartoznak hozz�juk adatblokkok? (object_type)
-- (Az olyan objektumoknak, amik nem ig�nyelnek t�nyleges t�rol�st, 
-- pl. n�zet, szinonima, csak a defin�ci�ja t�rol�dik az adatsz�t�rban.
--A megold�shoz a data_object_id oszlopot vizsg�ljuk meg.)

select * from dba_objects;

select distinct object_type from dba_objects where data_object_id is not null;

-- 11.	Melyek azok az objektum t�pusok, amelyek nem ig�nyelnek t�nyleges t�rol�st,
-- vagyis nem tartoznak hozz�juk adatblokkok? (object_type)

select distinct object_type from dba_objects where data_object_id is null;

-- 12. Keress�k meg az ut�bbi k�t lek�rdez�s metszet�t. (object_type)
-- (Ezek olyan objektum t�pusok, amelyekb�l el�fordul adatblokkokkal rendelkez�
-- �s adatblokkokkal nem rendelkez� is.) Vajon mi�rt? -> l�sd majd part�cion�l�s

select distinct object_type from dba_objects where data_object_id is not null
intersect
select distinct object_type from dba_objects where data_object_id is null;



-- dba_tab_columns --------------------------
-- create table "b" (b number, "b" varchar2(10));
-- create table b (b number, "b" varchar2(10));


select * from dba_tab_columns;

select * from all_tab_columns;

select * from user_tab_columns;

-- 13.	H�ny oszlopa van a nikovits.emp t�bl�nak? (darab)

select * from nikovits.emp;


select * from dba_tab_columns where owner='NIKOVITS' and table_name = 'EMP';

select * from dba_tab_columns where owner='NIKOVITS' and table_name = 'EMP' order by column_id;



select count(*) "darab" from dba_tab_columns where owner='NIKOVITS' and table_name = 'EMP';


-- 14.	Milyen t�pus� a nikovits.emp t�bla 6. oszlopa? (data_type)

select data_type from dba_tab_columns where owner='NIKOVITS' and table_name = 'EMP'
    and column_id = 6;
select data_type,data_precision,data_scale from dba_tab_columns 
where owner='NIKOVITS' and table_name = 'EMP' and column_id = 6;

select data_type from dba_tab_columns where owner='NIKOVITS' and table_name = 'EMP'
    and column_id = 2;
 select data_type,data_length from dba_tab_columns where owner='NIKOVITS' and table_name = 'EMP'
    and column_id = 2;

-- 15.	Adjuk meg azoknak a t�bl�knak a tulajdonos�t �s nev�t, 
-- amelyeknek van 'Z' bet�vel kezd�d� oszlopa. (owner, table_name)

select owner, table_name from dba_tab_columns where column_name like 'Z%';



select owner, table_name,column_name from dba_tab_columns where column_name like 'Z%';



-- drop table z;
-- create table z (zelso number, zmasodik number, "zharmadik" number);


select distinct owner, table_name from dba_tab_columns where column_name like 'Z%';


select owner, table_name from dba_tab_columns where column_name like 'Z%' group by table_name, owner;


-- ugyan azt adja? distinct sort vagy hash group by

select distinct owner, table_name from dba_tab_columns where column_name like 'Z%'
minus
select owner, table_name from dba_tab_columns where column_name like 'Z%' group by table_name, owner;


-- 16. Adjuk meg azoknak a t�bl�knak a nev�t, amelyeknek legal�bb 8 
-- darab d�tum tipus� oszlopa van. ( table_name)
desc DBA_HEATMAP_TOP_TABLESPACES
select * from dba_tab_columns where table_name = 'DBA_HEATMAP_TOP_TABLESPACES';

select table_name from dba_tab_columns where data_type = 'DATE' 
group by table_name having count( * ) >= 8;






select * from dba_tab_columns where owner='NIKOVITS' and table_name = 'EMP';


select table_name,count( * ) from dba_tab_columns where data_type = 'DATE' 
group by table_name having count( * ) >= 8;



select * from dba_tables where table_name='EMP';
select * from dba_tab_columns where table_name='EMP' and data_type='DATE';
-- mind a kett� rossz
-- j� v�ltozat

SELECT owner, table_name FROM dba_tab_columns WHERE data_type='DATE'
 GROUP BY owner, table_name HAVING count(*) >= 8;

SELECT table_name FROM dba_tab_columns WHERE data_type='DATE'
 GROUP BY owner, table_name HAVING count(*) >= 8;



-- 17. Adjuk meg azoknak a t�bl�knak nev�t, amelyeknek 1. es 4. oszlopa is VARCHAR2 t�pus�

select table_name from dba_tab_columns where data_type = 'VARCHAR2' and column_id = 1;
select table_name from dba_tab_columns where data_type = 'VARCHAR2' and column_id = 4;

select table_name from dba_tab_columns where data_type = 'VARCHAR2' and column_id = 1
intersect
select table_name from dba_tab_columns where data_type = 'VARCHAR2' and column_id = 4;




-- ez hib�s, mert itt egy ellenp�lda
select * from dual;  -- sys dual-ja 1 oszlopos varchar

select * from dba_tab_columns where table_name='DUAL';

create table dual (
q number,
w number,
e number,
r varchar2(1)); -- ez 4 oszlopos , de csak a 4.ben van varchar
-- m�gis a dual benne lesz a rossz megold�sban


drop table dual;


-- j�:
select owner,table_name from dba_tab_columns where data_type = 'VARCHAR2' and column_id = 1
intersect
select owner,table_name from dba_tab_columns where data_type = 'VARCHAR2' and column_id = 4;
-- ez is j�
select owner,table_name from dba_tab_columns
where data_type = 'VARCHAR2' and ( column_id = 1 or column_id = 4 )
group by owner,table_name having count( table_name ) = 2;

