#cs----------------------------------------------------------------------------
###    Script collect data about user in file which hosted on LAN
###
###    Author: Khabirov Aidar (danaconda666@gmail.com)
###    Created: 17:36 15.09.2016
###
###
###    This program is free software; you can redistribute it and/or modify
###    it under the terms of the GNU General Public License as published by
###    the Free Software Foundation; either version 2 of the License, or
###    (at your option) any later version.
#ce----------------------------------------------------------------------------
Global $file="\\prez\work.log"
Func _GetMAC($getmacindex = 1)
    $ipHandle = Run(@ComSpec & ' /c ipconfig /all', '', @SW_HIDE, 2)
    $read = ""
    Do
        $read &= StdoutRead($ipHandle)
    Until @error

    $read = StringStripWS($read,7)

    $macdashed = StringRegExp( $read , '([0-9A-F]{2}-[0-9A-F]{2}-[0-9A-F]{2}-[0-9A-F]{2}-[0-9A-F]{2}-[0-9A-F]{2})', 3)
    If Not IsArray($macdashed) Then Return 0
    If $getmacindex <  1 Then Return 0
    If $getmacindex > UBound($macdashed) Or $getmacindex = -1 Then $getmacindex = UBound($macdashed)
    $macnosemicolon = StringReplace($macdashed[$getmacindex - 1], '-', ':', 0)
    Return $macnosemicolon
EndFunc;==>_GetMAC


Func _IsLocalAdmin()
	$cmdHandle = Run(@ComSpec & " /c net localgroup Администраторы", "", @SW_HIDE, 2)
	$isAdmin = "is not Local Admin"
	$read = ""
	$domName = @LogonDomain&"\"&@UserName
	$name = @UserName
	Do
		$read &= StdoutRead($cmdHandle)
	Until @error
	If StringinStr($read, $name) > 0 Or StringInStr($read,$domName) > 0  Then $isAdmin = "is Local Admin"
	Return $isAdmin
EndFunc;==>_IsLocalAdmin


Func _SetPlace($str, $count)
	If $count <= StringLen($str) Then
		return $str
	Else
		Local $up = $count - StringLen($str)
		For $i = 1 to $up
			$str = " "&$str
		Next
	EndIf
	return $str
EndFunc;==>_SetPlace


Global $mac = _GetMAC()
Global $isAdmin = _IsLocalAdmin()
Global $user = @LogonDomain&"\"&@UserName
Global $pc = @ComputerName
Global $dt = @HOUR&":"&@MIN&"/"&@MDAY&"."&@MON&"."&@YEAR
Global $ip = @IPAddress1
Global $msg = "User: "&_SetPlace($user, 25)&" PC: "&_SetPlace($pc, 15)&" DateTime: "&$dt&" IP: "&_SetPlace($ip, 15)&" MAC: "&$mac&" "&_SetPlace($isAdmin, 18)&@CRLF
$fileHandle = 0
$fileHandle = FileOpen($file, 1)

While $fileHandle = -1
	Sleep(3000)
	$fileHandle = FileOpen($file, 1)
WEnd
FileWrite($fileHandle, $msg)
FileClose($fileHandle)
