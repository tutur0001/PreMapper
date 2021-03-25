<# : premap.bat

@REM This tool was developped for the version 1.3 of ArchivITMapper by Arthur Michon and Adam Bentounes.
@REM Distrubued with an MIT Licence

@echo off
setlocal
setlocal EnableDelayedExpansion
set $string=;;
set $replace=; ;

if exist %tmp%\Output (rmdir /s /q %tmp%\Output)


for /f "delims=" %%I in ('powershell -noprofile "iex (${%~f0} | out-string)"') do (
    mkdir %tmp%\Output
    copy "%%~I" %tmp%\Output\csvCopy.txt
)

for /f "delims=" %%a in ('type %tmp%\Output\csvCopy.txt') do (
    set $ligne=%%a
    set $ligne=!$ligne:%$string%=%$replace%!
    echo !$ligne!>>%tmp%\Output\csvCopy1.txt)

for /f "tokens=3,* delims=;" %%a in (%tmp%\Output\csvCopy1.txt) do ( echo ;%%b >> %tmp%\Output\debug.txt )
find /N ";" %tmp%\Output\debug.txt > %tmp%\Output\addLine.txt
findstr "\/ \? \: \* \" \" \\ ' > < " %tmp%\Output\addLine.txt > %tmp%\Output\finalDebug.csv


start "" %tmp%\Output\finalDebug.csv

@REM Press any key to clear.
echo Appuyez sur une touche pour terminer.
pause > nul

rmdir /s /q %tmp%\Output

goto :EOF

: end Batch portion / begin PowerShell hybrid chimera #>

Add-Type -AssemblyName System.Windows.Forms
$f = new-object Windows.Forms.OpenFileDialog
$f.InitialDirectory = pwd   
$f.Filter = "CSV Files (*.csv)|*.csv|All Files (*.*)|*.*"
$f.ShowHelp = $true
$f.Multiselect = $false
[void]$f.ShowDialog()
if ($f.Multiselect) { $f.FileNames } else { $f.FileName }
