#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <File.au3>
CONST $DirFolder = "C:\Fraps"
getExecFile();

Func getExecFile()
   Local $listFile = _FileListToArray($DirFolder, "*.exe", 1)
   If @error = 1 Then
        MsgBox($MB_ICONERROR, "Error", "Path was invalid.")
        Return False
    EndIf
    If @error = 4 Then
        MsgBox($MB_ICONERROR, "Error", "No file(s) were found.")
        return False
	 EndIf
	 MsgBox('','',$listFile[1])
    _ArrayDisplay($listFile)
EndFunc