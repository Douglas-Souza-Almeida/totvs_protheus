/*/
{Protheus.doc} SMCOM010
Verifica��o e valida��o do tipo de solicita��o de compras
@type function
@version  
@author Douglas
@since jul/2024
/*/

// Inclui as bibliotecas necess�rias
#Include 'Protheus.ch'

User Function SMCOM010()
    // Inicializa a vari�vel l�gica lRet como verdadeira
    Local lRet          := .T. as logical
     // Inicializa a vari�vel nLinha com 0 utilizada no la�o For
    Local nLinha        := 0
     // Obt�m a posi��o do campo C1_CC no cabe�alho aHeader
    Local nCntCst       := aScan(aHeader,{|x| Alltrim(x[2]) == 'C1_CC'})
    // Obt�m a posi��o do campo C1_CLVL no cabe�alho aHeader
    Local nNimble       := aScan(aHeader,{|x| Alltrim(x[2]) == "C1_CLVL"})
    // Declara uma vari�vel p�blica para ser vis�vel no fonte M110STTS.PRW
    Public nRadioTpSC   := 0 // Define nRadioTpSC baseado no valor de cTpComp
     
        // Verifica do tipo de solicita��o de compras e atribui valor a nRadioTpSC
        Do Case 
            Case cTpComp == "N-Normal"
                nRadioTpSC := 1
            Case cTpComp == "C-Contrato"
                nRadioTpSC := 2
            // Valida SC Direta com Centro de Custo
            Case cTpComp == "D-Direta"
                nRadioTpSC := 3
                // Percorre todas as linhas n�o vazias e verifica se o campo Centro de Custo est� preenchido
                For nLinha := 1 To Len(aCols)
                    If !LinDelet(aCols[nLinha])
                        If (Empty(aCols[nLinha][nCntCst]) .AND. Empty(aCols[nLinha][nNimble]))
                            lRet := .F.
                            // Exibe alerta se o Centro de Custo estiver vazio
                            FWAlertWarning("� necess�rio informar o Centro de Custo ou Nimble para todos os itens da solicita��o de compras do tipo direta", "Centro de Custo / Nimble")
                            Exit // Encerra o la�o
                        EndIf
                    EndIf
                Next nLinha
            Case cTpComp == "A-Ad Hoc"
                nRadioTpSC := 4
            Case cTpComp == "J-Justificada"
                nRadioTpSC := 5
            Case cTpComp = ''
                lRet := .F.
                // Exibe alerta se o Tipo de Solicita��o de Compra n�o for informado
                FWAlertWarning("Selecione o Tipo da Solicita��o de Compra", "Tipo de Solicita��o")
        EndCase
Return(lRet)
