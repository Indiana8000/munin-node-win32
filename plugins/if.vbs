' Script to monitor interface traffic.
'
' Author: (c) Andreas Kreisl
' http://www.bluepaw.de/
' 
' This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License
' For all details visit http://creativecommons.org/licenses/by-nc-sa/3.0/

eth = GetParameter()
if eth <> "if" then
	extQual = " Index = " & eth
	extTitle = " (eth" & eth & ")"
else
	extQual = " IPEnabled = true"
	extTitle = ""
end if

if WScript.Arguments.Count <> 0 then
	if WScript.Arguments.Item(0) = "autoconfig" then
		echo "yes"
	end if
	if WScript.Arguments.Item(0) = "config" then
		'Wscript.Echo "graph_order down up"
		Wscript.Echo "graph_title interface traffic" & extTitle
		Wscript.Echo "graph_args --base 1000"
		Wscript.Echo "graph_vlabel bytes in (-) / out (+) per ${graph_period}"
		Wscript.Echo "graph_category network"
		Wscript.Echo "graph_info This graph shows the network interface traffic."

		strComputer = "."
		Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
		Set colItems = objWMIService.ExecQuery ("Select * From Win32_NetworkAdapterConfiguration WHERE " & extQual)
		For Each objItem in colItems
			tmp = "if" & objItem.Index
			Wscript.Echo tmp & "_down.label " & objItem.ServiceName & " received" 
			Wscript.Echo tmp & "_down.type COUNTER"
			Wscript.Echo tmp & "_down.graph no"
			'Wscript.Echo tmp & "_down.cdef " & tmp & "_down,8,*" 'Convert Bit to Byte
			Wscript.Echo tmp & "_up.label "& objItem.ServiceName
			Wscript.Echo tmp & "_up.type COUNTER"
			Wscript.Echo tmp & "_up.negative " & tmp & "_down"
			'Wscript.Echo tmp & "_up.cdef " & tmp & "_up,8,*" 'Convert Bit to Byte
			tmp2 = Replace(objItem.Description,"/","_")
			tmp2 = Replace(tmp2,"(","[")
			tmp2 = Replace(tmp2,")","]")
			Set colItems2 = objWMIService.ExecQuery ("Select * From Win32_PerfRawData_Tcpip_NetworkInterface WHERE Name = '" & tmp2 & "'")
			For Each objItem2 in colItems2
				Wscript.Echo tmp & "_up.info Traffic of the " & objItem.Description & " interface. Maximum speed is " & Round(objItem2.CurrentBandwidth/1000000) & " MBit/s."
			next
		Next
	end if
else
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery ("Select * From Win32_NetworkAdapterConfiguration WHERE " & extQual)
	For Each objItem in colItems
		tmp = "if" & objItem.Index
		tmp2 = Replace(objItem.Description,"/","_")
		tmp2 = Replace(tmp2,"(","[")
		tmp2 = Replace(tmp2,")","]")
		Set colItems2 = objWMIService.ExecQuery ("Select * From Win32_PerfRawData_Tcpip_NetworkInterface WHERE Name = '" & tmp2 & "'")
		For Each objItem2 in colItems2
			if objItem2.BytesSentPersec <0 then
				Wscript.Echo tmp & "_up.value " & (2147483647 + objItem2.BytesSentPersec)
			else
				Wscript.Echo tmp & "_up.value " & objItem2.BytesSentPersec
			end if

			if objItem2.BytesReceivedPersec <0 then
				Wscript.Echo tmp & "_down.value " & (2147483647 + objItem2.BytesReceivedPersec)
			else
				Wscript.Echo tmp & "_down.value " & objItem2.BytesReceivedPersec
			end if
		next
	Next
end if

Function GetParameter()
	name = WScript.ScriptName
	i = instrrev(name, "\")
	name = mid(name,i+1)
	i = instrrev(name, ".")
	name = left(name,i-1)
	i = instrrev(name, "_")
	parameter = mid(name,i+1)

	GetParameter = parameter
End Function