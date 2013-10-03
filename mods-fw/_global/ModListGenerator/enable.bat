@echo off
call ..\_global\ModListGenerator\variables.bat

%app_xml% sel -t -v "/list" %path_mod_list% > %path_tmp_file%
%app_generator% repair %path_tmp_file%
%app_xml% ed -d "/root/mod[@name='%modName%']" -s "/root" -t elem -n mod -v "" -a "/root/mod[last()]" -t attr -n name -v "%modName%" -a "/root/mod[last()]" -t attr -n enable -v true %path_tmp_file% > %path_tmp2_file% 
%app_generator% generate %path_tmp2_file% %path_mod_list%
Del %path_tmp_file%
Del %path_tmp2_file%