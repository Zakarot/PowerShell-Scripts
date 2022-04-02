$root = 'X:\TV-Shows\Library'

New-Alias -Name mediainfo -Value 'C:\users\zadmin\Downloads\MediaInfo_CLI_21.09_Windows_x64\MediaInfo.exe'
New-Alias -Name ffmpeg -Value 'C:\Users\Zadmin\Downloads\ffmpeg-4.4.1-full_build\bin\ffmpeg.exe'

Get-ChildItem -Path $root -Recurse | ForEach-Object {
    $fileName = $_.Name
    $folder = $_.Directory.FullName
    $fileType = $_.Extension

    if ( $fileType.ToString() -eq '.mp4' ) {
        $audioFormat = mediainfo --Inform="Audio;%Format%" $_.FullName
        if ( $audioFromat -eq 'E-AC-3' ) {
            Write-Host Converting E-AC-3 Audio to AC-3 for $_.FullName 
            cd $folder
            Write-Host -ForegroundColor Red 'INFO: Do the Conversion here'
            #ffmpeg -i $fileName -c:v copy -c:a ac3 -b:a 640k -v 8 $fileName'.mp4'
        }
    }
}

    if ( $fileType.ToString() -eq '.mkv' ){
        #Convert Container
    }