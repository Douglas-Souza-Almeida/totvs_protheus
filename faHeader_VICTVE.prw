Static Function faHeader()

	Local aRet	:= {}

	//DESABILITADO PARA ATENDER O TIC-66765
	// campos exibidos CABEÇALHO
	/*
	AAdd( aRet, {"" 		  , "COLBMP1"  , "@BMP"				 , 02, 0,,, "C",,"" } )
	AAdd( aRet, {"Cód.Produto", "PRODUTO"  , "@!"				 , 06, 0,,, "C",,"" } )
	AAdd( aRet, {"Produto"	  , "DESCRICAO", "@!"				 , 40, 0,,, "C",,"" } )
	AAdd( aRet, {"Estoque"	  , "ECOTA"	   , "@E 999,999,999,999", 12, 0,,, "N",,"" } )
	AAdd( aRet, {"Saldo"	  , "SCOTA"	   , "@E 999,999,999,999", 12, 0,,, "N",,"" } )
	*/

	//AJUSTADO PARA ATENDER O TIC-66765
	AAdd(aRet, 	{""					, "COLBMP1"		, "@BMP"		, 02, 00,,, "C",,"" } )	
   	aAdd(aRet,  {"Vendedor"			, "VENDEDOR"	, "@!"        	, 08, 00, "" , "", "C", "", "", "", "", "", "", "", "", "" })
   	aAdd(aRet,  {"Nome Vendedor"   	, "NOMEVEND"	, "@!"        	, 36, 00, "" , "", "C", "", "", "", "", "", "", "", "", "" })
   	aAdd(aRet,  {"Produto"			, "PRODUTO"		, "@!"         	, 08, 00, "" , "", "C", "", "", "", "", "", "", "", "", "" })
   	aAdd(aRet,  {"Descrição"		, "DESCRPROD"	, "@!"      	, 38, 00, "" , "", "C", "", "", "", "", "", "", "", "", "" })
   	aAdd(aRet,  {"Entrada"			, "COTATOTAL"	, "999,999.99"	, 08, 02, "" , "", "N", "", "", "", "", "", "", "", "", "" })
   	aAdd(aRet,  {"Transf. E."		, "COTATRANE"	, "999,999.99"	, 08, 02, "" , "", "N", "", "", "", "", "", "", "", "", "" }) 
    aAdd(aRet,  {"Transf. S."		, "COTATRANS"	, "999,999.99"	, 08, 02, "" , "", "N", "", "", "", "", "", "", "", "", "" })  	 
   	aAdd(aRet,  {"Saída"			, "COTAUTILI"	, "999,999.99"	, 08, 02, "" , "", "N", "", "", "", "", "", "", "", "", "" })
   	aAdd(aRet,  {"Est. Restante" 	, "COTARESTA"	, "999,999.99"	, 08, 02, "" , "", "N", "", "", "", "", "", "", "", "", "" })  

