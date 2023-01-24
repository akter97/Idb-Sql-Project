go
	if DB_ID('AtmManagmentSystem') is null
	drop database AtmManagmentSystem
go

----Create database of AtmManagmentSystem----
create database AtmManagmentSystem
	on primary
	(name=N'AtmManagmentSystem_Data_1',
	filename=N'C:\Program Files\Microsoft SQL Server\MSSQL14.AKTER970\MSSQL\Data\AtmManagmentSystem_Data_1.mdf',
	size= 20mb, maxsize= 100mb, filegrowth=5%)
	log on
	(name=N'AtmManagmentSystem_log_1',
	filename=N'C:\Program Files\Microsoft SQL Server\MSSQL14.AKTER970\MSSQL\Log\AtmManagmentSystem_log_1.ldf',
	size= 2mb, maxsize= 250mb, filegrowth=1%)
go

use AtmManagmentSystem
go
---------table create section----------- 
Create table Card(
	CardId int primary key not null, 
	[CardType] varchar(30));
go

-------------- client--------------------- 
create table Client(
	ClientId int primary key identity(1,1) not null,
	firstName varchar(20) not null,
	LastName varchar(20) not null,
	Gender varchar(10) default('Male'),
	Age int check(Age>=18),
	NationalId numeric,
	Nationality varchar(30) check(Nationality='Bangladeshi'),
	Contact text,
	CardId int foreign key references Card(CardId));
go	

------------balance Table------------------- 
create table balances(
	balanceId int primary key not null ,
	ClientId int foreign key references Client(ClientId),
	balance money default(0));
go

-----------Withdraws-------------------- 
Create table Withdraw(
	WithdrawId int primary key not null,
	Client_Id int foreign key references Client(ClientId),
	Amount money default(0));
go

--------------- Transaction-------------- 
create table [Transaction](
	TransactionId int primary key identity(1,1),
	WithdrawId int foreign key references Withdraw(WithdrawId),
	balanceId int foreign key references balances(balanceId));
go

------------ Trancaction Record--------- 
create table TransactionRecord(
	TransactionRecordId int primary key identity(1,1),
	TransactionId int foreign key references [Transaction](TransactionId),
	ClientId int foreign key references Client(ClientId),
	CardId int foreign key references Card(CardId),
	[Date] Date );
go
----view WithdrowsMassage table
create view WithdrowsMassage as(
	select Client.ClientId, Withdraw.WithdrawId,Withdraw.Amount as Withdraw,
	balances.balance-Withdraw.Amount as balances from Client 
	join Withdraw on Client.ClientId=Withdraw.Client_Id 
	join balances on balances.ClientId=Withdraw.Client_Id
	where Client.ClientId='1');
go

---------index------------
create index clientfirstname
	on client (firstname)
	create index clientLastname
	on client (lastname)
go


------ Create Merge Table-------
create table Candidate(
	ID int primary key NOT NULL,
	name varchar(50)
);

create table Person(
	ID int primary key NOT NULL,
	name varchar (50),
	Age int
);
---------create view --------
create view viewclient as
	(select Client.ClientId, Client.firstName +' '+ Client.LastName as [Name],
	card.cardType,Withdraw.Amount Withdraw,BLI.balance-Withdraw.Amount as Balance,Tr.Date 
	from TransactionRecord TR 
	join Card on TR.CardId=Card.CardId 
	join Client on TR.ClientId=Client.ClientId 
	join balances BLI on BLI.ClientId=client.ClientId 
	join Withdraw on Withdraw.Client_Id=TR.ClientId
	where card.CardId>111)
go
 
--------Store Procedure--------------
create procedure Sp_Client
	as
	select * from client
go
  ----client insert
create procedure Sp_clientinsert
	@ClientId int ,
	@firstName varchar(20),
	@LastName varchar(20),
	@Gender varchar(10),
	@Age int,
	@NationalId numeric,
	@Nationality varchar(30),
	@Contact text,
	@CardId int 
	as
	insert into client(ClientId,firstName,LastName,Gender,Age,NationalId,Nationality,Contact,CardId)
	values (@ClientId,@firstName,@LastName,@Gender,@Age,@NationalId,@Nationality,@Contact,@CardId)
