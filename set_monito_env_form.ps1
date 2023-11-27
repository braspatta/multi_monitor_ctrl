# Load necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


# # DISPLAY5 AOC
# # DISPLAY9 TOP
# # DISPLAY1 LAPTOP
# # DISPLAY6 DELL



$profiles = @(
    @(
        [PSCustomObject]@{
            Name     = 'All'
            Command = {
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/LoadConfig config\All.cfg"
                }
        },
        [PSCustomObject]@{
            Name     = 'S'
            Command = {
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/SaveConfig config\All.cfg"
                }
        }
    ),
    @(
        [PSCustomObject]@{
            Name     = 'Laptop'
            Command = {
                    # Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/LoadConfig config\Laptop.cfg"
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/disable \\.\DISPLAY5"
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/disable \\.\DISPLAY9"
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/disable \\.\DISPLAY6"
                }
        },
        [PSCustomObject]@{
            Name     = 'S'
            Command = {
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/SaveConfig Laptop.cfg"
                }
        }
    ),
    @(
        [PSCustomObject]@{
            Name     = 'Laptop Top'
            Command = {
                    # Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/LoadConfig config\LaptopTop.cfg"
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/disable \\.\DISPLAY5"
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/enable \\.\DISPLAY9"
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/disable \\.\DISPLAY6"
                }
        },
        [PSCustomObject]@{
            Name     = 'S'
            Command = {
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/SaveConfig config\LaptopTop.cfg"
                }
        }
    ),
    @(
        [PSCustomObject]@{
            Name     = 'Laptop Dell'
            Command = {
                    # Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/LoadConfig config\LaptopDell.cfg"
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/enable \\.\DISPLAY6"
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/disable \\.\DISPLAY5"
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/disable \\.\DISPLAY9"

                }
        },
        [PSCustomObject]@{
            Name     = 'S'
            Command = {
                    Start-Process multimonitortool-x64\MultiMonitorTool.exe -ArgumentList "/SaveConfig config\LaptopDell.cfg"
                }
        }
    )
)


function MakeButton($form,$row, $col, $width, $height, $text, $command) {
    $button = New-Object System.Windows.Forms.Button
    $button.Location = New-Object System.Drawing.Point($col,$row)
    $button.Size = New-Object System.Drawing.Size($width, $height)
    $button.Text = $text
    $button.Add_Click($command)
    $form.Controls.Add($button)
}

$profileBtnWidth = 100
$profileBtnHeight = 30
$saveBtnWidth = 30
$saveBtnHeight = 30
$betweenProfGap = 30
$betweenBtnfGap = 10

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Monitor env selection'
$form.Size = New-Object System.Drawing.Size(750,100)
$form.StartPosition = 'CenterScreen'

For ($p=0; $p -lt $profiles.Length; $p++)
{
    $row = 10

    $col = 10 + ($p * ($profileBtnWidth + $betweenBtnfGap + $saveBtnWidth + $betweenProfGap))
    $actionBtn = $profiles[$p][0]
    $saveBtn = $profiles[$p][1]

    $save_col = $col + $profileBtnWidth + $betweenBtnfGap
    MakeButton $form $row $col      $profileBtnWidth $profileBtnHeight  $actionBtn.Name $actionBtn.Command
    MakeButton $form $row $save_col $saveBtnWidth    $saveBtnHeight     $saveBtn.Name   $saveBtn.Command
}

# # Show the form
$form.ShowDialog()
