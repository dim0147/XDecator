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

Const $DirFolder = "C:\Fraps"
Const $UrlModSkin = "http://modskinpro.com/p/tai-mod-skin-lol-pro-2016-chn"


Func updateModSkin()
	Local $getExecFile = getExecFile()

; Check if dir not exist or not found exec file
If ($getExecFile == False) Then
	; File exec not found or don't have dir
	DirRemove($DirFolder)
	Local $linkDownload = getLinkDownload()
Else

EndIf
EndFunc

Func getLinkDownload()
	Local $regex = '<a id="link_download3" href="(.*?)">'
	Local $htmlBody = _HttpRequest(2, $UrlModSkin)

	If ($htmlBody == '') Then
		MsgBox(16, 'Error', 'Cannot get data from website.')
		Return False
	EndIf

	; Regexp get link download
	Local $aArray = StringRegExp($htmlBody, $regex, $STR_REGEXPARRAYMATCH)
	; If not found
	If($aArray[0] == '') Then
		MsgBox(16, "Error", "Cannot find download link.")
		Return False
	EndIf

	Local $linkDownload = $aArray[0]
	return $linkDownload

EndFunc   ;==>getLinkDownload


Func getExecFile()
	Local $listFile = _FileListToArray($DirFolder, "*.exe", 1)
	If @error = 1 Then
		Return False
	EndIf
	If @error = 4 Then
		Return False
	EndIf
	#Check if array not contain exec file
	If ($listFile[1] == '') Then
		Return False ;
	EndIf
	Return $listFile[1]
EndFunc   ;==>getExecFile
