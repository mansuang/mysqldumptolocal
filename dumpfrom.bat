@echo off

call config.cmd
 :: get date

if exist %1 (
   mysql -f -u %local_user% %local_database_prefix% < %1
) else (
   echo file does not exist !!!
)
