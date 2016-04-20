set currentDir=%~dp0
schtasks /Create /SC "WEEKLY" /D "MON,TUE,WED,THU,FRI" /TN "ci_gazik" /TR "%currentDir%..\Sync.sh %currentDir%..\\" /ST "09:00" /DU "13:00" /RI 15