#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <File.au3>
#include <_HttpRequest.au3>
#include <StringConstants.au3>

CONST $DirFolder = "C:\Fraps"
CONST $UrlModSkin = "http://modskinpro.com/p/tai-mod-skin-lol-pro-2016-chn"


Local $getExecFile = getExecFile()
getLinkDownload()



; Check if dir not exist or not found exec file

If($getExecFile == False) Then

Else

EndIf

Func getLinkDownload()
	Local $regex = "(?m)<a id=\"link_download3\" href=\"(.*?)\">"
	Local $htmlBody = _HttpRequest(2, $urlModSkin)

	If($htmlBody == '') Then
		MsgBox(16, 'Error', 'Cannot get data from website.')
		Return False
	EndIf

	MsgBox('','',$htmlBody)
	Local $aArray = StringRegExp($sString, $sRegex, $STR_REGEXPARRAYGLOBALFULLMATCH)
Local $aFullArray[0]
For $i = 0 To UBound($aArray) -1
    _ArrayConcatenate($aFullArray, $aArray[$i])
Next
$aArray = $aFullArray

; Present the entire match result
_ArrayDisplay($aArray, "Result")

EndFunc


Func getExecFile()
	Local $listFile = _FileListToArray($DirFolder, "*.exe", 1)
	If @error = 1 Then
		Return False
	EndIf
	If @error = 4 Then
		Return False
	EndIf
	#Check if array not contain exec file
	If($listFile[1] == '') Then
		Return False;
	EndIf
	Return $listFile[1]
EndFunc   ;==>getExecFile
