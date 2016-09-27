@echo off

call config.cmd
 :: get date

 for /F "tokens=2-4 delims=/ " %%i in ('date /t') do (
      set mon=%%i
      set dd=%%j
      set yy=%%k
 )

 :: get time
 for /F "tokens=5-8 delims=:. " %%i in ('echo.^| time ^| find "current" ') do (
      set hh=%%i
      set min=%%j
 )


 set name=snapshort_%yy%%mon%%dd%%hh%%min%

echo taking snapshort to %name%.sql
mysqldump -u %local_user% %local_database_prefix% > %name%.sql
echo DONE !
