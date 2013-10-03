@echo off
call ..\_global\ModListGenerator\variables.bat

SET /P ANSWER=Do you want to continue uninstall (Y/N)?
echo You chose: %ANSWER%
if /i {%ANSWER%}=={y} (goto :yes)
if /i {%ANSWER%}=={yes} (goto :yes)
goto :no

:yes
%app_xml% sel -t -v "/list" %path_mod_list% > %path_tmp_file%
%app_generator% repair %path_tmp_file%
%app_xml% ed -d "/root/mod[@name='%modName%']" %path_tmp_file% > %path_tmp2_file% 
%app_generator% generate %path_tmp2_file% %path_mod_list%
REM Erase "../%modName%"
rd /s/q "../%modName%"
Rmdir "../%modName%"
Del %path_tmp_file%
Del %path_tmp2_file%

:no
pause