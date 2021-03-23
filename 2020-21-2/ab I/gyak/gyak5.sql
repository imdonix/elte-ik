select 'szia';
select 'szia' from dual;
select 1+1 from dual;
select 1+1 from a1;
select 1+1 from sz;
select * from sz;
select n,1+1 from sz;
create table dual (x number);
select 'szia' from sys.dual;
drop table dual;

select 1+1 eredm�ny from dual;
select 1+1 "1+1=" from dual;
select 1+1,1*1,1/1,1-1 from dual;
select 1+1 �sszeg,1*1 szorzat,1/1 "1/1=",1-1 "1-1=" from dual;
select * from dual;
select dummy x from dual;

select * from sz �llatok;
select * from sz "x y";
select sz.n,sz.gy from sz;
select sz.n,sz.gy from sz �llatok;
select �llatok.n,�llatok.gy from sz �llatok;
select "x y".n,"x y".gy from sz "x y";

select * from proba;
insert into proba values(5);
select * from PROBA;
select * from "proba";

select huha from proba;
select HUHA from proba;
select Huha from proba;
select "Huha" from proba;
select * from sz where n='F�les';
select * from sz where n!='F�les';
select * from sz where n^='F�les';
select * from sz where n<>'F�les';

select * from sz where n between'F�les' and 'Malacka';
select * from sz where n>='F�les' and n<='Malacka';
select * from sz where n between'F' and 'Mx';

select * from sz where n like 'M%';
select * from sz where n like '%a';
select * from sz where n like 'M______';
select * from sz where n like '____a';
select * from sz where n like '%y%';
select * from sz where n like '%M%';

select null from dual;
select 'igaz' from dual where 1=1;
select 'igaz' from dual where 1=0;
select 'igaz' from dual where null=null;
select 'igaz' from dual where null!=null;
select 'igaz' from dual where null is null;
select 'igaz' from dual where null is not null;
select * from sz where n is null;
insert into sz values (null,'dinnye');
select * from sz where n is not null;
select 'igaz' from dual where 1 in (0,1,2,3);
select 'igaz' from dual where -1 in (0,1,2,3);
select 'igaz' from dual where (1,2) in ((0,0),(0,1),(1,1),(1,2),(0,3));
select 'igaz' from dual where (2,1) in ((0,0),(0,1),(1,1),(1,2),(0,3));
select 'igaz' from dual where 'iz�' in ('nesze','bigy�','iz�','mi ez');
select 'igaz' from dual where 'k�rte' in (select gy from sz);
select 'igaz' from dual where 'ban�n' in (select gy from sz);
select 'igaz' from dual where ('F�les','k�rte') in (select * from sz);
select 'igaz' from dual where ('Nyuszi','k�rte') in (select * from sz);
select * from sz where n in ('F�les','Kanga');
select * from sz where n in (select n from sz where gy='alma');
select * from emp where deptno in (20,30);
select * from emp where deptno in (select min(deptno)from emp);
select * from emp where deptno = (select min(deptno)from emp);
select * from emp 
where deptno = (select distinct deptno from emp where hiredate>'82-J�N.-09');
select * from emp 
where deptno in (select deptno from emp where hiredate>'82-J�N.-09');

select * from emp 
where deptno > (select distinct deptno from emp where hiredate>'82-J�N.-09');
select * from emp 
where deptno > (select deptno from emp where hiredate>'82-J�N.-09');

select * from emp 
where deptno > any (select deptno from emp where hiredate>'81-J�N.-09');
select * from emp 
where deptno > some (select deptno from emp where hiredate>'82-J�N.-09');
select * from emp 
where deptno > all (select deptno from emp where hiredate>'81-J�N.-09');

select * from emp where exists (select n from sz where gy='ban�n');
select * from emp where exists (select n from sz where gy='alma');
select * from emp x 
where not exists (select * from emp where empno=x.empno and sal >2000);