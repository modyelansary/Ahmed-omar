create table Persons (
    personid int primary key,name varchar(100) not null,address varchar(100),ContactInfo varchar(100));


create table beltrank( rankid int primary key , rankname varchar(50) not null);


create table members( memberid int primary key , Personid int not null unique, EmergencyContactInfo varchar(100), last_belt_rank int, FOREIGN KEY (personid) REFERENCES Persons(Personid), FOREIGN KEY (last_belt_rank) REFERENCES beltrank(rankid));


create table instructors( instructorid int primary key , Personid int not null unique, qualification varchar(100), FOREIGN KEY (personid) REFERENCES Persons(personid));


create table subscriptionPeriods( periodid int primary key , memberid int not null, StartDate DATETIME not null, EndDate DATETIME not null, IsActive BIT DEFAULT 1,Fees SMALLMONEY,FOREIGN KEY (memberid) REFERENCES members(memberid));


create table Payments(Paymentid int primary key ,memberid int not null,Date DATETIME DEFAULT GETDATE(),foreign key (memberid) REFERENCES members(memberid));


create table BeltTests(TestID int primary key IDENTITY(1,1),memberid int not null,rankid int not null,TestedByInstructorID int not null,Paymentid int,Result BIT, Date DATE DEFAULT GETDATE(),
 FOREIGN KEY (memberid) REFERENCES members(memberid), FOREIGN KEY (rankid) REFERENCES beltrank(rankid), FOREIGN KEY (TestedByInstructorID) REFERENCES instructors(instructorid), FOREIGN KEY (Paymentid) REFERENCES Payments(Paymentid));


create table MemberInstructors( memberid int not null, instructorid int not null, AssignDate DATETIME DEFAULT GETDATE(),
 primary key (memberid, instructorid), FOREIGN KEY (memberid) REFERENCES members(memberid), FOREIGN KEY (instructorid) REFERENCES instructors(instructorid));



create table beltranks(rankid int primary key , rankname varchar(50) not null);


create table persons(personid int primary key ,name nvarchar(100) not null,address nvarchar(100),contactinfo varchar(100));


create table members(memberid int primary key identity(1,1),personid int not null unique,emergencycontactinfo varchar(100),lastbeltrank int,
foreign key (personid) references persons(personid),foreign key (lastbeltrank) references beltranks(rankid));


create table instructors(instructorid int primary key ,personid int not null unique,qualification varchar(100),foreign key (personid) references persons(personid)
);









insert into beltranks (rankname) values('أبيض'), ('أصفر'), ('أخضر'), ('أزرق'), ('بنفسجي'),('بني'), ('أسود 1 دان'), ('أسود 2 دان'), ('أسود 3 دان'), ('أسود 4 دان');


insert into persons (name, address, contactinfo) values('أحمد محمد', 'القاهرة، مصر', '01001234567'),('مريم علي', 'الإسكندرية، مصر', '01111222333'),
('خالد إبراهيم', 'الجيزة، مصر', '01234567890'),('سارة محمود', 'المنصورة، مصر', '01555566677'),('علي حسن', 'أسوان، مصر', '01098765432'),
('نورا كمال', 'الأقصر، مصر', '01122334455'),('محمد سعد', 'بورسعيد، مصر', '01277889900'),('فاطمة عمر', 'السويس، مصر', '01011223344'),
('يوسف خالد', 'الغردقة، مصر', '01144556677'),('هدى وائل', 'شرم الشيخ، مصر', '01288899900');


insert into members (personid, emergencycontactinfo, lastbeltrank) values(1, '01000000001', 1),(2, '01000000002', 2),(3, '01000000003', 3),
(4, '01000000004', 4),(5, '01000000005', 5),(6, '01000000006', 6),(7, '01000000007', 1),(8, '01000000008', 2),(9, '01000000009', 3),(10, '01000000010', 4);


insert into instructors (personid, qualification) values(11, 'مدرب معتمد دولي'),(12, 'مدرب أول'),(13, 'مدرب متقدم'),(14, 'مدرب متوسط'),(15, 'مدرب مبتدئ');



insert into subscriptionperiods (periodid, memberid, startdate, enddate, isactive, fees) values (1, 1, '2024-01-01', '2024-06-30', 0, 300.00),
 (2, 1, '2024-07-01', '2024-12-31', 1, 300.00), (3, 2, '2024-03-15', '2024-09-14', 1, 300.00), (4, 3, '2024-05-01', '2024-10-31', 1, 300.00);


insert into payments (paymentid, memberid, amount, date) values (1, 1, 300.00, '2024-01-01'),
 (2, 1, 300.00, '2024-07-01'), (3, 2, 300.00, '2024-03-15'), (4, 3, 300.00, '2024-05-01');


insert into belttests (testid, memberid, rankid, testedbyinstructorid, paymentid, result, date, testfees)
values (1, 1, 2, 1, 1, 1, '2024-03-15', 50.00), (2, 2, 3, 2, 3, 1, '2024-05-20', 50.00), (3, 3, 2, 1, 4, 1, '2024-06-10', 50.00);


insert into memberinstructors (memberid, instructorid, assigndate) values (1, 1, '2024-01-05'),(2, 2, '2024-03-20'),
(3, 1, '2024-05-05'), (1, 2, '2024-07-15');









select m.memberid, p.name, p.contactinfo, b.rankname as lastbeltrankfrom members m join persons p on m.personid = p.personid left join beltranks b on m.lastbeltrank = b.rankid where p.name like '%محمد%';


select  m.memberid,  p.name, sum(py.amount) as totalpayments, count(py.paymentid) as numberofpayments from members m join persons p on m.personid = p.personid
join payments py on m.memberid = py.memberid group by m.memberid, p.name order by totalpayments desc;


select bt.testid,p.name as membername,br.rankname,bt.date,case when bt.result = 1 then 'ناجح' else 'راسب' end as resultfrom belttests bt
join members m on bt.memberid = m.memberid join persons p on m.personid = p.personid join beltranks br on bt.rankid = br.rankid order by bt.date asc;


select i.instructorid,p.name,count(bt.testid) as numberoftests,string_agg(br.rankname, ', ') as testedranks from instructors i join persons p on i.personid = p.personid
left join belttests bt on i.instructorid = bt.testedbyinstructorid left join beltranks br on bt.rankid = br.rankid group by i.instructorid, p.name order by numberoftests desc;


select m.memberid,p.name,p.contactinfo,sp.startdate,sp.enddate,datediff(day, getdate(), sp.enddate) as daysremaining from subscriptionperiods sp join members m on sp.memberid = m.memberid
join persons p on m.personid = p.personid where sp.isactive = 1 order by sp.enddate;
