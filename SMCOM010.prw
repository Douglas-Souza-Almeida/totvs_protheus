/*/
{Protheus.doc} SMCOM010
Verificação e validação do tipo de solicitação de compras
@type function
@version  
@author Douglas
@since jul/2024
/*/

// Inclui as bibliotecas necessárias
#Include 'Protheus.ch'

User Function SMCOM010()
    // Inicializa a variável lógica lRet como verdadeira
    Local lRet          := .T. as logical
     // Inicializa a variável nLinha com 0 utilizada no laço For
    Local nLinha        := 0
     // Obtém a posição do campo C1_CC no cabeçalho aHeader
    Local nCntCst       := aScan(aHeader,{|x| Alltrim(x[2]) == 'C1_CC'})
    // Obtém a posição do campo C1_CLVL no cabeçalho aHeader
    Local nNimble       := aScan(aHeader,{|x| Alltrim(x[2]) == "C1_CLVL"})
    // Declara uma variável pública para ser visível no fonte M110STTS.PRW
    Public nRadioTpSC   := 0 // Define nRadioTpSC baseado no valor de cTpComp
     
        // Verifica do tipo de solicitação de compras e atribui valor a nRadioTpSC
        Do Case 
            Case cTpComp == "N-Normal"
                nRadioTpSC := 1
            Case cTpComp == "C-Contrato"
                nRadioTpSC := 2
            // Valida SC Direta com Centro de Custo
            Case cTpComp == "D-Direta"
                nRadioTpSC := 3
                // Percorre todas as linhas não vazias e verifica se o campo Centro de Custo está preenchido
                For nLinha := 1 To Len(aCols)
                    If !LinDelet(aCols[nLinha])
                        If (Empty(aCols[nLinha][nCntCst]) .AND. Empty(aCols[nLinha][nNimble]))
                            lRet := .F.
                            // Exibe alerta se o Centro de Custo estiver vazio
                            FWAlertWarning("É necessário informar o Centro de Custo ou Nimble para todos os itens da solicitação de compras do tipo direta", "Centro de Custo / Nimble")
                            Exit // Encerra o laço
                        EndIf
                    EndIf
                Next nLinha
            Case cTpComp == "A-Ad Hoc"
                nRadioTpSC := 4
            Case cTpComp == "J-Justificada"
                nRadioTpSC := 5
            Case cTpComp = ''
                lRet := .F.
                // Exibe alerta se o Tipo de Solicitação de Compra não for informado
                FWAlertWarning("Selecione o Tipo da Solicitação de Compra", "Tipo de Solicitação")
        EndCase
Return(lRet)
