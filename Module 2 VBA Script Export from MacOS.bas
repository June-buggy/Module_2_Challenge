Attribute VB_Name = "Module1"
Sub StockAnalysis()
' Aproach as follows:
' Gather Ticker symbols
' Output ticker symbols as first column of table
'
 ' Per plagirism guidelines, the following line is credited to an earlier activitiy,
' The following worksheet looping were extracted from 02-VBA Activity 07
For Each ws In Worksheets
    Dim WorksheetName As String
    Dim StockYear() As String
        WorksheetName = ws.Name
        
'Variables for scanning raw Data
    Dim LastSheetRow As Long
            ' Per plagirism guidelines, the following line is credited to an earlier activitiy,
            ' copy/pasted from the 02-VBA Activity 07
            LastSheetRow = ws.Cells(Rows.Count, 1).End(xlUp).Row

'Variables for analysis table construction

' The first row of the analysis table is the headers, of course, constructed here

' Written as such to account fo inevitable additional columne requirements for whatever
' stakeholder needs things written in crayon
            
    Dim RowReset As Integer
            RowReset = 2
    Dim ColIndex As Integer
            ColIndex = 9
    Dim RowEvalIndex As Integer
            RowEvalIndex = 1
    Dim HeaderMax As Integer
            HeaderMax = 3
    Dim HeaderArray(3) As String
            HeaderArray(0) = "Tickers"
            HeaderArray(1) = "Yearly Change"
            HeaderArray(2) = "Percent Change"
            HeaderArray(3) = "Total Stock Volume"
        
'Construct the headers
        For h = 0 To HeaderMax
            ws.Cells(1, ColIndex + h) = HeaderArray(h)
        Next h
        
            ColIndex = 15
            HeaderMax = 1
        
    Dim OtherArrayCol(1) As String
            OtherArrayCol(0) = "Ticker"
            OtherArrayCol(1) = "Value"
            
        For o = 0 To HeaderMax
            ws.Cells(1, ColIndex + o) = OtherArrayCol(o)
        Next o
        
            
    Dim OtherArrayRow(2) As String
            OtherArrayRow(0) = "Greatest % Increase"
            OtherArrayRow(1) = "Greatest % Decrease"
            OtherArrayRow(2) = "Greatest Total Volume"
            
            ColIndex = 14
            HeaderMax = 2
            
        For o2 = 0 To HeaderMax
            ws.Cells(o2 + 2, ColIndex) = OtherArrayRow(o2)
        Next o2
        
    ColIndex = 9
            
        
'Construct the headers
        For h = 0 To HeaderMax
            ws.Cells(1, ColIndex + h) = HeaderArray(h)
        Next h


' Variables for putting together ticker data
    Dim Tickers As String

'Variables for putting together Change data
    Dim StartVal As Double
    Dim EndVal As Double
    Dim YearChange As Double
    Dim PercentChange As Double
    
    'Column open/close values, columns C and F, respectively
    Dim ColOpen As Integer
        ColOpen = 3
    Dim ColClose As Integer
        ColClose = 6

    'Variables for gathering Volume data in Column G
    Dim TotalVol As Double
        TotalVol = 0
    Dim ColVol As Integer
        ColVol = 7
        
'Variables for generating max and min sub-table
    Dim MostIncrease As Double
        MostIncrease = 0
    Dim MostDecrease As Double
        MostDecrease = 0
    Dim MostVolume As Double
        MostVolume = 0
    Dim MaxTicker As String
    Dim MinTicker As String
    Dim VolTicker As String
    
    
        For i = 2 To LastSheetRow
            TotalVol = TotalVol + ws.Cells(i, ColVol).Value
            
            'This IF finds the initial instance of a ticker
            If ws.Cells(i, 1).Value <> ws.Cells(i - 1, 1).Value Then
                RowEvalIndex = RowEvalIndex + 1
                ' Gather Start Value for Year change, as this IF criteria identifies the first time the ticker appears
                StartVal = ws.Cells(i, ColOpen).Value
                
                'Populate the Tickers column
                ws.Cells(RowEvalIndex, ColIndex + 0) = ws.Cells(i, 1).Value
            End If
            
            'This IF finds the terminal instance of a ticker
            If ws.Cells(i, 1).Value <> ws.Cells(i + 1, 1).Value Then
                EndVal = ws.Cells(i, ColClose).Value
                YearChange = EndVal - StartVal
                PercentChange = (EndVal - StartVal) / (StartVal)
                ws.Cells(RowEvalIndex, ColIndex + 1) = YearChange
                ws.Cells(RowEvalIndex, ColIndex + 1).NumberFormat = "0.00"
                If YearChange > 0 Then
                    ws.Cells(RowEvalIndex, ColIndex + 1).Interior.ColorIndex = 4
                ElseIf YearChange <= 0 Then
                    ws.Cells(RowEvalIndex, ColIndex + 1).Interior.ColorIndex = 3
                End If
            
                ws.Cells(RowEvalIndex, ColIndex + 2) = PercentChange
                ws.Cells(RowEvalIndex, ColIndex + 2).NumberFormat = "0.00%"
                If PercentChange > 0 Then
                    ws.Cells(RowEvalIndex, ColIndex + 2).Interior.ColorIndex = 4
                ElseIf PercentChange <= 0 Then
                    ws.Cells(RowEvalIndex, ColIndex + 2).Interior.ColorIndex = 3
                End If
                
                ws.Cells(RowEvalIndex, ColIndex + 3) = TotalVol
                TotalVol = 0
            End If
                
            If PercentChange > MostIncrease Then
                MostIncrease = PercentChange
                MaxTicker = ws.Cells(i, 1).Value
            End If
            
            If PercentChange < MostDecrease Then
                MostDecrease = PercentChange
                MinTicker = ws.Cells(i, 1).Value
            End If
            
            If TotalVol > MostVolume Then
                MostVolume = TotalVol
                VolTicker = ws.Cells(i, 1).Value
            End If
                
                'Once the TotalVol data is exported to the sheet in the above, the following resets it for use
                
            
            
        Next i
        
        'MostIncrease
        ws.Cells(2, 15).Value = MaxTicker
        ws.Cells(2, 16).Value = MostIncrease
        ws.Cells(2, 16).NumberFormat = "0.00%"
        
        
        'MostDecrease
        ws.Cells(3, 15).Value = MinTicker
        ws.Cells(3, 16).Value = MostDecrease
        ws.Cells(3, 16).NumberFormat = "0.00%"
        
                
        'MostVolume
        ws.Cells(4, 15).Value = VolTicker
        ws.Cells(4, 16).Value = MostVolume
        ws.Cells(4, 16).NumberFormat = "##0.00E+0"
        
        Next ws
End Sub

