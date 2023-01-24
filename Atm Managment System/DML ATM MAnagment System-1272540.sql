use AtmManagmentSystem
	select * from card
	select * from client
	select * from balances
	select * from Withdraw
	select * from [Transaction]
	select * from TransactionRecord
go

--insert card values
insert into card 
	values
		(111,'Debit Cards'),
		(112,'Credit Cards'),
		(113,'Master Cards');
go

---insert client values
insert into client
	values
		('Akter','Hossain','Male',20,2939432999,'Bangladeshi','01845797997',113),
		('Eyasin','Alif','Male',23,2939493293,'Bangladeshi','01945700097',111),
		('Rafi','Siddik','Male',23,	2930099999,	'Bangladeshi','01843947997',111),
		('Tahomin','Hridoy','Male','20',2998311999,'Bangladeshi','01843940000',111),
		('Yeasin','Arafat','Male',23,2930009090,'Bangladeshi','01843948997',112),
		('Umme','Kulsum','Female',20,2901009990,'Bangladeshi','01800947997',112),
		('Koli','Akter','Female',20,2939090909,'Bangladeshi','01845447970',112),
		('Mst','Raihan','Female',20,9390900099,'Bangladeshi','01984544797',112),
		('Mehedi','Hasan Shymol','Male',20,2939499009,'Bangladeshi','01845797997',112),
		('Arfin','masum','Male',23,2939499300,'Bangladeshi','01945700097',111),
		('Muhi','Siddik','Male',23,2930099090,'Bangladeshi','01843947997',111),
		('Md','Hridoy','Male',	20,2931199984,	'Bangladeshi','01843940000',111),
		('Alif','Hossem','Male',23,2930090085,'Bangladeshi','01843948997',112),
		('Raj','Khan','Female',20,2910090086,'Bangladeshi','01800947997',112),
		('Raihan','Akter','Female',20,293909087,'Bangladeshi','01845447970',112),
		('Mst','Rokeya','Female',20,293909088.,'Bangladeshi','01894544797',112);
go
---insert balance values
insert into balances 
	values
		(1,16,30000),
		(2,15,40000),
		(3,14,50000),
		(4,13,60000),
		(5,12,70000),
		(6,11,10000),
		(7,10,20000),
		(8,9,49000),
		(9,8,54900),
		(10,6,54600),
		(11,7,453690),
		(12,5,150000),
		(13,4,100000),
		(14,3,40000),
		(15,2,70000),
		(16,1,60000);
go
---insert Withdraw values
insert into Withdraw 
	values
		(1,16,30000),
		(2,15,40000),
		(3,14,50000),
		(4,13,60000),
		(5,12,70000),
		(6,11,10000),
		(7,10,20000),
		(8,9,49000),
		(9,8,54900),
		(10,6,54600),
		(11,7,453690),
		(12,5,150000),
		(13,4,100000),
		(14,3,40000),
		(15,2,70000),
		(16,1,60000);
go

---insert Transaction values
insert into [Transaction] 
	values
		(1,16),(2,15),(3,14),(4,13),
		(5,12),(6,11),(7,10),(8,9),
		(9,8),(10,6),(11,7),(12,5),
		(13,4),(14,3),(15,2),(16,1);
go

---insert TransactionRecord values
insert into TransactionRecord 
	values
		(1,16,113,'23-jan-2023'),
		(2,15,111,'23-jan-2023'),
		(3,14,111,'23-jan-2023'),
		(4,13,111,'23-jan-2023'),
		(5,12,112,'23-jan-2023'),
		(6,11,112,'23-jan-2023'),
		(7,10,112,'23-jan-2023'),
		(8,9,112,'23-jan-2023'),
		(9,8,112,'23-jan-2023'),
		(10,6,111,'23-jan-2023'),
		(11,7,111,'23-jan-2023'),
		(12,5,111,'23-jan-2023'),
		(13,4,112,'23-jan-2023'),
		(14,3,112,'23-jan-2023'),
		(15,2,112,'23-jan-2023'),
		(16,1,112,'23-jan-2023');
 
go

----Joining with Where Clause
select cl.ClientId as ID, cl.FirstName+ ' ' +cl.LastName as Name, cl.Contact, 
		CardType as Card,b.balance-w.amount as Amount, TR.Date 
		from TransactionRecord as TR 
		inner join Card as C on TR.CardId=C.CardId
		inner join Client as CL on TR.ClientId=CL.ClientId
		inner join [Transaction] as T on TR.Transactionid=T.Transactionid
		inner join balances as B on T.balanceid=B.balanceId
		inner join Withdraw as W on cl.ClientId=W.Client_Id
		where cl.LastName like '%a%'
go

----Joining with Group By & Having Clause
select distinct(cl.ClientId),cl.FirstName, count(cl.ClientId) as CountID, b.balance 
		from TransactionRecord as TR 
		inner join Card as C on TR.CardId=C.CardId
		inner join Client as CL on TR.ClientId=CL.ClientId
		inner join [Transaction] as T on TR.Transactionid=T.Transactionid
		inner join balances as B on T.balanceid=B.balanceId
		inner join Withdraw as W on cl.ClientId=W.Client_Id
		group by cl.FirstName,b.balance,cl.ClientId
		having count(cl.ClientId)>=1
go

