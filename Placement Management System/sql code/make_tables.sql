
create table LOGIN(
USERNAME	VARCHAR(30) NOT NULL,
PASSWORD	VARCHAR(30) NOT NULL,
ACC_RIGHT	integer(1) NOT NULL default 0,
CONSTRAINT pk_login primary key (username)
);

create table C_LOGIN(
USERNAME	integer(5) NOT NULL,
PASSWORD	VARCHAR(30) NOT NULL,
CONSTRAINT pk_c_login primary key (username)
);

create table student(
S_ID	CHAR(9) NOT NULL,
S_NAME	VARCHAR(30) NOT NULL,
BRANCH	VARCHAR(30) NOT NULL,
PNO	bigint(10) not null,
E_ID	VARCHAR(30) NOT NULL,
CGPA	decimal(4,2) NOT NULL,
P_YEAR INTEGER(2) NOT NULL,
CONSTRAINT pk_stu primary key (s_id),
constraint fk_stu_eid foreign key(e_id) references login(username) on delete cascade on update cascade

);

create table company(
C_ID	integer(5) NOT NULL AUTO_INCREMENT,
C_NAME	VARCHAR(30) NOT NULL,
FIELD	VARCHAR(30) NOT NULL,
C_URL VARCHAR(100),
constraint pk_com primary key(c_id),
constraint fk_com_cid foreign key(c_id) references c_login(username) on delete cascade on update cascade
);
alter table company auto_increment =  12000;

create table comp_reg(
C_ID	integer(6) NOT NULL,
C_DATE	DATE not null,
VENUE	VARCHAR(30) not null,
MIN_CGPA decimal(4,2) NOT NULL default 05.00,
constraint fk_cr_cid foreign key(c_id) references company(c_id) on delete cascade on update cascade,
constraint pk_cr primary key(c_id,C_date)
);

create table schedule(
S_ID	CHAR(9) NOT NULL,
C_ID	integer(6) NOT NULL,
S_DATE	DATE NOT NULL,
constraint fk_sch_sid foreign key(s_id) references student(s_id) on delete cascade on update cascade,
constraint fk_sch_cid_sdate foreign key(c_id,s_date) references comp_reg(c_id,c_date) on delete cascade on update cascade,
constraint pk_sch primary key(s_id,c_id)
);

create table results(
S_ID	CHAR(9) NOT NULL,
C_ID	integer(6) NOT NULL,
p_offered integer(8) not null,
offer_acc integer(1) default 0,
R_DATE	DATE ,
constraint ch_re_off check(offer_acc = 1 or offer_acc = 0),
constraint fk_re_sid foreign key(s_id) references student(s_id) on delete cascade on update cascade,
constraint fk_re_cid foreign key(c_id) references company(c_id) on delete cascade on update cascade,
constraint pk_re primary key(s_id,c_id)
);


/* 
--for history table
select t1.p_year,t1.c_name,t1.field,t1.avg_pkj,t1.Tot_sel,IFNULL(t2.ppo_sel,0) as ppo_sel,t1.c_url
			from (
					select c.c_name,c.c_id,IFNULL(c.c_url,'#') as C_URL ,C.field,t.avg_pkj,t.Tot_sel, floor(c.c_id/1000) as p_year
					from (
							select c_id,avg(p_offered) as avg_pkj,count(*) as Tot_sel
							from results
							group by c_id
						) t,company c
					where c.c_id=t.c_id
				) as t1 LEFT JOIN 
				(
					select c_id,count(*) as ppo_sel
					from results
					where r_date is null
				) as t2
			ON t1.c_id=t2.c_id
			order by t1.p_year;
*/



/*
--for offers table

--to show offers avaliable
select c.c_id, c.c_name, t.p_offered, c.field, c.c_url
from (select c_id, p_offered from results where s_id = ?) as t,company as c 
where c.c_id = t.c_id;

--to update offers 
update results set offer_acc = 1 where c_id = ? and s_id = ?
*/
/*
--to show registered companies
select t1.c_id, c1.c_name,c1.field,c1.c_url ,t1.c_date, t1.venue
from (
		select c.c_id, c.c_date, c.venue
		from (select c_id,s_date from schedule where s_id = ?) as t,comp_reg as c
		where t.c_id = c.c_id and t.s_date = c.c_date
	) as t1,company as c1
where t1.c_id=c1.c_id;
*/

/*
//for new registration

*/
--write trigger to make sure that in schedule table while inserting c_id/1000 == a_year of student 
-- write a trigger to check cgpa of student>min_cgpa
/*
select t.c_id,c.c_name,c.field,c.c_url,t.min_cgpa,t.c_date,t.venue
from (
		select c_id, c_date, venue,min_cgpa
		from comp_reg
		where floor(c_id/1000)=? and min_cgpa=?
	) as t,company as c
where t.c_id=c.c_id and t.c_id not in(select c_id from schedule where s_id=?);
*/


INSERT INTO COMPANY(C_NAME,FIELD,C_URL) VALUES("Microsoft","CSE","ABC.COM");



--WRITE TRIGGER TO MAKE SHURE ONLY ONE VENU FOR A COMPANY ON SINGLE DATE

/*
SELECT S.S_ID,S.S_NAME,S.Branch,S.PNO,S.E_ID,S.CGPA,T3.C_DATE,T3.VENUE
FROM (
		SELECT T1.S_ID,T2.C_DATE,T2.VENUE
		FROM (
				SELECT S_ID,S_DATE
				FROM schedule
				WHERE C_ID=1
			) AS T1,
			(
				SELECT C_DATE,VENUE
				FROM comp_reg 
				WHERE C_ID=1
			) AS T2
		WHERE T1.S_DATE=T2.C_DATE
	) AS T3,STUDENT AS S
WHERE T3.S_ID=S.S_ID;
*/