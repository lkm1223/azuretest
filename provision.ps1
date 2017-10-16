# change the value as you need
# be noted that '\\' is used instead of '\'
@"
$log = "C:\" + (Get-Date -f 'yyyymmdd-hhmmss') + ".log"; 
Get-Date > $log; 
"@ | Set-Content 'c:\\startup.ps1' -Encoding Unicode;

$path2script = "c:\\startup.ps1";

Start-Process -FilePath "gpedit.msc"


# register the starup script in registry
@"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup]

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup\0]
"GPO-ID"="LocalGPO"
"SOM-ID"="Local"
"FileSysPath"="C:\\Windows\\System32\\GroupPolicy\\Machine"
"DisplayName"="Local Group Policy"
"GPOName"="Local Group Policy"
"PSScriptOrder"=dword:00000002

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup\0\0]
"Script"="$path2script"
"Parameters"=""
"ExecTime"=hex(b):00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
"ErrorCode"=dword:00000000
"@ > register-startup.reg;
reg import register-startup.reg >$null 2>&1;
rm register-startup.reg -force;

# GPT.ini
@"
[General]
gPCMachineExtensionNames=[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]
Version=20
"@ | Set-Content 'C:\windows\System32\GroupPolicy\gpt.ini' -Encoding Unicode;

# psscripts.ini
$path2script = $path2script.Replace('\\', '\');
@"
[ScriptsConfig]
StartExecutePSFirst=true
[Startup]
0CmdLine=$path2script
0Parameters=
"@ | Set-Content 'C:\Windows\System32\GroupPolicy\Machine\Scripts\psscripts.ini' -Encoding Unicode;


