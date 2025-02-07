Static Function faCols()

	Local aRet			:= {}
	Local cAliasTMP		:= GetNextAlias()
	Local cVend			:= AllTrim(cUserName)	 //Pega o vendedor logado
	Local cPeriodo		:= SubStr(DToS(dDataBase),1,4)

	Local cCodUsr		:= RetCodUsr()
	Local cQryZBF		:= "" 
	Local cQryZB9		:= ""
	Local aCodVen		:= {} //array para armazenar os código dos vendedores
	Local aVend			:= {}
	Local cVend2		:= ""
	Local cEmailUsr := UsrRetMail(cCodUsr) //email de usuario logado
	Local cIdSup		:= ""
	Local nI			:= 0

	//busca o ID do supervisor
	cQryZBF := "SELECT ZBF_ID FROM ZBF010 WHERE ZBF_EMAIL = '" + cEmailUsr + "' AND D_E_L_E_T_ = ''"
	TCQuery cQryZBF New Alias "QRY_ZBF"
	cIdSup := QRY_ZBF->ZBF_ID
	
	//busca os vendedores do supervisor e monta um array com os codigos
	cQryZB9 := "SELECT ZB9_CODIGO FROM ZB9010 WHERE ZB9_CODSUP = '" + cIdSup + "' AND D_E_L_E_T_ = ''"
	TCSqlToArr(cQryZB9,@aCodVen)

	//ajusta o array de vendedores para realizar a consulta no banco e salva em outro array
	For nI := 1 To Len(aCodVen)
		If nI == 1
			aAdd(aVend, aCodVen[nI][1]+'"')
		Else 
			If nI != Len(aCodVen)
				aAdd(aVend,'"'+aCodVen[nI][1]+'"')
			Else
				aAdd(aVend,'"'+aCodVen[nI][1])
			EndIf
		EndIf
	Next

	//converte o array de vendedores em string
	cVend2 := CenArr2Str(aVend, ",")
	//substitui as aspas duplas por aspas simples
	cVend2 := StrTran(cVend2,'"',"'")


	//consulta no banco
	BeginSQL Alias cAliasTMP
		SELECT
			ZO.ZO_STATUS  AS STATUS,
			ZP.ZP_CODIGO  AS CODIGO,
			ZO.ZO_ABERTUR AS DTINI,
			ZO.ZO_ENCERRA AS DTFIM,
			ZP.ZP_VENDEDO AS VENDEDOR,
			A3.A3_NOME    AS NOME,
			ZP.ZP_CREDITO AS CREDITO,
			ZP.ZP_CREDADD AS CREDADD,
			(ZP.ZP_CREDITO + ZP.ZP_CREDADD) AS CREDTOTAL,
			ZP.ZP_CREDUTI AS CREDUTI,
			((ZP.ZP_CREDITO + ZP.ZP_CREDADD) - ZP.ZP_CREDUTI) AS CREDRES
		FROM
			%table:SZO% ZO
		INNER JOIN %table:SZP% ZP ON ZP.ZP_CODIGO = ZO.ZO_CODIGO  AND ZP.%notDel%
		INNER JOIN %table:SA3% A3 ON A3.A3_COD    = ZP.ZP_VENDEDO AND A3.%notDel%
		WHERE
			(ZP.ZP_VENDEDO = %exp: cVend% 
			OR ZP.ZP_VENDEDO IN (%exp: cVend2%)) 
			AND SUBSTRING(ZO.ZO_ABERTUR,1,4) >= %exp: cPeriodo% 
			AND ZO.%notDel%
		ORDER BY
			ZO.ZO_ABERTUR DESC
	EndSQL

	// preenche o ACOLS
	DbSelectArea(cAliasTMP)
	If (cAliasTMP)->( Eof() )
		AAdd( aRet, { "BR_VERMELHO", CToD("//"), CToD("//"), 0, 0, 0, 0, 0, .F. } )
	Else
		While (cAliasTMP)->( !Eof() )
			AAdd( aRet, {IIf((cAliasTMP)->STATUS == 'L',"BR_VERDE","BR_VERMELHO"),;
						 SToD((cAliasTMP)->DTINI)	,;
						 SToD((cAliasTMP)->DTFIM)	,;
						 (cAliasTMP)->NOME			,;
						 (cAliasTMP)->CREDITO		,;
						 (cAliasTMP)->CREDADD		,;
						 (cAliasTMP)->CREDTOTAL		,;
						 (cAliasTMP)->CREDUTI		,;
						 (cAliasTMP)->CREDRES		,;
				  		 .F. } )

			(cAliasTMP)->(DbSkip())
		Enddo
	EndIf
	
	// fecha a area
	(cAliasTMP)->( DbCloseArea() )
	// fecha consulta
	QRY_ZBF->(DbCloseArea())

Return aRet
