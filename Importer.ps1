function ShowDialogBox {
    [CmdletBinding()]
    param (
        [Parameter()]
        [TypeName]$ParameterName
    )
}

Function Do-Grid{

    for($i=0;$i -lt $datagridview1.RowCount;$i++){ 

       if($datagridview1.Rows[$i].Cells['exp'].Value -eq $true)
       {
         write-host "cell #$i is checked"
         #uncheck it
         #$datagridview1.Rows[$i].Cells['exp'].Value=$false
       }
       else    
       {
         #check it
         #$datagridview1.Rows[$i].Cells['exp'].Value=$true
         write-host  "cell #$i is not-checked"
       }
    }
}

Add-Type -Assembly System.Windows.Forms
$App = New-Object system.Windows.Forms.Form
$App.Text = "CIS Benchmarks Importer for Microsoft Intune"
$App.TopMost = $true
$App.Width = 900
$App.Height = 600
$App.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$App.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$App.Icon = ".\icon.ico"
$App.MaximizeBox = $false


$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "CIS Benchmarks"
$titleLabel.Font = "Segoe UI,12"
$titleLabel.Location  = New-Object System.Drawing.Point(23,35)
$titleLabel.AutoSize = $true
$App.Controls.Add($titleLabel)

$DataGrid = New-Object System.Windows.Forms.DataGridView
$DataGrid.Location = New-Object System.Drawing.Size(25,65)
$DataGrid.Size = New-Object System.Drawing.Size(825,250)
$DataGrid.AllowUserToAddRows = $false
$DataGrid.AllowUserToDeleteRows = $false
$DataGrid.AlternatingRowsDefaultCellStyle.BackColor = "LightGray"
$DataGrid.DefaultCellStyle.Font = "Segoe UI,9"
$DataGrid.DefaultCellStyle.Padding = New-Object System.Windows.Forms.Padding(3,3,3,3)
$DataGrid.DefaultCellStyle.ForeColor = "DarkBlue"
$DataGrid.AutoSizeRowsMode = [System.Windows.Forms.DataGridViewAutoSizeRowsMode]::AllCells
$DataGrid.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::AllCells
$DataGrid.AllowUserToAddRows = $false
$DataGrid.AllowUserToDeleteRows = $false
$DataGrid.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect


$datatable = New-Object System.Data.DataTable
$datatable.Columns.Add('Selected', [bool])
$datatable.Columns.Add('Name', [string])
$datatable.Columns.Add('Path', [string])
$datatable.Columns.Add('Platform', [string])

$DataGrid.DataSource = $datatable
$App.Controls.Add($DataGrid)

$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Size = New-Object System.Drawing.Size(825,150)
$TextBox.Location = New-Object System.Drawing.Size(25,325)
$TextBox.Multiline = $true
$TextBox.Font = "Segoe UI,10"
$TextBox.ReadOnly = $true
$TextBox.Padding = New-Object System.Windows.Forms.Padding(5,5,5,5)
$App.Controls.Add($TextBox)


$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Location = New-Object System.Drawing.Size(725,500)
$exitButton.Size = New-Object System.Drawing.Size(120,23)
$exitButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$exitButton.FlatAppearance.BorderSize = 1
$exitButton.FlatAppearance.BorderColor = "Gray"
$exitButton.Text = "Exit"
$App.Controls.Add($exitButton)

$importButton = New-Object System.Windows.Forms.Button
$importButton.Location = New-Object System.Drawing.Size(600,500)
$importButton.Size = New-Object System.Drawing.Size(120,23)
$importButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$importButton.FlatAppearance.BorderSize = 1
$importButton.FlatAppearance.BorderColor = "Gray"
$importButton.Text = "Import"
$App.Controls.Add($importButton)

$App.Add_Load({
    Get-ChildItem -Path ".\policies" -Filter "*.json" | ForEach-Object {
        $policy = Get-Content -Path $_.FullName | ConvertFrom-Json
        $datatable.Rows.Add($false,$policy.Name,$_.FullName,$policy.Platforms)
    }

    $TextBox.Text = "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - Script initialized successfully"
    $TextBox.Lines += "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - Policies imported from "+ $PSScriptRoot +"\policies"
})

$exitButton.Add_Click({ $App.Close() })

$App.ShowDialog()