go	

----client update
create procedure Sp_clientUpdate
	@ClientId int ,
	@firstName varchar(20),
	@LastName varchar(20),
	@Gender varchar(10),
	@Age int,
	@NationalId numeric,
	@Nationality varchar(30),
	@Contact text,
	@CardId int 
	as
	update client set firstName=@firstName,LastName=@LastName,Gender=@Gender,
	Age=@Age,NationalId=@NationalId,Nationality=@Nationality,Contact=@Contact,CardId=@CardId 
	where ClientId=@ClientId
go	

-----client delete
create procedure Sp_ClientDelete
	@clientid int
	as 
	delete from client where ClientId=@ClientId
	go
	select * from card
go
----card use  without parameters
create procedure SP_WithCard
	@cardid int output,
	@cardtype varchar(30)='N/A',
	@date date = null
	as
	set @cardid=111;
	if @date is null
	begin
	set @date = getdate();
	end;
	execute SP_WithCard 111,'debitcard',''
go

------------function-------------
----=====table value function
--card table function create
create function Fn_card()
	returns table
	return (select * from card)
	select * from Fn_card()
go
---
create function Fn_balanceMassage()
	returns table
	return(select Client.ClientId,client.firstname +' '+ client.lastname as Name , Withdraw.Amount as Withdraw,
	balances.balance-Withdraw.Amount as balances from Client 
	join Withdraw on Client.ClientId=Withdraw.Client_Id 
	join balances on balances.ClientId=Withdraw.Client_Id
	 )
	select * from Fn_balanceMassage()
 go

 ----=====scalar value function
 create function Fn_s_Withdraw()
	 Returns int
	 begin 
	 declare @result int ;
	 select @result= count(*) from Withdraw;
	 return @result;
	 end
 go
 
 -- Create Multi-Statement Table-Valued Function  ------------
create function ml_client()
returns table
AS
RETURN (
   select cl.ClientId as ID, cl.FirstName+ ' ' +cl.LastName as Name, cl.Contact, 
		CardType as Card,b.balance-w.amount as Amount, TR.Date 
		from TransactionRecord as TR 
		inner join Card as C on TR.CardId=C.CardId
		inner join Client as CL on TR.ClientId=CL.ClientId
		inner join [Transaction] as T on TR.Transactionid=T.Transactionid
		inner join balances as B on T.balanceid=B.balanceId
		inner join Withdraw as W on cl.ClientId=W.Client_Id
		where cl.LastName like '%a%'
		)
go   
----------- after trigger 
create trigger trcard 
	on card
	after insert 
	as
	declare 
	@id int, @cardtype varchar(30)
	select @id=i.cardid,@cardtype=i.cardtype from inserted as i

	if( @id >1)
	begin
	raiserror ('this is error',16,2)
	rollback
	end

	go

----create after update
	create trigger trcard_update 
	on card
	after update 
	as
	declare 
	@id int, @cardtype varchar(30)
	 update card set  cardtype=@cardtype where CardId=@id
	begin
	raiserror ('this is error',16,2)
	rollback
	end
go

-------- Create Raiserror Trigger ----------
CREATE TRIGGER dbo.clientttr
	ON client
	INSTEAD OF insert, UPDATE
	AS
	BEGIN
		DECLARE @clientid int, @Firstname varchar(30), @lastname varchar(30), @gender Varchar(50), @age Varchar(50), 
		@nationalid int, @contact text, @cardid int;
		SELECT  @clientid=i.clientid,
				@Firstname= i.firstname,
				@lastname = i.lastname,
				@gender = i.gender,
				@age = i.age,
				@nationalid =i.nationalid,
				@contact = i.contact,
				@cardid= i.cardid
		FROM inserted as i;
		if UPDATE(clientid)
		BEGIN
			RAISERROR('Your input cannot be updated.', 16 ,1)
			ROLLBACK
		END
		ELSE
		BEGIN
		  UPDATE [client]
		  SET 
				Firstname=@Firstname,
				lastname =@lastname,
				gender =@gender,
				age = @age,
				nationalid =@nationalid,
				contact = @contact,
				cardid= @cardid
		  WHERE clientid = @clientid
		END
	END
GO	 


