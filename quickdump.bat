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


set tableName=%local_database_prefix%_%yy%%mon%%dd%%hh%%min%

echo STEP 1 of 4 :dumping database to %tableName%.sql. Please Wait.
mysqldump -h %remote_host% -u %remote_user% -p"%remote_password%" %remote_database% > %tableName%.sql && (

      echo STEP 2 of 4 :create backup database.
      mysql -u %local_user% -e"CREATE DATABASE %tableName%"

      echo STEP 3 of 4 :backup tables to backup database.
      FOR /F %%G IN ('mysql -u %local_user% -e "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE table_schema='%local_database_prefix%'"') do if not "%%G"=="TABLE_NAME" mysql -u %local_user% -e "RENAME TABLE %local_database_prefix%.%%G to %tableName%.%%G"

	echo STEP 4 of 4 :dump new database
	mysql -u %local_user% %local_database_prefix% < %tableName%.sql

      echo DONE!

) || (
	echo Fail to dump remote database.
)