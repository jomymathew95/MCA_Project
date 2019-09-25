/*

created by Jomy Mathew on 24-09-2019
for: SLB confirmation bill as HTML output so that we can incorporate in SPICE.

*/


--EXEC [spSLB_html_report] '1290006906','NLB','20190830'    
--SELECT TOP 10* FROM ClientForReports
--SELECT TRADECODE,* FROM ClientForReports WHERE CURLOCATION='MM' AND TRADECODE='P012'
--EXEC [spSLB_html_report] '1290078408','NLB','20190903'

create Procedure [dbo].[spSLB_html_report](@ClientID VARCHAR(10),@Product VARCHAR(10),@TranDate VARCHAR(10))    
 AS BEGIN    
 SET NOCOUNT ON    
  
 CREATE TABLE #Temp    
 (    
  ClientID   INT,  
  OrderNo    VARCHAR(25),    
  OrderTime   VARCHAR(20),    
  TransactionNo  INT,    
  TransactionTime  VARCHAR(25),    
  Security   VARCHAR(10),    
  Qty     INT,    
  SBP     NUMERIC(15,2),    
  BorrowingFees  NUMERIC(15,2),    
  BNetRate   NUMERIC(15,2),    
  BProcessingCharge NUMERIC(15,2),    
  SLP     NUMERIC(15,2),    
  LendingFees   NUMERIC(15,2),    
  LNetRate   NUMERIC(15,2),    
  LProcessingCharge NUMERIC(15,2),  
  ConfirmNo   INT,  
  ServiceTax   NUMERIC(15,2),  
  EducationalCessSTax NUMERIC(15,2),  
  BUYSELL    CHAR(1),  
  SttlNo    INT,  
    
  Name    VARCHAR(128),  
  ResAdd1    VARCHAR(64),  
  ResAdd2    VARCHAR(64),  
  ResAdd3    VARCHAR(64),  
  ResPIN    VARCHAR(7),  
  ClientCode   VARCHAR(10),  
  PANNo    VARCHAR(10),  
  ResEmail   VARCHAR(64),  
  
  Address1   VARCHAR(64),  
  Address2   VARCHAR(64),  
  Address3   VARCHAR(64),   
  Address4   VARCHAR(64),  
  Phone    VARCHAR(64),  
  FAX     VARCHAR(32),  
  Location   VARCHAR(4),  
  LocDescription  VARCHAR(64),  
    
  CompanyName   VARCHAR(128),  
  CompanyAdd1   VARCHAR(64),  
  CompanyAdd2   VARCHAR(64),  
  CompanyAdd3   VARCHAR(64)  


 )   
 
 DECLARE @ClientID_ INT
 DECLARE @OrderNo_ VARCHAR(25)
 DECLARE @OrderTime_ VARCHAR(25)  
 DECLARE @TransactionNo_ INT
 DECLARE @TransactionTime_ VARCHAR(25)
 DECLARE @Security_ VARCHAR(10)
 DECLARE @Qty_ INT
 DECLARE @SBP_ NUMERIC(15,2)
 DECLARE @BorrowingFees_ NUMERIC(15,2)
 DECLARE @BNetRate_ NUMERIC(15,2)
 DECLARE @BProcessingCharge_ NUMERIC(15,2)
 DECLARE @SLP_ NUMERIC(15,2)
 DECLARE @LendingFees_ NUMERIC(15,2)
 DECLARE @LNetRate_ NUMERIC(15,2)
 DECLARE @LProcessingCharge_ NUMERIC(15,2)
 DECLARE @Btotal float=0
 DECLARE @Ltotal float=0
 declare @CompanyName  Varchar(1000)
 declare @CompanyAdd1 Varchar(1000)
 declare @CompanyAdd2 Varchar(1000)
 declare @CompanyAdd3 Varchar(1000)
 declare @Address1 Varchar(1000)
 declare @Address2 Varchar(1000)
 declare @Address3 Varchar(1000)
 declare @Address4 Varchar(1000)
 declare @phone varchar(100)
 declare @fax varchar(100)
 declare @ConfirmNo varchar(30)
 declare @SttlNo varchar(30)
 declare @Name varchar(30)
 declare @ClientCode varchar(30)
 declare @ResAdd1 varchar(30)
 declare @ResAdd2 varchar(30)
 declare @ResAdd3 varchar(30)
 declare @ResPIN varchar(30)
 declare @PANNo varchar(30)
 declare @LocDescription_ varchar(35)


 
  
 IF @ClientID>0   
  SELECT * INTO #SLBSaudaC FROM SLBSauda WHERE TranDate=@TranDate AND product=@product AND ClientID=@ClientID  
 ELSE  
  SELECT * INTO #SLBSauda FROM SLBSauda WHERE TranDate=@TranDate AND product=@product  
  
  
 IF @ClientID>0    
 BEGIN  
  INSERT INTO #Temp(ClientID,OrderNo,OrderTime,TransactionNo,TransactionTime,Security,Qty,    
  SBP,BorrowingFees,BProcessingCharge,SLP,LendingFees,LProcessingCharge,ServiceTax,EducationalCessSTax,BUYSELL,SttlNo)    
  SELECT ClientID,OrderNo,OrderTime,TransactionNo,TradeTime,Security,Qty,CASE WHEN BuySell='B' THEN SLBPrice ELSE 0 END,     
  CASE WHEN BuySell='B' THEN SLBFees ELSE 0 END,CASE WHEN BuySell='B' THEN Brokerage ELSE 0 END,    
  CASE WHEN BuySell='S' THEN SLBPrice ELSE 0 END,CASE WHEN BuySell='S' THEN SLBFees ELSE 0 END,    
  CASE WHEN BuySell='S' THEN Brokerage ELSE 0 END,ServiceTax,EducationalCessSTax,BUYSELL,SttlNo     
  FROM #SLBSaudaC    
 END  
 ELSE  
 BEGIN  
  INSERT INTO #Temp(ClientID,OrderNo,OrderTime,TransactionNo,TransactionTime,Security,Qty,    
  SBP,BorrowingFees,BProcessingCharge,SLP,LendingFees,LProcessingCharge,ServiceTax,EducationalCessSTax,BUYSELL,SttlNo)    
  SELECT ClientID,OrderNo,OrderTime,TransactionNo,TradeTime,Security,Qty,CASE WHEN BuySell='B' THEN SLBPrice ELSE 0 END,     
  CASE WHEN BuySell='B' THEN SLBFees ELSE 0 END,CASE WHEN BuySell='B' THEN Brokerage ELSE 0 END,    
  CASE WHEN BuySell='S' THEN SLBPrice ELSE 0 END,CASE WHEN BuySell='S' THEN SLBFees ELSE 0 END,    
  CASE WHEN BuySell='S' THEN Brokerage ELSE 0 END,ServiceTax,EducationalCessSTax,BUYSELL,SttlNo     
  FROM #SLBSauda    
 END  
  
  
 UPDATE #Temp    
 SET BNetRate=SBP+BorrowingFees,LNetRate=SLP+LendingFees    
  
 UPDATE T  
 SET T.Name=C.Name,T.ResAdd1=C.ResAdd1,T.ResAdd2=C.ResAdd2,T.ResAdd3=C.ResAdd3,T.Location=C.CurLocation,  
 T.ResPIN=C.ResPIN,T.ClientCode=REPLACE(C.CurLocation,' ','')+REPLACE(C.TradeCode,' ',''),  
 T.PANNo=C.PAN_GIR,T.ResEmail=C.ResEmail  
 FROM Client C(NOLOCK),#Temp T WHERE T.ClientID=C.ClientID  
  
 DECLARE @Cnt INT  
 SET @Cnt=0  
  
 SELECT @Cnt=COUNT(*) FROM #Temp  
   
 IF @Cnt>0  
 BEGIN  
  UPDATE T  
  SET T.CompanyName=S.CompanyName,T.CompanyAdd1=S.CompanyAdd1,  
  T.CompanyAdd2=S.CompanyAdd2,T.CompanyAdd3=S.CompanyAdd3  
  FROM #Temp T,Settings S(NOLOCK)  
 END  
 ELSE  
 BEGIN  
  INSERT INTO #Temp(CompanyName,CompanyAdd1,CompanyAdd2,CompanyAdd3)  
  SELECT CompanyName,CompanyAdd1,CompanyAdd2,CompanyAdd3 FROM SETTINGS(NOLOCK)  
 END   
  
 UPDATE T  
 SET T.Address1=L.Address1,T.Address2=L.Address2,T.Address3=L.Address3,T.Address4=L.Address4,  
 T.Phone=L.Phone1,T.Fax=L.Fax,T.LocDescription=L.Description  
 FROM #Temp T,Location L(NOLOCK) WHERE L.Location=T.Location  
   
  
 DECLARE @Key INT  
 DECLARE @CID INT  


 DECLARE Cur Cursor FOR SELECT DISTINCT ClientID FROM #Temp  
 OPEN Cur  
 FETCH NEXT FROM Cur INTO @CID  

 WHILE @@FETCH_STATUS=0  
 BEGIN  
  EXEC generatekey 'SLBConfirmNo',@Key output  
  UPDATE #Temp SET ConfirmNo=@Key WHERE ClientID=@CID  
  FETCH NEXT FROM Cur INTO @CID  
 END  
   
 CLOSE Cur  
 DEALLOCATE Cur  

 --SELECT * FROM #Temp ORDER BY ClientID,TransactionNo  


