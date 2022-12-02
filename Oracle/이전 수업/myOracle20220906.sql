drop table student;
create table student (
ID varchar2(12),
gender char(1),
birth varchar2(6) not null,
mobile varchar2(8),
area varchar2(15)
);
insert into student values('Lee','M','900915','92672245','µ¿´ë¹®±¸');
insert into student values('Kim','F','890905','47942240','Áß¶û±¸');
select * from student;
insert into student values('Kim',null,null,'47942240','Áß¶û±¸');
select table_name from user_tables;
rename student to newstudent;



