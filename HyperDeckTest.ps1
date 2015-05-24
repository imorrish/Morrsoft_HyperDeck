## HyperDeckTest.ps1
## By Ian Morrish
## Control HyperDesk via Ethernet
## Requires enabling PowerShell Script file execution.run the following command to allow only local scripts to be executed
##    set-executionpolicy remotesigned
#
#run with command line e.g.
#   PS > .\HyperDeckTest.ps1 -remoteHost "10.0.0.34" -commands @('remote: override: true', 'goto: clip id: 2','play: single clip: true')
#Or with no commands to get interactive menu mode
#
param( [string] $remoteHost = "10.0.0.34", [string[]] $commands = @('remote: override: true'))
$port = 9993
$TempLogFilePath = "c:\temp\HyperDeck.log"
function WriteCommand($strCommand){

		## Write single command to the HyperDeck
        write-host $strCommand
		$writer.WriteLine($strCommand) 
        $writer.Flush()
        Start-Sleep -m 500
        while($stream.DataAvailable) {
			$read = $stream.Read($buffer, 0, 1024)
			write-host -n ($encoding.GetString($buffer, 0, $read))
		}
}

Start-Transcript -Path "$TempLogFilePath"


	write-host "Connecting to $remoteHost on port $port"
	$socket = new-object System.Net.Sockets.TcpClient($remoteHost, $port)

	if($socket -eq $null) {
		Exit
	    }

	$stream = $socket.GetStream() 
    $writer = new-object System.IO.StreamWriter($stream)

	$buffer = new-object System.Byte[] 1024
	$encoding = new-object System.Text.AsciiEncoding

	#Loop through $commands and execute one at a time.

	for($i=0; $i -lt $commands.Count; $i++) { ## Allow data to buffer for a bit start-sleep -m 500

		## Read all the data available from the stream, writing it to the ## screen when done.
		while($stream.DataAvailable) {
			$read = $stream.Read($buffer, 0, 1024)
			write-host -n ($encoding.GetString($buffer, 0, $read))
		}

		write-host $commands[$i]
		## Write the command to the remote host
		$writer.WriteLine($commands[$i]) 
        $writer.Flush()
        Start-Sleep -m 500
	}


if ($commands.Count -eq 1){
    ## run in interactive mode
do {$strResponse = Read-Host “Enter ? - help, di - device Info, ci - clip info, p - play, s - stop, 1-6 clip, Q when you want to quit application?”

    switch ($strResponse)
    {
            "?" {WriteCommand('help')}
            "c" {WriteCommand('configuration')}
            "ci" {WriteCommand('clips get')}
            "di" {WriteCommand('device info')}
            "s" {WriteCommand('stop')}
            "p" {WriteCommand('play')}
            "r" {WriteCommand('record')}
            "1" {WriteCommand('goto: clip id:1')}
            "2" {WriteCommand('goto: clip id:2')}
            "3" {WriteCommand('goto: clip id:3')}
            "4" {WriteCommand('goto: clip id:4')}
            "5" {WriteCommand('goto: clip id:5')}
            "6" {WriteCommand('goto: clip id:6')}
            "7" {WriteCommand('goto: clip id:7')}
            "8" {WriteCommand('goto: clip id:8')}
            "9" {WriteCommand('goto: clip id:9')}
            "10" {WriteCommand('goto: clip id:10')}


    }
    }
until ($strResponse -eq “Q”) 
}
	## Close the streams
	## Cleans everything up.

    write-host "exit"
    $writer.Flush()
     #   start-sleep -m 500
    while($stream.DataAvailable) {
			$read = $stream.Read($buffer, 0, 1024)
			write-host -n ($encoding.GetString($buffer, 0, $read))
		}
	$writer.Close()
	$stream.Close()


	stop-transcript



