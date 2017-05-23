<script language="vbscript" runat="server">
'-----------------------------------------------------------------------------
' filename....... global.asa
' lastupdate..... 05/23/2017
' description.... global declarations
'-----------------------------------------------------------------------------

ConfigFile = Server.MapPath("_config.txt")

'-----------------------------------------------------------------------------
' sub-name: Application_OnStart
' sub-desc: 
'-----------------------------------------------------------------------------

Sub Application_OnStart
	Dim objFSO, objFile, strData, strLine, dataset, delim
	delim = "~"
	If Application("CMWT_INIT") <> "TRUE" Then
		On Error Resume Next
		Set objFSO  = CreateObject("Scripting.FileSystemObject")
		Set objFile = objFSO.OpenTextFile(ConfigFile, 1)
		If err.Number <> 0 Then
			Response.Redirect "error.asp?m=Unable to map _config.txt for input"
		End If
		strData = objFile.ReadAll
		objFile.Close
		Set objFile = Nothing
		Set objFSO = Nothing
		For each strLine in Split(strData, vbCRLF)
			if Left(strLine,1) <> ";" then
				' check if custom delimiter has been defined
				if Left(strLine,14)="CMWT_DELIMITER" Then
					delim = Mid(strLine,16,1)
				else
					dataset = Split(strLine, delim)
					Application(dataset(0)) = dataset(1)
				end if
			end if
		Next
		Application("cmwt_version")   = "1704"
		Application("cmwt_build")     = "2017.05.23.01"
		Application("CMWT_USERCOUNT") = 0
		Application("CMWT_USERLIST")  = ""
		Application("CMWT_Title")     = "CMWT"
		Application("CMWT_SubTitle")  = "ConfigMgr Web Tools"
		Application("CMWT_CUSTOMREPFIELDS") = "ADSiteName,ClientVersion,ComputerName,Domain," & _
			"LastHWScan,LastSWScan,MAC,Model,OperatingSystem,OUName," & _
			"PhysicalMemory,Processor,ResourceID,Role,SerialNumber,SystemType"
		Application("CMWT_CUSTOMREPFIELDS2") = ""
		Application("CMWT_CUSTOMREPMODES") = "EQUALS,CONTAINS,BEGINSWITH,ENDSWITH,NOTEQUALS,NOTLIKE,GREATERTHAN,LESSTHAN,EQUALORGREATER,EQUALORLESS"
		Application("CMWT_DMENULIST") = "General:General Properties," & _
			"Active Directory:Active Directory Account," & _
			"Agent:Agent Activity," & _
			"Audio Devices:Audio Devices," & _
			"AutoStart: Auto-Start Applications," & _
			"BIOS:System BIOS," & _
			"Collections:CM Collections," & _
			"Deployments:Deployments," & _
			"Duplicate Files:Duplicate Files," & _
			"Features:Windows Features," & _
			"Local Printers:Local Printers," & _
			"Logical Disks:Logical Disks," & _
			"Memory:Physical Memory," & _
			"Network Adapters:Network Adapters," & _
			"Notes:Custom Notes," & _
			"Physical Disks:Physical Disks," & _
			"Processors:Processors," & _
			"Shares:Shares," & _
			"Software Applications:Software Applications," & _
			"Software Files:Software Files," & _
			"Software Updates:Software Updates," & _
			"Tools:Management Tools," & _
			"User Profiles:User Profiles," & _
			"Video:Video Display Adapters"
		Application("CMWT_CHASSISTYPES") = "1=Virtual,2=Blade Server,3=Desktop,4=Low-Profile Desktop,5=Pizza-Box," & _
			"6=Mini Tower,7=Tower,8=Portable,9=Laptop,10=Notebook,11=Hand-Held," & _
			"12=Mobile Device in Docking Station,13=All-in-One,14=Sub-Notebook," & _
			"15=Space Saving Chassis,16=Ultra Small Form Factor,17=Server Tower Chassis," & _
			"18=Mobile Device in Docking Station,19=Sub-Chassis,20=Bus-Expansion chassis," & _
			"21=Peripheral Chassis,22=Storage Chassis,23=Rack-Mounted Chassis,24=Sealed-Case PC"
		Application("CMWT_INIT")="TRUE"
	End If
End Sub

'----------------------------------------------------------------
' sub-name: Application_OnEnd
' sub-desc: 
'----------------------------------------------------------------

Sub Application_OnEnd()
	Application("CMWT_USERCOUNT") = 0
End Sub

'----------------------------------------------------------------
' sub-name: Session_OnStart
' sub-desc: 
'----------------------------------------------------------------

Sub Session_OnStart
	Application.Lock
	Application("CMWT_USERCOUNT") = Application("CMWT_USERCOUNT")+1
	user = Request.ServerVariables("REMOTE_USER")
	If (user <> "") Then
		If InStr(Application("CMWT_USERLIST"), user) < 1 Then
			If Application("CMWT_USERCOUNT") > 1 Then
				Application("CMWT_USERLIST") = Application("CMWT_USERLIST") & "," & user
			Else
				Application("CMWT_USERLIST") = user
			End If
		End If
	End If
	Application.UnLock
	Session("CMWT_USERNAME") = Replace(Request.ServerVariables("REMOTE_USER"), Application("CMWT_DOMAIN") & "\", "")
End Sub

'----------------------------------------------------------------
' sub-name: Session_OnEnd
' sub-desc: 
'----------------------------------------------------------------

Sub Session_OnEnd
	Application.Lock
	Application("CMWT_USERCOUNT") = Application("CMWT_USERCOUNT")-1
	user = Session("CMWT_USERNAME")
	If Application("CMWT_USERLIST") <> "" And user <> "" Then
		tmp = Application("CMWT_USERLIST")
		tmp = Replace(tmp, user, "")
		tmp = Replace(tmp, ",,", ",")
		Application("CMWT_USERLIST") = tmp
	End If
	Application.UnLock
End Sub

</script>