Select @CompanyName = CompanyName,@CompanyAdd1=CompanyAdd1,@CompanyAdd2=CompanyAdd2,@CompanyAdd3=CompanyAdd3,
 @Address1=Address1,@Address2=Address2,@Address3=Address3,@Address4=Address4,@phone=Phone,@fax=FAX,@ConfirmNo=ConfirmNo,@SttlNo=SttlNo,
 @Name=Name,@ClientCode=ClientCode,@ResAdd1=ResAdd1,@ResAdd2=ResAdd2,@ResAdd3=ResAdd3,@ResPIN=ResPIN,@PANNo=PANNo
 From #Temp(nolock) 

 
DECLARE @MAIL VARCHAR(max)

DECLARE @Mail1 VARCHAR(max)
SET @MAIL=''
SET @Mail1=''




   Set @Mail='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'                              
   Set @Mail= @Mail+'<HTML><HEAD>'                              
   Set @Mail= @Mail+'<META http-equiv=Content-Type content="text/html; charset=iso-8859-1">'                              
   Set @Mail= @Mail+'<META content="MSHTML 6.00.2900.6266" name=GENERATOR>'                              
   Set @Mail= @Mail+'<STYLE></STYLE>'                              
   Set @Mail= @Mail+'</HEAD>'                              
   Set @Mail= @Mail+'<BODY style="border: 14px solid white;">'     
   Set @Mail= @Mail+'<DIV><FONT face=Arial size=2>'                              
   Set @Mail= @Mail+'<DIV>'                        
   Set @Mail= @Mail+'<DIV>'                        
           
   Set @Mail= @Mail+'<DIV>'                              
                        
                         
   Set @Mail= @Mail+'<P class=MsoNormal><SPAN lang=EN-US style="COLOR: black"><center>'+@CompanyName+'<br>'+@CompanyAdd1+'<br>'+@CompanyAdd2+'<br>'+@CompanyAdd3+'</center></SPAN><SPAN '                              
   Set @Mail= @Mail+'lang=EN-US '                              
   Set @Mail= @Mail+'style="FONT-SIZE: 10pt; COLOR: navy; FONT-FAMILY: ''Arial'',''sans-serif''"><o:p></o:p></SPAN></P>'                              
   Set @Mail= @Mail+'<P class=MsoNormal><SPAN lang=EN-US style="COLOR: black"> '                              
   Set @Mail= @Mail+'<o:p></o:p></SPAN></P>'                        
                                 
   Set @Mail= @Mail+'<P class=MsoNormal><SPAN lang=EN-US style="COLOR: black">'                            
   Set @Mail= @Mail+'<CENTER>(MEMBER OF SECURITIES LEADING AND BORROWING SCHEME OF NATIONAL SECURITIES CLEARING CORPERATION LIMITED [AI])<BR>'                              
   Set @Mail= @Mail+'(SEBI REGISTRATION NO.INF 231337230) <BR> SECURITIES LEADING & BORROWING CONFIRATION MEMO <BR>Confirmation memo issued by SLB member acting for client </CENTER>'                                                      
   Set @Mail= @Mail+'<P class=MsoNormal><SPAN lang=EN-US style="COLOR: black">&nbsp; <o:p></o:p></SPAN></P>'                        
   
   Set @Mail= @Mail+'<P class=MsoNormal><SPAN lang=EN-US style="COLOR: black">&nbsp; Dealing Office Address of the Participant:<br><p>&nbsp&nbsp&nbsp'+@Address1+' '+@Address2+' '+@Address3+' '+@Address4+'&nbsp'
    Set @Mail= @Mail+'<br>&nbspTel.NO:-'+@phone +' Fax:-'+@fax+'</P><p style="TEXT-ALIGN: right"> Confirmation Memo No:'+@ConfirmNo+'<br><br>Transaction Date: '+CONVERT(VARCHAR(10), convert(date,@TranDate), 103)+'<br>SLB Session No:'+@SttlNo+'<br>Return Session No:'+@SttlNo+'</p>'

	 Set @Mail= @Mail+'To,<br>'+@Name+' '+@ClientCode+'<br>'+@ResAdd1+'<br>'+@ResAdd2+'<br>'+@ResAdd3+'<br>PIN :'+@ResPIN+'<br>Unique Client Code:'+@PANNo+'<br>PAN of Client:'+@PANNo+'<br>'
	 
	 
	  Set @Mail= @Mail+'<p>Dear sir/madam,<br>I/We have this day done by your order and on your account the following transactions in the SLB session</p><br><o:p></o:p></SPAN></P>'
   

                                 --<p style="TEXT-ALIGN: right"></p>
   Set @Mail= @Mail+'<TABLE class=MsoNormalTable cellSpacing=0 cellPadding=0 border=0>'                       
   Set @Mail= @Mail+'<TBODY>'                              
   Set @Mail= @Mail+'<TR style="HEIGHT: 34.5pt">'                         
    --ORDER NO                    
   Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 88.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Order No</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'                        
   --ORDER TIME                     
   Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 120.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '               
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Order Time</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'                        
    --TRN NO                      
   Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 120.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Trn No</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'                        
    --TRN TIME                             
   Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 120.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Trn Time</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'
   --KIND OF SECURITY
    Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 120pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=250>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Kind Of Security</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'    
   --QTY
    Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 88.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Qty</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'    
   --SBP
       Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 88.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">SBP</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'    
   --BRWNG FEES
       Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 88.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Brwng Fees</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'  
   --NET RATE 
       Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 88.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Net Rate</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'  
   --PROCESSING CHARGE
       Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 88.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: right" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Process Charge</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'  
   --SLP
       Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 88.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">SLP</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'  
   --LENDING FEES
       Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 88.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Lending Fees</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'  
   --NET RATE
       Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 88.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Net Rate</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD>'  
   --PROCESS CHARGE
       Set @Mail= @Mail+'<TD '                              
   Set @Mail= @Mail+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
     PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; WIDTH: 88.5pt; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 34.5pt" '                              
   Set @Mail= @Mail+'width=130>'                              
   Set @Mail= @Mail+'<P class=MsoNormal style="TEXT-ALIGN: right" align=center><B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black">Process Charge</SPAN></B><SPAN '                              
   Set @Mail= @Mail+'style="COLOR: black"><o:p></o:p></SPAN></P></TD></TR>' 
  -- Set @Mail= @Mail+'<TR style="HEIGHT: 28.5pt">' 


  declare @TSBP float=0.0;
  declare @TBorrowingFees float=0.0;
  declare @TBProcess float=0.0;
  declare @TSLP float=0.0;
  declare @TLendingFees float=0.0;
  declare @TLProcess float=0.0;
  declare @TLNetRate float=0.0; 
  declare @TBNetRate float=0.0;
  declare @BUYSELL_ varchar(5);
  declare @ServiceTax_ float;
  declare @EducationalCessSTax_ float;
  declare @TBuySTax float=0.0;
  declare @TBuyEcess float=0.0;
  declare @Tsellstax float=0.0;
  declare @Tsellecess float=0.0;
  declare @TDrCr float=0.0;
  declare @TotalBuyTax float=0.0;
  declare @TotalSellTax float=0.0;
  declare @str varchar(15);

    Declare CUR_PRINT_TABLE_CONTENT Cursor For                        
   Select Distinct ClientID ,OrderNo,OrderTime,TransactionNo,TransactionTime,Security,Qty,SBP,BorrowingFees,BNetRate,BProcessingCharge,SLP,LendingFees,LNetRate,
   LProcessingCharge,BUYSELL,ServiceTax,EducationalCessSTax,LocDescription      
   from #Temp Order by TransactionNo                           
   Open CUR_PRINT_TABLE_CONTENT                        
   Fetch next from CUR_PRINT_TABLE_CONTENT Into @ClientID_,@OrderNo_,@OrderTime_,@TransactionNo_,@TransactionTime_,@Security_,@Qty_,@SBP_,
                                                @BorrowingFees_,@BNetRate_,@BProcessingCharge_,@SLP_,@LendingFees_,@LNetRate_,
												@LProcessingCharge_,@BUYSELL_,@ServiceTax_,@EducationalCessSTax_,@LocDescription_
   while @@Fetch_status = 0                               
   Begin   


   
							set @TSBP=@TSBP+(@SBP_*@Qty_);
                            set @TBorrowingFees=@TBorrowingFees+(@BorrowingFees_*@Qty_);
                            set @TBProcess=@TBProcess+@BProcessingCharge_;
                            set @TSLP=@TSLP+(@SLP_*@Qty_);
                            set @TLendingFees=@TLendingFees+(@LendingFees_*@Qty_);
                            set @TLProcess=@TLProcess+@LProcessingCharge_;
                            set @TLNetRate=@TLNetRate+@LNetRate_;
                            set @TBNetRate=@TBNetRate+@BNetRate_;
							

							
							 if @BUYSELL_='B' 

                            begin
                                    set @TBuySTax = @TBuySTax+@ServiceTax_;
                                    set @TBuyEcess =@TBuyECess+@EducationalCessSTax_;
                                    set @TDrCr=(@TBorrowingFees -(@TBProcess+@TBuySTax+@TBuyEcess));  
                            end;
                            if @BUYSELL_='S'
                            begin
                                    set @Tsellstax=@Tsellstax+@ServiceTax_;
                                    set @Tsellecess=@Tsellecess+@EducationalCessSTax_;
                                    set @TDrCr=(@TLendingFees- (@TLProcess+@Tsellstax+@Tsellecess)); 
                            end; 

							 set @TotalBuyTax= @TotalBuyTax+@TBuySTax+@TBuyEcess;
                             set @TotalSellTax= @TotalBuyTax+@Tsellstax+@Tsellecess;


    
    Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+@OrderNo_+'<o:p></o:p></SPAN></P></TD>'  

    Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+@OrderTime_+'<o:p></o:p></SPAN></P></TD>'  
		   
		  
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@TransactionNo_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD>'  
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+@TransactionTime_+'<o:p></o:p></SPAN></P></TD>'
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@Security_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD>' 
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@Qty_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD>' 
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@SBP_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD>' 
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@BorrowingFees_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD>' 
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@BNetRate_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD>' 
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@BProcessingCharge_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD>' 
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@SLP_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD>' 
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@LendingFees_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD>' 
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@LNetRate_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD>' 
	Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@LProcessingCharge_ As Varchar(16))+'<o:p></o:p></SPAN></P></TD></TR>'


		  set @Btotal=@Btotal+@BProcessingCharge_;
		  set @Ltotal=@Ltotal+@LProcessingCharge_;

		  			
                
									print @TDrCr
                      


		     Fetch next from CUR_PRINT_TABLE_CONTENT Into @ClientID_,@OrderNo_,@OrderTime_,@TransactionNo_,@TransactionTime_,@Security_,@Qty_,@SBP_,
                                                @BorrowingFees_,@BNetRate_,@BProcessingCharge_,@SLP_,@LendingFees_,@LNetRate_,
												@LProcessingCharge_,@BUYSELL_,@ServiceTax_,@EducationalCessSTax_,@LocDescription_
     End                              
     Close  CUR_PRINT_TABLE_CONTENT                               
     Deallocate CUR_PRINT_TABLE_CONTENT  


	 if @TDrCr<0 
          set  @str='debited';
       else
          set @str='credited';

	                             
	 Set @Mail1= @Mail1+'<TR style="HEIGHT: 28.5pt"><TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">Total<o:p></o:p></SPAN></P></TD>'    

		    Set @Mail1=@Mail1+'<td></td>'
		    Set @Mail1=@Mail1+'<td></td>'
		    Set @Mail1=@Mail1+'<td></td>'
			Set @Mail1=@Mail1+'<td></td>'
			Set @Mail1=@Mail1+'<td></td>'
			Set @Mail1=@Mail1+'<td></td>'
			Set @Mail1=@Mail1+'<td></td>'
			Set @Mail1=@Mail1+'<td></td>'
				
	
	
		Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@Btotal As Varchar(16))+'<o:p></o:p></SPAN></P></TD>' 

		  			   Set @Mail1=@Mail1+'<td></td>'
			    Set @Mail1=@Mail1+'<td></td>'
				 Set @Mail1=@Mail1+'<td></td>'
		  
		  
		Set @Mail1= @Mail1+'<TD '                              
          Set @Mail1=@Mail1+'style="BORDER-RIGHT: black 1pt solid; PADDING-RIGHT: 0.75pt; BORDER-TOP: black 1pt solid; PADDING-LEFT: 0.75pt;                       
            PADDING-BOTTOM: 0.75pt; BORDER-LEFT: black 1pt solid; PADDING-TOP: 0.75pt; BORDER-BOTTOM: black 1pt solid; HEIGHT: 28.5pt">'                              
          Set @Mail1=@Mail1+'<P class=MsoNormal style="TEXT-ALIGN: center" align=center><SPAN '                              
          Set @Mail1=@Mail1+'style="COLOR: black">'+Cast(@Ltotal As Varchar(16))+'<o:p></o:p></SPAN></P></TD></tr></table><BR><BR>'   
		  
		  
		  
		               
		     Set @Mail1=@Mail1+' <table border=0>'
				Set @Mail1=@Mail1+'<tr><td>Total Borrowing at SBP:Rs.</td><td>'+Cast(@TSBP As Varchar(16))+' </td><td>Total Lending at SLP:Rs.</td><td>'+Cast(@TSLP As Varchar(16))+'</td><tr>'
				Set @Mail1=@Mail1+'<tr><td>Total Borrowing Fees: Rs.</td><td>'+Cast(@TBorrowingFees As Varchar(16))+'</td><td>Total Lending Fees: Rs.</td><td>'+Cast(@TLendingFees As Varchar(16))+'</td><tr>'
				Set @Mail1=@Mail1+'<tr><td>Total Processing Charges: Rs.</td><td>'+Cast(@TBProcess As Varchar(16))+'</td><td>Total Processing Charges: Rs.</td><td>'+Cast(@TLProcess As Varchar(16))+'</td><tr>'
				Set @Mail1=@Mail1+'<tr><td>You are requested to issue a cheque for Rs.</td><td> '+Cast(@TDrCr As Varchar(25))+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'

				Set @Mail1=@Mail1+'</td><td>You are requested to credit our pool a/c with securities by:</td><td>'+CONVERT(VARCHAR(10), convert(date,@TranDate), 103)+'</td><tr>'
			Set @Mail1=@Mail1+'	</table> <br>  <br> <br>  '    
			 

			 -------------------------------------------------------------------
			 Set @Mail1=@Mail1+' <table border=0>'
			 Set @Mail1=@Mail1+'<tr><td>Other levies(if any):</td><td></td></tr>'
				Set @Mail1=@Mail1+'<tr><td>Total Service Tax:</td><td>'+Cast(@TBuySTax As Varchar(16))+'&nbsp;&nbsp;&nbsp; </td><td>Total Service Tax:</td><td>'+Cast(@Tsellstax As Varchar(16))+'</td><tr>'
				Set @Mail1=@Mail1+'<tr><td>Total Education Cess:</td><td>'+Cast(@TBuyEcess As Varchar(16))+'</td><td>Total Education Cess:</td><td>'+Cast(@Tsellecess As Varchar(16))+'</td><tr>'
				Set @Mail1=@Mail1+'<tr><td>Total :</td><td>'+Cast(@TotalBuyTax As Varchar(16))+'</td><td>Total :</td><td>'+Cast(@TotalSellTax As Varchar(16))+'</td><tr>'
				Set @Mail1=@Mail1+'<tr><td>Your a/c will be '+@str+' towards Securities Lending & Borrowing for Rs. '+Cast(@TDrCr As Varchar(25))+'&nbsp;&nbsp;&nbsp;</td>'
			Set @Mail1=@Mail1+'	</table>' 

			



