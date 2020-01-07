#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#RequireAdmin
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
	If ($linkDownload == False) Then
		Return False
	EndIf

	; Download Modskin
	downloadModSkin($linkDownload)
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
	Local $fileDownload = $DirFolder & "\modskin.rar"
	; Download the file in the background with the selected option of 'force a reload from the remote site.'
	 Local $hDownload = InetGet($linkDownload, $fileDownload, 1, 1)
	  Do
        Sleep(250)
		; Get status downloading
		Local $byteDownload = FormatFileSize(InetGetInfo($hDownload, 0));
		Local $byteTotal = FormatFileSize(InetGetInfo($hDownload, 1));
		Local $onError = InetGetInfo($hDownload, 4);
		; If error occur
		If($onError <> 0) Then
			MsgBox(16, "Error", "Error while downloading.")
			Return False
	  EndIf
	  ; Show current status
		TrayTip("Downloading...", "Downloading " & $byteDownload & "/" & $byteTotal, 10)
Until InetGetInfo($hDownload, 2)
; If file download not exist or don't have kB
	If(FileExists($fileDownload) == 0 Or FileGetSize($fileDownload) == 0) Then
		MsgBox(16, "Error", "File is corrupt.")
		Return False
	EndIf
EndFunc   ;==>downloadModSkin




Func FormatFileSize($iSizeInBytes)

  Local $iSize, $i

  $iSize = $iSizeInBytes
  $i = 0
  While $iSize >= 1024 ;split value, you can set lower number like 900 for earlier switch (0.98 MB)
    $iSize /= 1024 ;this must be always 1024
    $i += 1
  WEnd

  $iSize = Round($iSize, 1) & " "; enter how many decimals you want, here it's '1'

  Switch $i
    Case 1
      $iSize = $iSize & "k"
    Case 2
      $iSize = $iSize & "M"
    Case 3
      $iSize = $iSize & "G"
    Case 4
      $iSize = $iSize & "T"
  EndSwitch

  Return $iSize & "B"

EndFunc
