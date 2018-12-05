' Script to monitor Temperatures.
'
' Author: (c) Andreas Kreisl
' http://www.bluepaw.de/
' 
' This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License
' For all details visit http://creativecommons.org/licenses/by-nc-sa/3.0/

if WScript.Arguments.Count <> 0 then
	if WScript.Arguments.Item(0) = "autoconfig" then
		echo "yes"
	end if
	if WScript.Arguments.Item(0) = "config" then
		Wscript.Echo "graph_title Temperatures"
		Wscript.Echo "graph_args --base 1000 -l 0"
		Wscript.Echo "graph_vlabel °C"
		Wscript.Echo "graph_category sensors"

		Set objWMIService = GetObject("winmgmts:\\.\root\wmi")
		Set colItems = objWMIService.InstancesOf("MSAcpi_ThermalZoneTemperature")
		i=0
		For Each objItem in colItems
			i=i+1
			Wscript.Echo "temp" & i & ".label Temp-Sensor " & i
			Wscript.Echo "temp" & i & ".warning 75"
			Wscript.Echo "temp" & i & ".critical 85"
		Next
	end if
else
	Set objWMIService = GetObject("winmgmts:\\.\root\wmi")
	set colItems = objWMIService.InstancesOf("MSAcpi_ThermalZoneTemperature")
	i=0
	For Each objItem in colItems
		i=i+1
		WScript.echo "temp" & i & ".value " & Round((objItem.CurrentTemperature / 10) - 273.15)
	Next
end if
