@echo off
for /f "delims=\" %%a in ("%cd%") do set modName=%%~nxa
set app_xml=..\_global\ModListGenerator\xml.exe
set app_generator=..\_global\ModListGenerator\ModListGenerator.exe
set path_mod_list=..\mod-list.xml
set path_tmp_file=..\_global\ModListGenerator\tmp.xml
set path_tmp2_file=..\_global\ModListGenerator\tmp2.xml