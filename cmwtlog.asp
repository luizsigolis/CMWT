<!-- #include file=_core.asp -->
<%
'-----------------------------------------------------------------------------
' filename....... cmwtlog.asp
' lastupdate..... 12/04/2016
' description.... cmwt database log maintenance
'-----------------------------------------------------------------------------
time1 = Timer
QueryOn = CMWT_GET("qq", "")
KeySet  = CMWT_GET("l", "events")

select case Ucase(KeySet)
	case "TASKS":
		query = "SELECT * FROM dbo.Tasks ORDER BY DateTimeCreated DESC"
		PageTitle = "CMWT Task Logs"
	case "EVENTS":
		query = "SELECT * FROM dbo.EventLog ORDER BY EventDateTime DESC"
		PageTitle = "CMWT Event Logs"
end select

CMWT_NewPage "", "", ""
PageBackLink = "admin.asp"
PageBackName = "Administration"
%>
<!-- #include file="_sm.asp" -->
<table class="tfx">
	<tr>
		<td class="v10 pad6 bgDarkGray cGray">
		CMWT - Configuration Manager Web Tools :: Today is <%=FormatDateTime(Now,vbLongDate)%>
		</td>
		<td class="v10 pad6 bgDarkGray right">
			<input type="button" name="b1" id="b1" class="btx w140 h30" value="Clear Logs" onClick="document.location.href='cmwtlogclear.asp?l=<%=KeySet%>'" />
		</td>
	</tr>
</table>
<%

if Application("CMWT_ENABLE_LOGGING") = "TRUE" Then
	Dim conn, cmd, rs
	CMWT_DB_QUERY Application("DSN_CMWT"), query
	CMWT_DB_TABLEGRID rs, "", "", ""
	CMWT_DB_CLOSE()
Else
	Response.Write "<table class=""tfx""><tr class=""h200 tr1"">" & _
		"<td class=""td6 ctr v10"">Logging is not enabled.<p>" & _
		"To enable site activity logging, modify the _config.txt file " & _
		"to set CMWT_ENABLE_LOGGING~TRUE</p><p>Then recycle the IIS application pool.</p>" & _
		"</td></tr></table>"
End If
CMWT_FOOTER()
%>

</body>
</html>