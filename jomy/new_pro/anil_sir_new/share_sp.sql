USE [testdb]
GO
/****** Object:  StoredProcedure [dbo].[jomy_share]    Script Date: 14-08-2019 15:40:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from jomy_brokerage
--select * from jomy_client
--exec jomy_share 0,'','' --repeat

ALTER PROCEDURE [dbo].[jomy_share] 
(
@client_id int='',
@tran_date date='',
@product varchar(20)=''
)




/*
exec jomy_share 1,'2017-01-01','nse'
exec jomy_share 1,'2017-01-01','BSE'
exec jomy_share 1,'2017-01-01',''

exec jomy_share 0,'','nse'     
exec jomy_share 0,'2017-01-01',''
exec jomy_share 1,'2017-01-01',''
--------------


exec jomy_share 1,'2017-01-01','nse'
exec jomy_share 1,'','nse' 
exec jomy_share 1,'',''   
exec jomy_share 1,'2017-01-01',''
    
exec jomy_share 0,'2017-01-01','nse'   
    
exec jomy_share 0,'2017-01-01',''   
exec jomy_share 0,'','nse'


*/






AS
BEGIN 
DECLARE @C INT

begin




			select b.tran_date,b.clientid,b.NSEVol,b.NSEBrok,b.BSEVol,b.BSEBrok,c.Name,c.Tradecode
			into #temp1
			 from jomy_brokerage b 
			join
			jomy_client c
			on c.Clientid=b.clientid
			where 
			b.clientid=case when (@client_id='' or @client_id='0')then c.clientid else @client_id end 
			and
			convert(date,b.tran_date)=case when (convert(varchar(20),@tran_date)='' or convert(varchar(20),@tran_date)='0')then convert(date,b.tran_date) else convert(date,@tran_date) end

	



		if ((@client_id=0 or @client_id=''))
		begin
		SET @C=0
		
			
		end

		else
		begin
		
			select t.Tradecode as TradeCode,t.Name as Name,sum(t.NSEBrok) as Total_NSE_Broke,sum(t.NSEVol) as Total_NSEVolume,
			sum(t.BSEBrok)as Total_BSE_Brok,sum(t.BSEVol) as Total_Bse_Volume from #temp1 t 
			group by t.Tradecode,t.Name		

			

		end



			if (@tran_date ='' )
			begin
			SET @C=0
			end
			else 
			begin
	
						select t.Tran_date,sum(t.NSEBrok) as Total_NSE_Brok,sum(t.NSEVol) as Total_NSEVolume,
						sum(t.BSEBrok)as Total_BSE_Brok,sum(t.BSEVol) as Total_Bse_Volume
						   from #temp1 t 
						   group by t.Tran_date 

						  
						  
			if @product	='nse'
			begin

			select @product as NSE,sum(t.NSEBrok) as Total_NSE_Brok,sum(t.NSEVol) as Total_NSEVolume  from #temp1 t

			end

			if @product	='bse'
			begin

			select @product as BSE,sum(t.BSEBrok) as Total_BSE_Brok,sum(t.BSEVol) as Total_BSEVolume  from #temp1 t

	
			end	
			if (@product ='')

					 begin
					 select @product as NSE,sum(t.NSEBrok) as Total_NSE_Brok,sum(t.NSEVol) as Total_NSEVolume  from #temp1 t
					 select @product as BSE,sum(t.BSEBrok) as Total_BSE_Brok,sum(t.BSEVol) as Total_Bse_Volume from #temp1 t 
					 end
			end
--select 5	


	if((@client_id=0 or @client_id='') and @tran_date='' and @product='')
	begin

	select b.tran_date,b.clientid,b.NSEVol,b.NSEBrok,b.BSEVol,b.BSEBrok,c.Name,c.Tradecode
			into #temp2
			 from jomy_brokerage b 
			join
			jomy_client c
			on c.Clientid=b.clientid
			where 
			b.clientid=case when (@client_id='' or @client_id='0')then c.clientid else @client_id end 




				select t.Tradecode as TradeCode,t.Name as Name,sum(t.NSEBrok) as Total_NSE_Broke,sum(t.NSEVol) as Total_NSEVolume,
						sum(t.BSEBrok)as Total_BSE_Brok,sum(t.BSEVol) as Total_Bse_Volume from #temp2 t 
						group by t.Tradecode,t.Name


				select t.Tran_date,sum(t.NSEBrok) as Total_NSE_Brok,sum(t.NSEVol) as Total_NSEVolume,
						sum(t.BSEBrok)as Total_BSE_Brok,sum(t.BSEVol) as Total_Bse_Volume
						   from #temp2 t 
						   group by t.Tran_date 

			





	end	
end



	if(@client_id=@client_id) and (@tran_date='')
	begin



		select b.tran_date,b.clientid,b.NSEVol,b.NSEBrok,b.BSEVol,b.BSEBrok,c.Name,c.Tradecode
			into #temp3
			 from jomy_brokerage b 
			join
			jomy_client c
			on c.Clientid=b.clientid
			where 
			b.clientid=case when (@client_id='' or @client_id='0')then c.clientid else @client_id end 



			select t.Tradecode as TradeCode,t.Name as Name,sum(t.NSEBrok) as Total_NSE_Broke,sum(t.NSEVol) as Total_NSEVolume,
						sum(t.BSEBrok)as Total_BSE_Brok,sum(t.BSEVol) as Total_Bse_Volume from #temp3 t 
						group by t.Tradecode,t.Name


						if @product	='nse'
			begin

			select @product as NSE,sum(t.NSEBrok) as Total_NSE_Brok,sum(t.NSEVol) as Total_NSEVolume  from #temp3 t

			end
			if @product	='bse'
			begin

			select @product as BSE,sum(t.BSEBrok) as Total_BSE_Brok,sum(t.BSEVol) as Total_BSEVolume  from #temp3 t

			end
			if (@product ='')

					 begin
					 select @product as NSE,sum(t.NSEBrok) as Total_NSE_Brok,sum(t.NSEVol) as Total_NSEVolume  from #temp3 t
					 select @product as BSE,sum(t.BSEBrok) as Total_BSE_Brok,sum(t.BSEVol) as Total_Bse_Volume from #temp3 t 
					 end
						

	end




END
