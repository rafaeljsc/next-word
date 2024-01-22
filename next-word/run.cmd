powershell -c "$source = (pwd).path; unblock-file $source\* -confirm:$false"
powershell -executionpolicy bypass -file "%~dp0files\run.ps1"
pause