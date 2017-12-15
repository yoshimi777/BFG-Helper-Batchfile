@echo off
set home=%~dp0
cd ../
set oneup=%cd%
pushd %oneup%
set bfg=java -jar %home%bfg.jar 
set bfgopts=
set /p user=GitHub UserName: 
echo %user%
set /p repo=Repo name: 
echo %repo%
rmdir preclean%repo%.git
git clone --mirror https://github.com/%user%/%repo%.git preclean%repo%.git
set folders=
set files=
set bfgopts1=
set bfgopts2=
set bfgopts3=
:opts
cd %oneup%
CHOICE /C 123Q /M "1-Remove file 2-Remove folder 3-Replace text Q-uit" 
echo %errorlevel%
if errorlevel 4 goto quit
if errorlevel 3 goto words
if errorlevel 2 goto folder
if errorlevel 1 goto remfile

:remfile
set /p filepath=Enter path to file: 
for %%A in (%repo%\%filepath%) do (
    set file=%%~nxA
    set dp=%%~fA
)
call set folder=%%dp:\%file%=%%
cd %repo%
echo %filepath% >> .gitignore
git rm --cached %filepath% 
git add .gitignore
set "files=%files%%file%,"
set bfgopts1=--delete-files "{%files%}"
cd %oneup%
choice /m "Is there more"
if errorlevel 2 goto commit
if errorlevel 1 goto opts

:folder
set /p filepath=Enter path to folder: 
for %%A in (%repo%\%filepath%) do (
    set file=%%~nxA
    set dp=%%~fA
    set direct=%%~nA
)
call set folder=%%dp:\%file%=%%
set _folder=%filepath%/    
echo %_folder%
pause
cd %repo%
echo %_folder% >> .gitignore
git rm --cached %_folder% -r
git add .gitignore
cd %oneup%
set "folders=%folders%%direct%,"
set bfgopts2=--delete-folders "{%folders%}"
choice /m "Is there more"
if errorlevel 2 goto commit
if errorlevel 1 goto opts


:words
pushd %oneup%
set /p filepath=Enter path to file with words to replace: 
for %%A in (%repo%\%filepath%) do (
    set file=%%~nxA
    set dp=%%~fA
)
call set folder=%%dp:\%file%=%%
echo %folder%
set /p words=Word to find (word;replacement): 
set repl=%words:*;=%
call set word=%%words:;%repl%=%%
echo %word%
echo %repl%
::rm rep.txt
echo create %home%rep.txt
set sep="==>"
echo %word%%sep%%repl%>>%home%rep.txt
sed -i 's/\"//g' %home%rep.txt
echo "check rep.txt"
pause 
cd %folder%
sed -i 's;%word%;%repl%;g' %file%
echo "check %file%"
pause 
git add %file%
set bfgopts3=-rt rep.txt
popd
cd %repo%
echo %filepath% >> .gitignore
git add .gitignore
cd %oneup%
choice /m "Is there more"
if errorlevel 2 goto commit
if errorlevel 1 goto opts

:commit
cd %repo%
echo %cd%
git commit 
set bfgopts=%bfgopts1% %bfgopts2% %bfgopts3%
choice /m "current options: %bfgopts% edit them"
if errorlevel 2 goto conf
if errorlevel 1 goto edit
:edit
set /p bfgopts=Fix the options: 
:conf
choice /c YSQ /m "Ready to Push? Y-es, S-kip no remote changes, Q-uit"
if errorlevel 3 goto quit
if errorlevel 2 goto bfg
if errorlevel 1 goto push

:push
git push -f --all

:bfg
cd %oneup%
pushd %cd%
rmdir %repo%.git /s/q
git clone --mirror https://github.com/%user%/%repo%.git
mkdir BACKUP%repo%.git
robocopy %repo%.git BACKUP%repo%.git /E 
%BFG% %bfgopts% %repo%.git | grep -v "You can\|make people\|give up"

cd %repo%.git 
choice /m "Prune empty commits now" /d n /t 5
if errorlevel 2 goto reflogcleanup
if errorlevel 1 goto prunetoo

:prunetoo
git reflog expire --expire=now --all && git gc --prune=now --aggressive && git filter-branch --prune-empty -f
goto end

:reflogcleanup
git reflog expire --expire=now --all && git gc --prune=now --aggressive

:end
git push
cd %oneup%
cd %repo%
git pull --rebase -f
cd %home%
:quit
pause