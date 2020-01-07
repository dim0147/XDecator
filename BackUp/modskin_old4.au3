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

updateModSkin()

Func updateModSkin()
	; Check if dir not exist or not found exec file
	Local $getExecFile = getExecFile()

	; File exec not found or don't have dir, remove all dir and sub-dir then create new dir
	If ($getExecFile == False) Then
		DirRemove($DirFolder, $DIR_REMOVE)
		DirCreate($DirFolder)
	EndIf

	; Check if not create
	If FileExists($DirFolder) == 0 Then
		MsgBox(16, "Error", "Cannot create folder.")
	EndIf

		Local $linkDownload = getLinkDownload()
	; If error while get link download
		If($linkDownload == False) Then
			Return False
		EndIf
EndFunc   ;==>updateModSkin

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
	If ($aArray[0] == '') Then
		MsgBox(16, "Error", "Cannot find download link.")
		Return False
	EndIf

	Local $linkDownload = $aArray[0]
	Return $linkDownload

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

Func downloadModSkin($linkDownload)
	Local $fileDownload = $DirFolder + "\modskin.rar"
	 ; Download the file in the background with the selected option of 'force a reload from the remote site.'
	InetGet($linkDownload, $fileDownload, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
	While @InetGetActive
  TrayTip("Downloading", "Bytes = " & @InetGetBytesRead, 10, 16)
  Sleep(250)
Wend

MsgBox(0, "Bytes read", @InetGetBytesRead)
EndFunc