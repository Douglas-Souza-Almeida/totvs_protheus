Static Function fAltCli()

	DbSelectArea("SA1")

	
	Private cCodCli		:= SA1->A1_COD
	Private cLoja		:= SA1->A1_LOJA
	Private cNome		:= SA1->A1_NOME
	Private cRegiao 	:= SA1->A1_S_REG
	
	//TIC-66085 - ajuste
	Private cTabPrc		:= SA1->A1_TABELA
	Private cCodGrp  	:= SA1->A1_GRUPO
	Private cSeg		:= SA1->A1_SEGCLI
	Private cVen1		:= SA1->A1_VEND
	Private cVen2		:= SA1->A1_VEND2

	Private cGetTabPrc  := ''
	Private cGetVen1	:= ''
	Private cGetVen2	:= ''
	Private cGetGrp   	:= ''
	Private cGetSeg		:= ''
	Private nClrBack	:= 15132390 //cinza

	oDlg := MSDialog():New(000,000,260,350,"Cadastro de Clientes",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	//cliente
	oTSay1				:= TSay():New(015,004,{||"Cliente: "},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,050,010)
	oTGet1				:= TGet():New(013,038,{|| cCodCli },oDlg,025,010,"@!",,0,nClrBack,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cCodCli,,,, )
	oTGet1:lActive 		:= .F.
	
	//loja
	oTSay2				:= TSay():New(015,090,{||"Loja: "},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,050,010)
	oTGet2				:= TGet():New(013,124,{|| cLoja },oDlg,034,010,"@!",,0,nClrBack,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cLoja,,,, )
	oTGet2:lActive 		:= .F.
	
	//nome
	oTSay3				:= TSay():New(034,004,{||"Nome: "},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,050,010)
	oTGet3				:= TGet():New(034,038,{|| cNome },oDlg,122,010,"@!",,0,nClrBack,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cNome,,,, )
	oTGet3:lActive  	:= .F.
	
	//tabela de preço
	oTSay4				:= TSay():New(055,004,{||"Tab. Preço: "},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,050,010)
	cGetTabPrc  		:= cTabPrc
	oTGet10				:=	TGet():New(053,038, {|u| Iif(PCount() > 0 , cGetTabPrc := u, cGetTabPrc)},oDlg,044,010,"@!", ,0, , ,   , ,.T., ,   , ,   ,   , ,   ,   , , , , , ,.T. )
	oTget10:cF3 		:= "DA0"																			  
	oTget10:lReadOnly 	:= .F.																		  
	oTget10:bValid		:= {|| ExistCpo("DA0",cGetTabPrc)}		

	//vendedor1
	oTSay11				:= TSay():New(055,090,{||"Vendedor 1: "},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,050,010)
	cGetVen1 			:= cVen1
	oTGet11				:=	TGet():New(053,124, {|u| Iif(PCount() > 0 , cGetVen1 := u, cGetVen1)},oDlg,044,010,"@!", ,0, , ,   , ,.T., ,   , ,   ,   , ,   ,   , , , , , ,.T. )
	oTget11:cF3 		:= "SA3"																			   
	oTget11:lReadOnly 	:= .F.																		  
	oTget11:bValid		:= {|| ExistCpo("SA3",cGetVen1)}

	//segmento
	oTSay12				:= TSay():New(075,004,{||"Segmento: "},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,050,010)
	cGetSeg 			:= cSeg
	oTGet12				:=	TGet():New(073,038, {|u| Iif(PCount() > 0 , cGetSeg := u, cGetSeg)},oDlg,025,010,"@!", ,0, , ,   , ,.T., ,   , ,   ,   , ,   ,   , , , , , ,.T. )
	oTget12:cF3 		:= "ZR2"																			   
	oTget12:lReadOnly 	:= .F.																		   
	oTget12:bValid		:= {|| ExistCpo("ZR2",cGetSeg)}

	//vendedor2
	oTSay13				:= TSay():New(075,090,{||"Vendedor 2: "},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,050,010)
	cGetVen2 			:= cVen2
	oTGet13				:=	TGet():New(073,124, {|u| Iif(PCount() > 0 , cGetVen2 := u, cGetVen2)},oDlg,044,010,"@!", ,0, , ,   , ,.T., ,   , ,   ,   , ,   ,   , , , , , ,.T. )
	oTget13:cF3 		:= "SA3"																			   
	oTget13:lReadOnly 	:= .F.																		   
	oTget13:bValid		:= {|| ExistCpo("SA3",cGetVen2)}

	//grupo clientes
	oTSay14				:= TSay():New(095,004,{||"Grupo: "},oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,050,010)
	cGetGrp 			:= cCodGrp
	oTGet14				:=	TGet():New(093,038, {|u| Iif(PCount() > 0 , cGetGrp := u, cGetGrp)},oDlg,044,010,"@!", ,0, , ,   , ,.T., ,   , ,   ,   , ,   ,   , , , , , ,.T. )
	oTget14:cF3 		:= "ZR1"																			   
	oTget14:lReadOnly 	:= .F.																		  
	oTget14:bValid		:= {|| ExistCpo("ZR1",cGetGrp)}

	//botao salvar
	oTButton1			:= TButton():New(110,120,"Salvar",oDlg,{||fGrava(cCodCli,cLoja,cGetTabPrc,cGetGrp,cGetSeg,cGetVen1,cGetVen2)},045,013,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTButton1:SetCSS("TButton { font: bold;     background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #3DAFCC, stop: 1 #0D9CBF);    color: #FFFFFF;     border-width: 1px;     border-style: solid;     border-radius: 3px;     border-color: #369CB5; }TButton:focus {    padding:0px; outline-width:1px; outline-style:solid; outline-color: #51DAFC; outline-radius:3px; border-color:#369CB5;}TButton:hover {    color: #FFFFFF;     background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #3DAFCC, stop: 1 #1188A6);    border-width: 1px;     border-style: solid;     border-radius: 3px;     border-color: #369CB5; }TButton:pressed {    color: #FFF;     background-color : qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #1188A6, stop: 1 #3DAFCC);    border-width: 1px;     border-style: solid;     border-radius: 3px;     border-color: #369CB5; }TButton:disabled {    color: #FFFFFF;     background-color: #4CA0B5; }")
 
	//botao fechar
	oTButton2			:= TButton():New(110,070,"Fechar",oDlg,{||fecha()},045,013,,,.F.,.T.,.F.,,.F.,,,.F. )

	oDlg:Activate(,,,.T.,{||},,/*{||  EnchoiceBar(oDialog,{|| oDialog:End() },{|| oDialog:End() },,)}*/,,)

Return

Static Function fGrava(cCodCli,cLoja,cTabPrc,cCodGrp,cSeg,cVen1,cVen2)

	Local cOperacao   := "ALTERAÇÃO DE CAD. CLIENTE (CADSA1)"
	DbSelectArea("SA1")
	DbSetOrder(1)

	//grava log de alteracao - antes
	U_LOGZ0A(/*_cRotina*/ AllTrim(FunName()),/*_cSeq*/ "001",/*_cDesc*/ cOperacao,/*_cUser*/ AllTrim(cUserName),/*_dData1*/ dDataBase,/*_dData2*/ dDataBase,;
             /*_nNum1*/ 0,/*_cDescN1*/ "",/*_nNum2*/ 0,/*_cDescN2*/ "",/*_nNum3*/ 0,/*_cDescN3*/ "",/*_nNum4*/ 0,/*_cDescN4*/ "",/*_nNum5*/ 0,;
             /*_cDescN5*/ "",/*_cCmp1*/ SA1->A1_TABELA,/*_cDescC1*/ "A1_TABELA",/*_cCmp2*/SA1->A1_GRUPO,/*_cDescC2*/ "A1_GRUPO",/*_cCmp3*/SA1->A1_SEGCLI,/*_cDescC3*/ "A1_SEGCLI",;
			 /*_cCmp4*/SA1->A1_VEND,/*_cDescC4*/ "A1_VEND",/*_cCmp5*/ SA1->A1_VEND2 ,/*_cDescC5*/ "A1_VEND2",/*_cObs*/ "(ANTES) CLIENTE: "+cCodCli+"; LOJA: "+cLoja,/*_cFiltro*/ "")
	
	//grava log de alteracao - depois
	U_LOGZ0A(/*_cRotina*/ AllTrim(FunName()),/*_cSeq*/ "001",/*_cDesc*/ cOperacao,/*_cUser*/ AllTrim(cUserName),/*_dData1*/ dDataBase,/*_dData2*/ dDataBase,;
             /*_nNum1*/ 0,/*_cDescN1*/ "",/*_nNum2*/ 0,/*_cDescN2*/ "",/*_nNum3*/ 0,/*_cDescN3*/ "",/*_nNum4*/ 0,/*_cDescN4*/ "",/*_nNum5*/ 0,;
             /*_cDescN5*/ "",/*_cCmp1*/ cTabPrc,/*_cDescC1*/ "A1_TABELA",/*_cCmp2*/cCodGrp,/*_cDescC2*/ "A1_GRUPO",/*_cCmp3*/cSeg,/*_cDescC3*/ "A1_SEGCLI",;
			 /*_cCmp4*/cVen1,/*_cDescC4*/ "A1_VEND",/*_cCmp5*/ cVen2,/*_cDescC5*/ "A1_VEND2",/*_cObs*/ "(DEPOIS) CLIENTE: "+cCodCli+"; LOJA: "+cLoja,/*_cFiltro*/ "")
	
	//atualiza dados no banco
	RecLock("SA1",.F.)
	SA1->A1_TABELA	:= cTabPrc
	SA1->A1_GRUPO	:= cCodGrp
	SA1->A1_SEGCLI	:= cSeg
	SA1->A1_VEND	:= cVen1
	SA1->A1_VEND2	:= cVen2

	MsUnLock()

	//¦+---------------------------------------------------------+¦
	//¦¦Mobile SCL
	//¦+---------------------------------------------------------+¦
	U_MSCL103("Clientes","PUT","SA1")
	MsgAlert("Cadastro Atualizado.")
	oDlg:End()

Return
