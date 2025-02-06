Static Function geraExcel(oBrowse00, aDados, cAnoTela)
	FwMsgRun(,{|| fCriaExcel(oBrowse00, aDados, cAnoTela)},"Aguarde", "Gerando arquivo em Excel...")
Return
Static Function fCriaExcel(oBrowse00, aDados, cAnoTela)

    // vari�veis
    Local oExcel // objeto para intera��o com o Excel
    Local oPrintXlsx // objeto para manipula��o de planilhas via biblioteca FWMsExcel
	Local oFileRead // objeto para leitura de arquivos
	Local oCellHoriz  	:= FwXlsxCellAlignment():Horizontal() // objeto para alinhamento horizontal
    Local oCellVerti 	:= FwXlsxCellAlignment():Vertical() // objeto para alinhamento vertical

	Local i 			:= 0 // vari�vel de intera��o para controle de cabe�alho	
	Local y 			:= 0 // vari�vel de intera��o para controle de conte�do das linhas
	Local z 			:= 0 // vari�vel de intera��o para controle de colunas
	
	Local nCor		  	:= 0 // vari�vel para controle de cores
	Local nLinha	  	:= 0 // vari�vel para controle de linhas
	Local nRotation   	:= 0 // vari�vel para rota��o
	Local nTamFonte   	:= 10 // vari�vel para tamanho da fonte
	
	Local lItalico    	:= .F. // vari�vel para it�lico
    Local lNegrito    	:= .F. // vari�vel para negrito
    Local lSublinhado 	:= .F. // vari�vel para sublinhado
    Local lQuebrLin   	:= .F. // vari�vel para quebra de linha

	Local cConteudo   	:= "" // vari�vel para conte�do do arquivo
	Local cHorAlinha  	:= "" // vari�vel para alinhamento horizontal
    Local cVerAlinha  	:= "" // vari�vel para alinhamento vertical
	Local cFonte      	:= FwPrinterFont():Arial() // vari�vel para fonte
    Local cCustForma  	:= "" // vari�vel para formata��o customizada
	Local cLogo		  	:= "\system\Logo_2.bmp" // vari�vel para caminho do logo
	Local cArquivo 		:= GetTempPath(.T.,.F.)+'52_semanas.rel'  // Caminho do arquivo tempor�rio XML

	Local aTamanho		:= Array(1,Len(oBrowse00:aColumns)) // array para controle de tamanho das colunas))
	
	oPrintXlsx := FwPrinterXlsx():New()	// objeto para manipula��o de planilhas via biblioteca FWMsExcel
	oPrintXlsx:Activate(cArquivo) // ativando o objeto de manipula��o para finalizar as opera��es
	oPrintXlsx:AddSheet("Manuten��o de Ativos") // adicionando uma nova aba ao arquivo Excel

	// adicionando a logo ao arquivo Excel
	oFileRead := FwFileReader():New(cLogo) // objeto para leitura de arquivos
	
	If oFileRead:Open()
    	cConteudo  := oFileRead:FullRead()
    EndIf
    
	oFileRead:Close()
	oPrintXlsx:AddImageFromBuffer(1, 1, "logo", cConteudo)
	
	// definindo o t�tulo
	nTamFonte 	:= 12 // tamanho da fonte
    lNegrito  	:= .T. // negrito
	cHorAlinha 	:= oCellHoriz:Center() // alinhamento horizontal
	cVerAlinha  := oCellVerti:Center() // alinhamento vertical

	oPrintXlsx:SetFont(cFonte, nTamFonte, lItalico, lNegrito, lSublinhado) // definindo a fonte
	oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, "000000", "FFFFFF", cCustForma) // definindo o formato das c�lulas
	oPrintXlsx:MergeCells(1, 1, 2, Len(oBrowse00:aColumns)) // mesclando c�lulas
	oPrintXlsx:SetText(1, 1, "PLANO DE MANUTEN��O ANUAL - "+cAnoTela+" - 52 SEMANAS") // texto do t�tulo
	
	// definindo cabe�alho
	nTamFonte 	:= 10 // tamanho da fonte
    lNegrito  	:= .T. // negrito
	nLinha 		:= 3 // linha inicial
	
	oPrintXlsx:SetFont(cFonte, nTamFonte, lItalico, lNegrito, lSublinhado) // definindo a fonte
	oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, "000000", "E8E8E8", cCustForma) // definindo o formato das c�lulas
	
	// atribuindo o conte�do ao cabe�alho
	For i := 1 to Len(oBrowse00:aColumns)
		aTamanho[1][i] := Len(oBrowse00:aColumns[i]:CHEADING)*1.2 // armazenando o tamanho do conte�do
		oPrintXlsx:SetColumnsWidth(i, i, aTamanho[1][i])
		oPrintXlsx:SetText(nLinha, i, oBrowse00:aColumns[i]:CHEADING)
	Next i
	oPrintXlsx:ApplyAutoFilter(nLinha, 1, nLinha, Len(oBrowse00:aColumns)) // adicionando op��o de filtro ao cabe�alho

	// definindo o conte�do
	nLinha++ // incrementando a linha
	lNegrito  	:= .F. // negrito
	cHorAlinha 	:= oCellHoriz:Left() // alinhamento horizontal
	nCor 		:= 0 // controle para cores

	oPrintXlsx:SetFont(cFonte, nTamFonte, lItalico, lNegrito, lSublinhado) // definindo a fonte
	oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, "000000", "00FFFF", cCustForma) // definindo o formato das c�lulas

	// atribuindo o conte�do as linhas
	For y := 1 to Len(aDados)
		nCor++

			// alterando a cor de preenchimento a cada 2 linhas
		If nCor <= 2
				oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, "000000", "00FFFF", cCustForma) // definindo a cor
		Else
			oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, "000000", "C0C0C0", cCustForma) // definindo a cor
			If nCor		== 4
				nCor	:= 0
			EndIf
		EndIf
		
		For  z := 1 to Len(oBrowse00:aColumns)
			If ValType(aDados[y][z]) == 'N'
				If aTamanho[1][z] < Len(AllToChar(aDados[y][z]))*1.2
					aTamanho[1][z] := Len(AllToChar(aDados[y][z]))*1.2 // armazenando o tamanho da coluna
				EndIf
				oPrintXlsx:SetText(nLinha, z, AllToChar(aDados[y][z], "@E 999.99"))
			Else
				If aTamanho[1][z] < Len(AllTrim(AllToChar(aDados[y][z])))*1.2
					aTamanho[1][z] := Len(AllTrim(AllToChar(aDados[y][z])))*1.2 // armazenando o tamanho da coluna
				EndIf
				oPrintXlsx:SetColumnsWidth(z, z, aTamanho[1][z]) // definindo o tamanho da coluna
				oPrintXlsx:SetText(nLinha, z, AllTrim(AllToChar(aDados[y][z], "@")))
			EndIf

		Next z	

		nLinha++ // incrementando a linha

	Next y

	oPrintXlsx:ToXlsx() // gerando o arquivo XLSX
	cArquivo := StrTran(cArquivo, ".rel", ".xlsx") // alterando a extens�o do arquivo
    oPrintXlsx:DeActivate() // desativando o objeto de manipula��o
    
    oExcel := MsExcel():New() // objeto para intera��o com o Excel

    oExcel:WorkBooks:Open(cArquivo) // abrindo o arquivo XML no Excel
    
    oExcel:SetVisible(.T.) // tornando o Excel vis�vel
    
    oExcel:Destroy() // destruindo o objeto

Return