----Joining with Order By
select distinct(cl.ClientId),cl.FirstName, count(cl.ClientId) as CountID, b.balance 
		from TransactionRecord as TR 
		inner join Card as C on TR.CardId=C.CardId
		inner join Client as CL on TR.ClientId=CL.ClientId
		inner join [Transaction] as T on TR.Transactionid=T.Transactionid
		inner join balances as B on T.balanceid=B.balanceId
		inner join Withdraw as W on cl.ClientId=W.Client_Id
		group by cl.FirstName,b.balance,cl.ClientId
		having count(cl.ClientId)>=1
		order by b.balance desc
go

----merge table
		merge into person as p
		using candidate as c on p.id=c.id  
		when Matched then
		update SET p.Name=c.Name
		when NOT MATCHED then 
		insert (ID,Name,Age) 
		values (C.ID,C.Name,22);

Go
insert into Candidate values (1,'akter hossain')

--- join query inner join 
select * from client as p inner join card as c on p.CardId=c.CardId

--- join query left join 
select * from client as p left join card as c on p.CardId=c.CardId

--- join query right join 
select * from client as p right join card as c on p.CardId=c.CardId

--- join query cross join 
select * from client as p cross join card as c 

--- join query self join 
select * from client as p , card as c 
----use update
update Client set FirstName= 'Monirujjaman' where ClientId=11;

---- Sub Query use
select distinct query.ClientId,query.FirstName from client,
		(select distinct(cl.ClientId),cl.FirstName,  b.balance from TransactionRecord as TR 
		inner join Card as C on TR.CardId=C.CardId
		inner join Client as CL on TR.ClientId=CL.ClientId
		inner join [Transaction] as T on TR.Transactionid=T.Transactionid
		inner join balances as B on T.balanceid=B.balanceId
		inner join Withdraw as W on cl.ClientId=W.Client_Id
		where cl.clientid> 10
		) as query
go

---- case function
select Clientid, FirstName, LastName, Gender, Age,Contact,
	case
		when cardid =111 then 'Debit Card User'
		when cardid =112 then 'Credit Cards User'
		when cardid =113 then 'Master Cards User'
		else 'No Account'
		end as Decription
		from client
go

------- WildCard (Like Operator) ------
select * from  Client
where firstname like 'a%';
go

select * from Client
where firstname NOT LIKE '[p]%';
go
select * from Client
where firstname LIKE '%n';
go 

----Merge -update existing,add missing------
select * into  MG_Client from client 
go
merge dbo.MG_Client as mc using dbo.client as c
		 on mc.ClientId = c.ClientId
		 when matched then
		 update set mc.FirstName=c.Firstname, mc.lastname=c.lastname, 
		 mc.gender= c.gender, mc.age= c.age, mc.Nationalid=c.nationalid,
		 mc.cardid=c.cardid
		 when not matched then
		 insert (mc.clientid,mc.firstname,mc.lastname,mc.gender,mc.age, mc.nationalID,mc.contact, mc.cardid)
		 values (c.clientid,c.firstname,c.lastname,c.gender,c.age, c.nationalID,c.contact, c.cardid)
		 when not matched by source
		then delete; 
  

---------cte all client  record --------
with CTE_clientrecord
	as (
		select top 5 cl.ClientId,cl.FirstName,c.CardType
		from client as cl join card as c on cl.cardid=c.CardId join balances as B on cl.clientid=B.clientid
		group by cl.ClientId,cl.FirstName,c.CardType
		)
		select * from CTE_clientrecord
go

-- string function
	select FirstName,nationality, len(Nationality) as [Nationality Word Length] from client
	select  Balance, len(balance) as [Balance Word Length] from balances;
	select leftname=left(FirstName,cardid) from client;
	select rightname=right(FirstName,cardid) from client;
	select Treem= ltrim('    Akter Hossain                    ');
	select Treem= rtrim('    Akter Hossain                            ');
	select [Lower Case]=lower(firstname) from client
	select [Upper Case]=upper(nationality) from client;
	select patindex= patindex( '%v_r%','Akter Hossain');
	select charindex= charindex( '-','Akter Hossain');
go

------offset use
select * from client 
order by clientid asc
offset 10 rows
fetch first 5 rows only



------- Cube Opeartor --------
	select firstname,nationality from client
	group by firstname,nationality with cube;
	Go

---- Rollup Opeartor -------
	select firstname,nationality from client
	group by firstname,nationality with rollup;
	Go
--------- Grouping Sets Opeartor ------
 
	select firstname,nationality from client
	group by grouping sets( firstname),Nationality;
	Go
------ Exist Operator ------

	select firstname,nationality FROM client
	where exists (select * from Card) 
	Go 
 
---- rank 
	select client.CardId,client.FristName, client.lastname,balances.balance,    
	row_number() over(order by balances.balance desc) AS my_rank   
	FROM client join balances on Client.ClientId=balances.ClientId;  

--- roll up

	select client.clientid,Fristname+' '+client.LastName as Name, client.Gender,sum(balance), balance AS TotalSalary
	from Client join balances on Client.ClientId=balances.ClientId
	group by client.ClientId,Fristname+' '+client.LastName, balance,Gender with rollup;


select * from card
select * from client
select * from balances
select * from Withdraw
select * from [Transaction]
select * from TransactionRecord