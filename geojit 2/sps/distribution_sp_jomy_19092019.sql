  
/*

created by Jomy mathew
on 19-09-2019
for:-New Module in DIS2019 – Definition - to save data to table DISTRIBUTION.Dbo.GTLMF_GatimanIncentive_RestrictedSchemes.
backup--SP_GatimanIncentive_RestrictedSchemes_jomy_17092019 
databse:-DISTRIBUTION
*/




alter PROCEDURE SPInsert_GatimanIncentive_RestrictedSchemes
(  
	@rtacode varchar(25),  
	@amccode varchar(25),  
	@AmcName varchar(250),  
	@schemecode varchar(25),  
	@SchemeName varchar(200),  
	@flag varchar(30),  
	@from_date varchar(30),  
	@to_date varchar(30),  
	@percentage int,  
	@AddSchemeCode varchar(250),  
	@euser varchar(25)  
)  
AS
begin  
	SET NOCOUNT ON

	if @to_date=''
	begin
	set @to_date=null;
	end
   
	if @flag='s'  
	begin  
   
		IF NOT EXISTS (SELECT * FROm Distribution.dbo.GTLMF_GatimanIncentive_RestrictedSchemes(nolock) 
		where RTACode= @rtacode and AMCCode=@amccode and SchemeCode=@schemecode and  CONVERT( DateTime, @from_date ,103)>=FromDate and todate is null)
		BEGIN

			insert into Distribution.dbo.GTLMF_GatimanIncentive_RestrictedSchemes(RTACode,AMCCode,AMCName,SchemeCode,
			SchemeName,Add_SchemeCode,FromDate,ToDate,AllocatedPercentage,Euser,LastUpdatedOn)  
			values(@rtacode,@amccode,@AmcName,@schemecode,@SchemeName,@AddSchemeCode,CONVERT( DateTime, @from_date ,103),
			CONVERT( DateTime, @to_date ,103),@percentage,@euser, getdate()) 

			select '1' Result,'Details saved successfully' Msg
		END 
		Else
			select '0' Result,'Details already exists' Msg
	end  
  
	if @flag='u'  
	begin 
		INSERT INTO Distribution.dbo.GTLMF_GatimanIncentive_RestrictedSchemes_Back(ModifiedTime,ModifiedUser,RTACode,AMCCode,AMCName,SchemeCode,SchemeName,Add_SchemeCode,FromDate,ToDate,AllocatedPercentage,Euser,LastUpdatedOn)  
		SELECT getdate(),@euser,RTACode,AMCCode,AMCName,SchemeCode,SchemeName,Add_SchemeCode,FromDate,ToDate,AllocatedPercentage,Euser,LastUpdatedOn  
		FROM Distribution.dbo.GTLMF_GatimanIncentive_RestrictedSchemes(nolock)  
		where   
		RTACode=@rtacode and AMCCode=@amccode and  AMCName=@AmcName  
		and  SchemeCode=@schemecode  and  SchemeName=@SchemeName  
		and  Add_SchemeCode=@AddSchemeCode and FromDate=@from_date
  
		update Distribution.dbo.GTLMF_GatimanIncentive_RestrictedSchemes  
		set FromDate=CONVERT( DateTime, @from_date ,103),ToDate=CONVERT( DateTime, @to_date ,103),
		AllocatedPercentage=@percentage,Euser=@euser,LastUpdatedOn=getdate()  
		where RTACode=@rtacode  
		and AMCCode=@amccode  and  AMCName=@AmcName  and   SchemeCode=@schemecode  
		and  SchemeName=@SchemeName  and  Add_SchemeCode=@AddSchemeCode and FromDate=@from_date
		
		select '1' Result,'Details updated successfully' Msg 
	end
end