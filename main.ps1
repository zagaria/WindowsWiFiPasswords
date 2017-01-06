$networks = netsh wlan show profile #Get all saved wifi networks

$passwords = @{}

$networksLength = $networks.Length;
 
for($i=1; $i -le $networksLength; $i++)
{
    $match = $networks[$i] -match ':\s([\w\d\s\-]+)'

    $percent = [int](100/$networksLength)*$i
    
    #Simple progress bar
    Write-Progress -Activity "WiFi Networks: " -Status "Complete:$percent%" -PercentComplete $percent;

    if ($match -eq $true)
    {
        $networkName = $Matches[1]

        $network = netsh wlan show profile $networkName key=clear

        $networkMatch = [string]$network -match 'Authentication\s+\:\s(Open)'

        if ($networkMatch -eq $true)
        {
            #If WiFi network type Open
            $passwords[$networkName] = 'None'
        }
        else
        {

            $passwordMatch = [string]$network -match 'Key Content\s+\:\s([\w\d\$\%\^\&\*\(\)]{8,64})'
            if ($passwordMatch -eq $true)
            {
                $passwords[$networkName] = $Matches[1]
            }
        }

    }
}

$passwords

$saveResult = Read-Host -Prompt 'Save results to file wifi.txt? (yes/no)'

if($saveResult -eq "yes")
{
  $passwords |  out-string | Set-Content wifi.txt
}
