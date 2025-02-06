Static Function geraExcel(oBrowse00, aDados, cAnoTela)
	FwMsgRun(,{|| fCriaExcel(oBrowse00, aDados, cAnoTela)},"Aguarde", "Gerando arquivo em Excel...")
Return
Static Function fCriaExcel(oBrowse00, aDados, cAnoTela)

    // variáveis
    Local oExcel // objeto para interação com o Excel
    Local oPrintXlsx // objeto para manipulação de planilhas via biblioteca FWMsExcel
	Local oFileRead // objeto para leitura de arquivos
	Local oCellHoriz  	:= FwXlsxCellAlignment():Horizontal() // objeto para alinhamento horizontal
    Local oCellVerti 	:= FwXlsxCellAlignment():Vertical() // objeto para alinhamento vertical

	Local i 			:= 0 // variável de interação para controle de cabeçalho	
	Local y 			:= 0 // variável de interação para controle de conteúdo das linhas
	Local z 			:= 0 // variável de interação para controle de colunas
	
	Local nCor		  	:= 0 // variável para controle de cores
	Local nLinha	  	:= 0 // variável para controle de linhas
	Local nRotation   	:= 0 // variável para rotação
	Local nTamFonte   	:= 10 // variável para tamanho da fonte
	
	Local lItalico    	:= .F. // variável para itálico
    Local lNegrito    	:= .F. // variável para negrito
    Local lSublinhado 	:= .F. // variável para sublinhado
    Local lQuebrLin   	:= .F. // variável para quebra de linha

	Local cConteudo   	:= "" // variável para conteúdo do arquivo
	Local cHorAlinha  	:= "" // variável para alinhamento horizontal
    Local cVerAlinha  	:= "" // variável para alinhamento vertical
	Local cFonte      	:= FwPrinterFont():Arial() // variável para fonte
    Local cCustForma  	:= "" // variável para formatação customizada
	Local cLogo		  	:= "\system\Logo_2.bmp" // variável para caminho do logo
	Local cArquivo 		:= GetTempPath(.T.,.F.)+'52_semanas.rel'  // Caminho do arquivo temporário XML

	Local aTamanho		:= Array(1,Len(oBrowse00:aColumns)) // array para controle de tamanho das colunas))
	
	oPrintXlsx := FwPrinterXlsx():New()	// objeto para manipulação de planilhas via biblioteca FWMsExcel
	oPrintXlsx:Activate(cArquivo) // ativando o objeto de manipulação para finalizar as operações
	oPrintXlsx:AddSheet("Manutenção de Ativos") // adicionando uma nova aba ao arquivo Excel

	// adicionando a logo ao arquivo Excel
	oFileRead := FwFileReader():New(cLogo) // objeto para leitura de arquivos
	
	If oFileRead:Open()
    	cConteudo  := oFileRead:FullRead()
    EndIf
    
	oFileRead:Close()
	oPrintXlsx:AddImageFromBuffer(1, 1, "logo", cConteudo)
	
	// definindo o título
	nTamFonte 	:= 12 // tamanho da fonte
    lNegrito  	:= .T. // negrito
	cHorAlinha 	:= oCellHoriz:Center() // alinhamento horizontal
	cVerAlinha  := oCellVerti:Center() // alinhamento vertical

	oPrintXlsx:SetFont(cFonte, nTamFonte, lItalico, lNegrito, lSublinhado) // definindo a fonte
	oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, "000000", "FFFFFF", cCustForma) // definindo o formato das células
	oPrintXlsx:MergeCells(1, 1, 2, Len(oBrowse00:aColumns)) // mesclando células
	oPrintXlsx:SetText(1, 1, "PLANO DE MANUTENÇÃO ANUAL - "+cAnoTela+" - 52 SEMANAS") // texto do título
	
	// definindo cabeçalho
	nTamFonte 	:= 10 // tamanho da fonte
    lNegrito  	:= .T. // negrito
	nLinha 		:= 3 // linha inicial
	
	oPrintXlsx:SetFont(cFonte, nTamFonte, lItalico, lNegrito, lSublinhado) // definindo a fonte
	oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, "000000", "E8E8E8", cCustForma) // definindo o formato das células
	
	// atribuindo o conteúdo ao cabeçalho
	For i := 1 to Len(oBrowse00:aColumns)
		aTamanho[1][i] := Len(oBrowse00:aColumns[i]:CHEADING)*1.2 // armazenando o tamanho do conteúdo
		oPrintXlsx:SetColumnsWidth(i, i, aTamanho[1][i])
		oPrintXlsx:SetText(nLinha, i, oBrowse00:aColumns[i]:CHEADING)
	Next i
	oPrintXlsx:ApplyAutoFilter(nLinha, 1, nLinha, Len(oBrowse00:aColumns)) // adicionando opção de filtro ao cabeçalho

	// definindo o conteúdo
	nLinha++ // incrementando a linha
	lNegrito  	:= .F. // negrito
	cHorAlinha 	:= oCellHoriz:Left() // alinhamento horizontal
	nCor 		:= 0 // controle para cores

	oPrintXlsx:SetFont(cFonte, nTamFonte, lItalico, lNegrito, lSublinhado) // definindo a fonte
	oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, "000000", "00FFFF", cCustForma) // definindo o formato das células

	// atribuindo o conteúdo as linhas
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
	cArquivo := StrTran(cArquivo, ".rel", ".xlsx") // alterando a extensão do arquivo
    oPrintXlsx:DeActivate() // desativando o objeto de manipulação
    
    oExcel := MsExcel():New() // objeto para interação com o Excel

    oExcel:WorkBooks:Open(cArquivo) // abrindo o arquivo XML no Excel
    
    oExcel:SetVisible(.T.) // tornando o Excel visível
    
    oExcel:Destroy() // destruindo o objeto

Return
