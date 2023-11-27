# Load necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


# # DISPLAY5 AOC
# # DISPLAY9 TOP
# # DISPLAY1 LAPTOP
# # DISPLAY6 DELL



$layout_profiles = @(
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
$form.Size = New-Object System.Drawing.Size(750,200)
$form.StartPosition = 'CenterScreen'

For ($p=0; $p -lt $layout_profiles.Length; $p++)
{
    $row = 10

    $col = 10 + ($p * ($profileBtnWidth + $betweenBtnfGap + $saveBtnWidth + $betweenProfGap))
    $actionBtn = $layout_profiles[$p][0]
    $saveBtn = $layout_profiles[$p][1]

    $save_col = $col + $profileBtnWidth + $betweenBtnfGap
    MakeButton $form $row $col      $profileBtnWidth $profileBtnHeight  $actionBtn.Name $actionBtn.Command
    MakeButton $form $row $save_col $saveBtnWidth    $saveBtnHeight     $saveBtn.Name   $saveBtn.Command
}

# Dell 27 USB-C
# Dell 15 DP-1
# Dell 19 DP-2
# Dell 17 HDMI-1
# Dell 18 HDMI-2


$monitor_change = @(
    @(
        [PSCustomObject]@{
            Name     = 'Dell XPS'
            Command = {
                    Start-Process controlmymonitor\ControlMyMonitor.exe  -ArgumentList '/SetValue "DEL41D6" 60 17'
                }
        },
        [PSCustomObject]@{
            Name     = 'Dell Lenovo'
            Command = {
                    Start-Process controlmymonitor\ControlMyMonitor.exe  -ArgumentList '/SetValue "DEL41D6" 60 27'
                }
        },
        [PSCustomObject]@{
            Name     = 'Dell Linux'
            Command = {
                    Start-Process controlmymonitor\ControlMyMonitor.exe  -ArgumentList '/SetValue "DEL41D6" 60 15'
                }
        }

    ),
    @(
        [PSCustomObject]@{
            Name     = 'AOC XPS'
            Command = {
                    Start-Process controlmymonitor\ControlMyMonitor.exe  -ArgumentList '/SetValue "AOC3202" 60 15'
                }
        },
        [PSCustomObject]@{
            Name     = 'AOC Lenovo'
            Command = {
                    Start-Process controlmymonitor\ControlMyMonitor.exe  -ArgumentList '/SetValue "AOC3202" 60 17'
                }
        }
    )
)


For ($mon=0; $mon -lt $monitor_change.Length; $mon++)
{
    $row = 60 + ($mon * 40)

    $monitor = $monitor_change[$mon]
    Write-Host "$monitor"

    For ($btn=0; $btn -lt $monitor.Length; $btn++)
    {
        $col = 10 + ($btn * ($profileBtnWidth + $betweenBtnfGap))
        $actionBtn = $monitor[$btn]

        Write-Host "$actionBtn"

        MakeButton $form $row $col      $profileBtnWidth $profileBtnHeight  $actionBtn.Name $actionBtn.Command

        Write-Host "$actionBtn.Name $actionBtn.Command"
    }
}


# Show the form
$form.ShowDialog()
