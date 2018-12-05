' Script to monitor the CPU.
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
		strComputer = "."
		Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
		cpucount = 0
		Set colItems = objWMIService.ExecQuery ("Select * From Win32_PerfFormattedData_PerfOS_Processor WHERE Name <> '_Total'")
		For Each objItem in colItems
			cpucount=cpucount+1
		next

		Wscript.Echo "graph_title CPU usage"
		Wscript.Echo "graph_order system user irq idle"
		Wscript.Echo "graph_args --base 1000 -r --lower-limit 0 --upper-limit " & (cpucount * 100)
		Wscript.Echo "graph_vlabel %"
		Wscript.Echo "graph_scale no"
		Wscript.Echo "graph_info This graph shows how CPU time is spent."
		Wscript.Echo "graph_category system"
		Wscript.Echo "graph_period second"

		Wscript.Echo "system.label system"
		Wscript.Echo "system.draw AREA"
		'Wscript.Echo "system.max 5000"
		Wscript.Echo "system.min 0"
		Wscript.Echo "system.type DERIVE"
		Wscript.Echo "system.warning 30"
		Wscript.Echo "system.critical 50"
		Wscript.Echo "system.info CPU time spent by the kernel in system activities"
		Wscript.Echo "user.label user"
		Wscript.Echo "user.draw STACK"
		Wscript.Echo "user.min 0"
		'Wscript.Echo "user.max 5000"
		'Wscript.Echo "user.warning 80"
		Wscript.Echo "user.type DERIVE"
		Wscript.Echo "user.info CPU time spent by normal programs and daemons"
		Wscript.Echo "idle.label idle"
		Wscript.Echo "idle.draw STACK"
		Wscript.Echo "idle.min 0"
		'Wscript.Echo "idle.max 5000"
		Wscript.Echo "idle.type DERIVE"
		Wscript.Echo "idle.info Idle CPU time"
		Wscript.Echo "irq.label irq"
		Wscript.Echo "irq.draw STACK"
		Wscript.Echo "irq.min 0"
		'Wscript.Echo "irq.max 5000"
		Wscript.Echo "irq.type DERIVE"
		Wscript.Echo "irq.info CPU time spent handling interrupts"
	end if
else
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")

	cpucount = 0
	val_system=0
	val_user=0
	val_idle=0
	val_irq=0
	Set colItems = objWMIService.ExecQuery ("Select * From Win32_PerfRawData_PerfOS_Processor WHERE Name <> '_Total'")
	For Each objItem in colItems
		cpucount=cpucount+1
		val_system = val_system + Round(CDbl(objItem.PercentPrivilegedTime)/100000)
		val_user = val_user + Round(CDbl(objItem.PercentUserTime)/100000)
		val_idle = val_idle + Round(CDbl(objItem.PercentIdleTime)/100000)
		val_irq = val_irq + Round(CDbl(objItem.PercentInterruptTime)/100000)
	next
	Wscript.Echo "system.value " & val_system
	Wscript.Echo "user.value " & val_user
	Wscript.Echo "idle.value " & val_idle
	Wscript.Echo "irq.value " & val_irq
end if