Return aRet
/************************************************************************
	aCols
************************************************************************/
Static Function faCols()

	Local aRet			:= {}
	Local cAliasTMP		:= GetNextAlias()
	Local cVend			:= AllTrim(cUserName)	 //Pega o vendedor logado
	Local lPeriodoCota	:= .F.

	DbSelectArea("ZZ8")
	ZZ8->(DbSetOrder(2))
	If ZZ8->( MsSeek(xFilial("ZZ8")+"A") )
		If dDataBase >= ZZ8->ZZ8_DATAIN .And. dDataBase <= ZZ8->ZZ8_DATAFI
			lPeriodoCota := .T.
		EndIf
	EndIf

	BeginSQL Alias cAliasTMP

	// DESABILITADO PARA ATENDER O TIC-66765
	/*
		SELECT
			ZZ0.ZZ0_VENDED AS VENDEDOR,
			ZZ0.ZZ0_PRODUT AS PRODUTO,
			SB1.B1_DESC    AS DESCRICAO,
			(SELECT ISNULL(SUM(ZZ0_QUANTI),0) AS COTA FROM %table:ZZ0% ZZ
			WHERE ZZ.ZZ0_CODCOT IN (SELECT Z8.ZZ8_CODIGO FROM %table:ZZ8% Z8 WHERE Z8.ZZ8_STATUS = 'A' AND Z8.%notDel%)
			AND   ZZ.ZZ0_VENDED = ZZ0.ZZ0_VENDED
			AND   ZZ.ZZ0_PRODUT = ZZ0.ZZ0_PRODUT
			AND   ZZ.ZZ0_STATUS = 'A'
			AND   ZZ.ZZ0_QUANTI > 0
			AND   ZZ.ZZ0_TIPOMO = 'E'
			AND   ZZ.%notDel%
			GROUP BY ZZ.ZZ0_VENDED, ZZ.ZZ0_PRODUT
			HAVING SUM(ZZ.ZZ0_QUANTI) >= 0) AS ECOTA,
			ISNULL(SUM(ZZ0.ZZ0_QUANTI),0)   AS SCOTA
		FROM
			%table:ZZ0% ZZ0
		INNER JOIN
			%table:SB1% SB1
			   ON SB1.B1_COD = ZZ0.ZZ0_PRODUT AND
			   	  SB1.%notDel%
		INNER JOIN
			%table:ZZ1% ZZ1
			   ON ZZ1.ZZ1_PRODUT = ZZ0.ZZ0_PRODUT AND
			   	  ZZ1.%notDel%
		WHERE
			ZZ0.ZZ0_CODCOT IN (SELECT ZZ8.ZZ8_CODIGO FROM %table:ZZ8% ZZ8 WHERE ZZ8.ZZ8_STATUS = 'A' AND ZZ8.%notDel%) AND
			ZZ0.ZZ0_STATUS = 'A' AND
			ZZ0.ZZ0_VENDED = %exp: cVend % AND
			ZZ0.%notDel% AND
			ZZ1.ZZ1_STATUS = 'C'
		GROUP BY
			ZZ0.ZZ0_VENDED, ZZ0.ZZ0_PRODUT, SB1.B1_DESC
		ORDER BY
			ZZ0.ZZ0_PRODUT
	
	*/

	//QUERY PARA ATENDER O TIC-66765
	SELECT DISTINCT 
				Z1.ZZ1_STATUS	AS STATUS, 
				Z0.ZZ0_VENDED	AS VENDEDOR,
				A3.A3_NOME		AS NOMEVEND,
				Z0.ZZ0_PRODUT	AS PRODUTO,
				B1.B1_DESC		AS DESCRPROD,	
				
				(SELECT (
					CASE WHEN SUM(Z10.ZZ0_QUANTI) IS NULL 
					THEN 0 
					ELSE SUM(Z10.ZZ0_QUANTI) END) AS QTDE
				FROM %table:ZZ0% Z10 
				WHERE Z10.ZZ0_VENDED = Z0.ZZ0_VENDED
				AND Z10.ZZ0_PRODUT = Z0.ZZ0_PRODUT
				AND Z10.ZZ0_CODCOT = Z8.ZZ8_CODIGO
				AND Z10.ZZ0_TIPOMO = 'E'
				AND Z10.ZZ0_MOTIVO <> 'T'
				AND Z10.%notDel%
				AND Z0.ZZ0_STATUS = 'A') AS COTATOTAL,

				(SELECT ( 
					CASE WHEN SUM(Z50.ZZ0_QUANTI) IS NULL
					THEN 0
					ELSE SUM(Z50.ZZ0_QUANTI) END) AS QTDE
				FROM %table:ZZ0% Z50
				WHERE Z50.ZZ0_VENDED = Z0.ZZ0_VENDED
				AND Z50.ZZ0_PRODUT = Z0.ZZ0_PRODUT
				AND Z50.ZZ0_CODCOT = Z8.ZZ8_CODIGO
				AND Z50.ZZ0_TIPOMO = 'E'
				AND Z50.ZZ0_MOTIVO = 'T'
				AND Z50.%notDel%
				AND Z0.ZZ0_STATUS = 'A') AS COTATRANE,
				
				(SELECT (
					CASE WHEN SUM(Z20.ZZ0_QUANTI)*-1 IS NULL
					THEN 0
					ELSE SUM(Z20.ZZ0_QUANTI)*-1 END) AS QTDE
					FROM %table:ZZ0% Z20
					WHERE Z20.ZZ0_VENDED = Z0.ZZ0_VENDED
					AND Z20.ZZ0_PRODUT = Z0.ZZ0_PRODUT
					AND Z20.ZZ0_CODCOT = Z8.ZZ8_CODIGO
					AND Z20.ZZ0_TIPOMO = 'S'
					AND Z20.ZZ0_MOTIVO = 'T'
					AND Z20.%notDel%
					AND Z0.ZZ0_STATUS = 'A') AS COTATRANS,
					
					(SELECT (
						CASE WHEN SUM(Z60.ZZ0_QUANTI)*-1 IS NULL
						THEN 0
						ELSE SUM(Z60.ZZ0_QUANTI)*-1 END) AS QTDE
						FROM %table:ZZ0% Z60
						WHERE Z60.ZZ0_VENDED = Z0.ZZ0_VENDED
						AND Z60.ZZ0_PRODUT = Z0.ZZ0_PRODUT
						AND Z60.ZZ0_CODCOT = Z8.ZZ8_CODIGO
						AND Z60.ZZ0_TIPOMO = 'S'
						AND Z60.ZZ0_MOTIVO <> 'T'
						AND Z60.%notDel%
						AND Z0.ZZ0_STATUS = 'A') AS COTAUTILI,
						
						(
							SELECT (
								CASE WHEN SUM(Z30.ZZ0_QUANTI) IS NULL 
								THEN 0 
								ELSE SUM(Z30.ZZ0_QUANTI) END) AS QTDE 
								FROM %table:ZZ0% Z30 
								WHERE Z30.ZZ0_VENDED = Z0.ZZ0_VENDED
								AND Z30.ZZ0_PRODUT = Z0.ZZ0_PRODUT
								AND Z30.ZZ0_CODCOT = Z8.ZZ8_CODIGO 
								AND Z30.ZZ0_TIPOMO = 'E' 
								AND Z30.%notDel%
								AND Z0.ZZ0_STATUS = 'A')
							-
								(SELECT (
									CASE WHEN SUM(Z40.ZZ0_QUANTI)*-1 IS NULL 
									THEN 0 
									ELSE SUM(Z40.ZZ0_QUANTI)*-1 END) AS QTDE 
									FROM %table:ZZ0% Z40 
									WHERE Z40.ZZ0_VENDED = Z0.ZZ0_VENDED 
									AND Z40.ZZ0_PRODUT = Z0.ZZ0_PRODUT 
									AND Z40.ZZ0_CODCOT = Z8.ZZ8_CODIGO 
									AND Z40.ZZ0_TIPOMO = 'S' 
									AND Z40.%notDel% 
									AND Z0.ZZ0_STATUS = 'A'
									)
							 AS COTARESTA
							
	FROM %table:ZZ8% Z8
	INNER JOIN ZZ0010 Z0 
		ON Z0.ZZ0_CODCOT = Z8.ZZ8_CODIGO 

	INNER JOIN SA3010 A3
		ON A3.A3_COD = Z0.ZZ0_VENDED 

	INNER JOIN SB1010 B1 
		ON B1.B1_COD = Z0.ZZ0_PRODUT 

	INNER JOIN ZZ1010 Z1 
		ON Z1.ZZ1_PRODUT = Z0.ZZ0_PRODUT

	WHERE Z8.ZZ8_STATUS = 'A' 
	AND Z0.ZZ0_STATUS 	= 'A'
	AND Z0.ZZ0_VENDED 	= %exp: cVend%
	AND Z8.%notDel%
	AND Z0.%notDel%
	AND A3.%notDel%
	AND B1.%notDel%
	AND Z1.%notDel%

	ORDER BY Z0.ZZ0_VENDED, Z0.ZZ0_PRODUT
	EndSQL

	DbSelectArea(cAliasTMP)
	If (cAliasTMP)->( Eof() ) .Or. !lPeriodoCota
		AAdd( aRet, { "BR_VERMELHO", "", "", "", "",.F. } )
	Else
		While (cAliasTMP)->( !Eof() )

		//DESABILITA PARA ATENDER O TIC-66765
		/*
			AAdd( aRet, { IIf((cAliasTMP)->SCOTA > 0,"BR_VERDE","BR_VERMELHO"),;
						 (cAliasTMP)->PRODUTO	,;
						 (cAliasTMP)->DESCRICAO	,;
						 (cAliasTMP)->ECOTA		,;
						 (cAliasTMP)->SCOTA		,;
				  		.F. } )
			*/

		//AJUSTADO PARA ATENDER O TIC-66765	
			AAdd( aRet, { IIf((cAliasTMP)->STATUS == "A","BR_VERDE", IIF((cAliasTMP)->STATUS == "C", "BR_AZUL","BR_PRETO")),;
						(cAliasTMP)->VENDEDOR,;
						(cAliasTMP)->NOMEVEND,;
						(cAliasTMP)->PRODUTO,;
						(cAliasTMP)->DESCRPROD,;
						(cAliasTMP)->COTATOTAL,;
						(cAliasTMP)->COTATRANE,; 
						(cAliasTMP)->COTATRANS,;
						(cAliasTMP)->COTAUTILI,;
						(cAliasTMP)->COTARESTA,;
						.F.})

			(cAliasTMP)->(DbSkip())
		Enddo
	EndIf
	(cAliasTMP)->( DbCloseArea() )

Return aRet