Set @Mail1=@Mail1+'<br><br><p>This memo constitutes and shall be deemed to constitute an agreement between you and me/us,and in the event of any claim
					(whether admitted or not),difference or dispute in respect of any dealings,of a date prior or subsequent to the date of this
					confirmaion memo(icluding any question whether such dealing have been enered into or not)shall be referred to arbitration.</p>
					<p>All disputes and differences or questions arising out of or in relation to this memo including obligations,failure or breach
					thereof by any of the parties and/or of any matter whatsoever arising out of the memo shall in the first instance be
					resolved mutually by the parties.If the parties fail to resolve the same mutually,then the same shall be referred to
					arbitration as provided in the Rules,Byelaws and Regulaions of the Bombay Stock Exchange Ltd.</p>
					<p>In matters where the AI is a party to the dispue, the Civil Courts at Mumbai shall have exclusive jurisdiction
					as provided in Part B of the SLB Agreement between the SLB Member and Client.</p>'

Set @Mail1=@Mail1+'<table border =0><tr><td>Date:'+CONVERT(VARCHAR(10), convert(date,@TranDate), 103)+'</td><td style="TEXT-ALIGN: right;max-width: 2480px;width:50%;"></td><td style="TEXT-ALIGN: left;max-width: 2480px;width:75%;">yours faithfully,</td></tr>'
Set @Mail1=@Mail1+'<tr><td>Place:'+@LocDescription_+'</td><td style="TEXT-ALIGN: right;max-width: 2480px;width:50%;"></td><td style="TEXT-ALIGN: left;max-width: 2480px;width:90%;"></td></tr>'
Set @Mail1=@Mail1+'<tr><td></td><td style="TEXT-ALIGN: right;max-width: 2480px;width:50%;"></td><td style="TEXT-ALIGN: left;max-width: 2480px;width:90%;"For&nbsp;'    +@CompanyName+'</td></tr>'
Set @Mail1=@Mail1+'<tr><td></td><td style="TEXT-ALIGN: right;max-width: 2480px;width:50%;"></td><td style="TEXT-ALIGN: left;max-width: 2480px;width:90%;">Name & Signature of Authorised Signatory</td></tr>'
Set @Mail1=@Mail1+'<tr><td></td><td style="TEXT-ALIGN: right;max-width: 2480px;width:50%;"></td><td style="TEXT-ALIGN: left;max-width: 2480px;width:90%;">PAN of SLB Member:AABCG1935E</td></tr></table>'


SET @MAIL=@MAIL+@Mail1

SELECT @MAIL

print @TDrCr


--EXEC [spSLB_html_report] '1290078408','NLB','20190903'

   End      

