

if "%1" == "" (
  call :BuildInstaller x86
  call :BuildInstaller x64
  call :BuildInstaller x64NonAdmin
  call :BuildInstaller ARM64
) else if "%1" == "x64" (
  call :BuildInstaller x64
  call :BuildInstaller x64NonAdmin
) else if "%1" == "x86" (
  call :BuildInstaller x86
) else if "%1" == "ARM64" (
  call :BuildInstaller ARM64
) else if "%1" == "ARM" (
  echo platform %1 is not supported
) else (
  call :BuildInstaller %1
)
goto :eof

:BuildInstaller
set PLATFORM=%1

for %%i in ("%LOCALAPPDATA%\Programs" "%ProgramFiles(x86)%" "%ProgramFiles%") do (
  if exist "%%~i\Inno Setup 6\iscc.exe" (
    if exist "Installer\innosetup\WinMerge%PLATFORM%.is6.iss" (
      "%%~i\Inno Setup 6\iscc.exe" /DTranslationsDir=..\..\Build\Translations "Installer\innosetup\WinMerge%PLATFORM%.is6.iss" || pause
      goto :eof
    )
  )
  if exist "%%~i\Inno Setup 5\iscc.exe" (
    if exist "Installer\innosetup\WinMerge%PLATFORM%.iss" (
      "%%~i\Inno Setup 5\iscc.exe" /DTranslationsDir=..\..\Build\Translations "Installer\innosetup\WinMerge%PLATFORM%.iss" || pause
      goto :eof
    )
  )
)

goto :eof
