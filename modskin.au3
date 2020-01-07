#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include <File.au3>
#include <_HttpRequest.au3>
#include <StringConstants.au3>
#include <AutoItConstants.au3>
Opt("TrayMenuMode", 1)
TraySetState(4)

Const $DirFolder = "C:\XDecator"
Const $UrlModSkin = "http://modskinpro.com/p/tai-mod-skin-lol-pro-2016-chn"
Const $extractCommand = $DirFolder & "\WinRAR.exe x " & $DirFolder & "\modskin.rar *.* " & $DirFolder &"\"

#Region ### START Koda GUI section ### Form=E:\Project\ModSkin\Form1.kxf
$Form = GUICreate("XDecator", 367, 137, 232, 139)
$Title = GUICtrlCreateLabel("XDecator", 128, 8, 106, 35)
GUICtrlSetFont(-1, 18, 400, 2, "Yu Gothic")
$UpdateBut = GUICtrlCreateButton("Update", 72, 64, 75, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS UI Gothic")
$OpenBut = GUICtrlCreateButton("Open Mod ", 208, 64, 75, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS UI Gothic")
$CopyRightLabel = GUICtrlCreateLabel("Copyright © By AlLieng", 104, 104, 171, 21)
GUICtrlSetFont(-1, 10, 800, 2, "MV Boli")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $UpdateBut
			updateModSkin()
		Case $OpenBut
			Local $openModSkin = runModSkin()
			If($openModSkin <> False) Then
				MsgBox(64, "Success", "Open Mod Skin success.")
			EndIf

	EndSwitch
WEnd


Func runModSkin()
	; Get exec File
	$getExecFile = getExecFile()

	; Check if not found
	If ($getExecFile == False) Then
		MsgBox(16, "Error", "Cannot find exec file.")
		Return False
	EndIf

	; Exec file exist, execute
	Local $pathExec = $DirFolder & '\' & $getExecFile
	Run(@ComSpec & " /c " & 'start "" "' & $pathExec & '" -wo "' & $DirFolder & '"', "", @SW_HIDE)
	Return True

EndFunc   ;==>runModSkin

Func updateModSkin()
	TrayTip("Update Mod Skin", "Update Mod Skin is starting.", 0, 1)

	; Check if dir not exist or not found exec file
	Local $getExecFile = getExecFile()

	; Clear Dir
	DirRemove($DirFolder, $DIR_REMOVE)
	DirCreate($DirFolder)

	; Check if not create
	If FileExists($DirFolder) == 0 Then
		MsgBox(16, "Error", "Cannot create folder.")
	EndIf

	; Install necessary software
	FileInstall("E:\Project\ModSkin\WinRAR.exe", $DirFolder & '\WinRAR.exe', 1)

	Local $linkDownload = getLinkDownload()
	; If error while get link download
	If ($linkDownload == False) Then
		Return False
	EndIf

	; Download Modskin
	Local $status = downloadModSkin($linkDownload)

	If ($status == False) Then
		Return False
	EndIf

	; Extract Download File
	Run($extractCommand)
	TrayTip("Extract", "Extracting File...", 0, 1)

	; Wait for extract finish, if over 5 second but still don't have, exit
	Local $startTime = TimerInit()
	Local $timeWaiting = 5000

	; Get exec File
	$getExecFile = getExecFile()

	; Check if file exec don't have
	While $getExecFile == False
		; Get exec file again
		$getExecFile = getExecFile()

		; Check if over than 5 second but still dont have exec file, breakout
		Local $timeDiff = TimerDiff($startTime)
		If (Round($timeDiff) > $timeWaiting) Then
			TrayTip("Error", "Cannot get exec file", 0, 3)
			ExitLoop
		EndIf
	WEnd

	; If dont found exec file
	If ($getExecFile == False) Then
		MsgBox(16, "Error", "Cannot find exec file.")
		Return False
	EndIf

	; Run Mod Skin
	Local $runModSkin = runModSkin()
	If ($runModSkin == False) Then
		Return False
	EndIf

	MsgBox(64, "Success", "Extract success, run Mod Skin.")


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
	Local $listFile = _FileListToArrayRec($DirFolder, "*.exe|WinRAR.exe", 1)
	If @error = 1 Then
		Return False
	EndIf
	If @error = 4 Then
		Return False
	EndIf
	#Check if array not contain exec file
	If ($listFile[1] == '') Then
		Return False
	EndIf
	Return $listFile[1]
EndFunc   ;==>getExecFile

Func downloadModSkin($linkDownload)
	Local $fileDownload = $DirFolder & "\modskin.rar"

	; Download the file in the background with the selected option of 'force a reload from the remote site.
	Local $hDownload = InetGet($linkDownload, $fileDownload, 1, 1)

	; Turn on progress, Show current status, Display a progress bar window.
	ProgressOn("Download", "Downloading ModSkin...", "0%", -1, -1, BitOR($DLG_NOTONTOP, $DLG_MOVEABLE))
	Do
		Sleep(250)
		; Get status downloading
		Local $byteDownload = InetGetInfo($hDownload, 0)
		Local $byteTotal = InetGetInfo($hDownload, 1)
		Local $onError = InetGetInfo($hDownload, 4)

		; If error occur
		If ($onError <> 0) Then
			MsgBox(16, "Error", "Error while downloading.")
			InetClose($hDownload)
			ProgressOff()
			Return False
		EndIf

		; Update status
		setProgStatus($byteDownload, $byteTotal)

	Until InetGetInfo($hDownload, 2)

	; Turn off progress
	ProgressOff()

	; If file download not exist or don't have any kB
	If (FileExists($fileDownload) == 0 Or FileGetSize($fileDownload) == 0) Then
		MsgBox(16, "Error", "File is corrupt.")
		Return False
	EndIf

	Return True ;

EndFunc   ;==>downloadModSkin


Func setProgStatus($byteDownload, $totalByte)
	$percent = Round(($byteDownload / $totalByte) * 100)
	ProgressSet($percent, $percent & "%" & "     " & FormatFileSize($byteDownload) & '/' & FormatFileSize($totalByte))
EndFunc   ;==>setProgStatus





Func FormatFileSize($iSizeInBytes)

	Local $iSize, $i

	$iSize = $iSizeInBytes
	$i = 0
	While $iSize >= 1024 ;split value, you can set lower number like 900 for earlier switch (0.98 MB)
		$iSize /= 1024 ;this must be always 1024
		$i += 1
	WEnd

	$iSize = Round($iSize, 1) & " " ; enter how many decimals you want, here it's '1'

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

EndFunc   ;==>FormatFileSize
