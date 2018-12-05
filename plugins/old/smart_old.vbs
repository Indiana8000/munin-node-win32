On Error Resume Next

Set objWMI = GetObject("winmgmts://./root\WMI")
Set objInstances = objWMI.InstancesOf("MSStorageDriver_ATAPISmartData",48)

' http://en.wikipedia.org/wiki/Self-Monitoring%2C_Analysis%2C_and_Reporting_Technology#ATA_S.M.A.R.T._Attributes

For Each objInstance in objInstances
  i = instr(objInstance.InstanceName, "\Disk")
  j = instr(objInstance.InstanceName, chr(95) & chr(95) & chr(95))
  WScript.Echo mid(objInstance.InstanceName,i+5,j - (i+5))
  'WScript.Echo objInstance.VendorSpecific(0) & " : " & objInstance.VendorSpecific(1)
  'WScript.Echo UBound(objInstance.VendorSpecific)
  For myI = 2 To UBound(objInstance.VendorSpecific) Step 12
    If objInstance.VendorSpecific(myI) <> 0 Then
      'tmp = objInstance.VendorSpecific(myI)
      'For myJ = 1 To 10
      '  tmp = tmp & ", " & objInstance.VendorSpecific(myI + myJ)
      'Next
      'WScript.Echo tmp
      WScript.Echo objInstance.VendorSpecific(myI) & "=" & objInstance.VendorSpecific(myI + 5)
    End If
  Next
Next
WScript.Echo ""
