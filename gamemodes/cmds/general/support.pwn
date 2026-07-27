CMD:support(playerid,params[])
{
	if(GetPVarInt(playerid,"SupTicket") == 1 && GetPVarInt(playerid,"SupTicketOpen") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du hast bereits ein Support-Ticket verfasst. Bitte gedulde dich oder ziehe es mit /ct zurück.");
    if(GetPVarInt(playerid,"SupTicket") == 1 && GetPVarInt(playerid,"SupTicketOpen") == 1)
    {
        new text[254];
        if(sscanf(params,"s[254]",text))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/sup [Text]");
        if(strlen(text) < 1 || strlen(text) > 254)return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/sup [Text]");
		new string[254];
		format(string,sizeof(string),"[Support]: {FFFFFF}%s écrit : %s",SpielerInfo[playerid][sName],text);
		//SCM(GetPVarInt(playerid,"SupTicketAdmin"),COLOR_INFO,string);
		//SendClientMessage(playerid,COLOR_INFO,string);
		SendSplitMessage(GetPVarInt(playerid,"SupTicketAdmin"),COLOR_INFO,string);
		SendSplitMessage(playerid,COLOR_INFO,string);
		return 1;
    }
    else if(SpielerInfo[playerid][sAdmin] == 0 && GetPVarInt(playerid,"SupTicketTaked") <= 0 && GetPVarInt(playerid,"SupTicket") == 0 && GetPVarInt(playerid,"SupTicketOpen") == 0)
    {
        new text[254];
		if(sscanf(params,"s[254]",text))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/sup [Text]");
		if(strlen(text) < 1 || strlen(text) > 254)return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/sup [Text(10-64 Zeichen)]");
		CreateSupTicket(playerid,text);
		SendClientMessage(playerid,COLOR_YELLOW,"[Info]: {FFFFFF}Dein Support-Ticket wurde erstellt. Bitte warte bis ein Teammitglied dein Ticket öffnet.");
		SendClientMessage(playerid,COLOR_YELLOW,"[Info]: {FFFFFF}Solltest du offline gehen oder '/ct' nutzen wird dein Support-Ticket gelöscht.");
		return 1;
	}
	else if(SpielerInfo[playerid][sAdmin] >= 1 && GetPVarInt(playerid,"SupTicketTaked") > 0)
	{
	    new text[254];
        if(sscanf(params,"s[254]",text))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/sup [Text]");
        if(strlen(text) < 1 || strlen(text) > 254)return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/sup [Text(10-64 Zeichen)]");
		new string[254];
		format(string,sizeof(string),"[Support]: {FFFFFF}%s %s écrit : %s",AdminNameList(playerid),SpielerInfo[playerid][sName],text);
		//SCM(GetPVarInt(playerid,"SupTicketTaked"),COLOR_INFO,string);
		//SendClientMessage(playerid,COLOR_YELLOW,string);
		SendSplitMessage(GetPVarInt(playerid,"SupTicketTaked"),COLOR_INFO,string);
		SendSplitMessage(playerid,COLOR_YELLOW,string);
		return 1;
	}
	return 1;
}
alias:support("report", "sup")

CMD:tickets(playerid,params[])
{
	if(SpielerInfo[playerid][sAdmin] == 0)return NichtBerechtigt
    new string[200], query[128];
    SendClientMessage(playerid,COLOR_YELLOW,"Alle offenen Support-Tickets - zum annehmen '/taketicket'");
    foreach(new i : Player)
    {
        if(GetPVarInt(i,"SupTicket") == 1 && GetPVarInt(i,"SupTicketOpen") == 0)
        {
            format(query,sizeof(query),"%s",mysql_GetString("suptickets", "Text", "Name", SpielerInfo[i][sName]));
			format(string,sizeof(string),"%s | [%d] | %s",SpielerInfo[i][sName],i,query);
			SendClientMessage(playerid,COLOR_INFO,string);
        }
    }
    return 1;
}

CMD:createsup(playerid,params[])
{
	if(SpielerInfo[playerid][sAdmin] < 1)return NichtBerechtigt
	new pID;
    if(sscanf(params,"u",pID))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/createsup [SpielerID]");
    if(IsPlayerNPC(pID) || !IsPlayerConnectedEx(pID))return SendClientMessage(playerid,COLOR_RED,"[Fehler]: {FFFFFF}Diese ID kann keinem aktiven Spieler zugeordnet werden.");
    if(SpielerInfo[pID][sAdmin] == 0 && GetPVarInt(pID,"SupTicketTaked") <= 0 && GetPVarInt(pID,"SupTicket") == 0 && GetPVarInt(pID,"SupTicketOpen") == 0)
    {
		new string[128];
		format(string,sizeof(string),"Ticket ouvert administrativement par %s %s.",AdminName(playerid),SpielerInfo[playerid][sName]);
		CreateSupTicket(pID,string);
		format(string,sizeof(string),"[Support]: {FFFFFF}%s %s a ouvert un ticket pour toi.",AdminNameList(playerid),SpielerInfo[playerid][sName]);
		SendClientMessage(pID,COLOR_INFO,string);
		SendClientMessage(pID,COLOR_INFO,"[Support]: {FFFFFF}Dein Ticket muss jedoch noch von einem Teammitglied geöffnet werden.");
		format(string,sizeof(string),"[Support]: {FFFFFF}Tu as créé un ticket pour %s.",SpielerInfo[pID][sName]);
		SendClientMessage(playerid,COLOR_INFO,string);
		new log_admstring[128];
		format(log_admstring,sizeof(log_admstring),"%s %s a utilisé la commande '/createsup'. [%d]",AdminNameList(playerid),SpielerInfo[playerid][sName],GetPVarInt(playerid,"AdminDuty"));
		CreateServerLogEntry("ADMIN_LOG", log_admstring);
		return 1;
	}
	else SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Für diesen Spieler kann momentan kein Ticket erstellt werden.");
	return 1;
}

CMD:taketicket(playerid,params[])
{
    new pID,ticket[200];
	if(SpielerInfo[playerid][sAdmin] == 0)return NichtBerechtigt
	if(sscanf(params,"u",pID))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/taketicket [SpielerID]");
	if(!IsPlayerConnectedEx(pID))return NichtOnline
	if(GetPVarInt(pID,"SupTicket") == 0 || GetPVarInt(pID,"SupTicketOpen") == 1)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der Spieler hat kein offenes Support-Ticket.");
	format(ticket,sizeof(ticket),"[Support]: {FFFFFF}%s schrieb: %s",SpielerInfo[pID][sName], mysql_GetString("suptickets", "Text", "Name", SpielerInfo[pID][sName]));
	SendClientMessage(playerid,COLOR_YELLOW,"[Support]: {FFFFFF}Du hast das Support-Ticket geöffnet. Antworte dem Spieler mit '/sup'.");
	SendClientMessage(playerid,COLOR_INFO,ticket);
	SetPVarInt(pID,"SupTicketOpen",1);
	SetPVarInt(pID,"SupTicketAdmin",playerid);
	SetPVarInt(playerid,"SupTicketTaked",pID);
	format(ticket,sizeof(ticket),"[Support]: %s {FFFFFF}%s a ouvert ton ticket. Tu peux maintenant lui écrire via '/sup'.",AdminNameList(playerid),SpielerInfo[playerid][sName]);
	SendClientMessage(pID,COLOR_YELLOW,ticket);
	SpielerInfo[playerid][sTicketsBearbeitet]++;
	format(ticket,sizeof(ticket),"[Support]: %s {FFFFFF}%s a ouvert le ticket de support de %s.",AdminNameList(playerid),SpielerInfo[playerid][sName],SpielerInfo[pID][sName]);
	SendAdminMessage(COLOR_INFO,ticket);
	return 1;
}

CMD:giveticket(playerid,params[])
{
    new pID,ticket[200];
    if(SpielerInfo[playerid][sAdmin] == 0)return NichtBerechtigt
	if(sscanf(params,"u",pID))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/giveticket [SpielerID]");
	{
		if(!IsPlayerConnectedEx(pID))return NichtOnline
		if(GetPVarInt(playerid,"SupTicketTaked") <= 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bearbeitest derzeit kein offenes Support-Ticket.");
		if(GetPVarInt(pID,"SupTicketTaked") > 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Das Teammitglied bearbeitet bereits ein offenes Support-Ticket.");
		new ticketID = GetPVarInt(playerid,"SupTicketTaked");
		if(!IsPlayerConnected(ticketID))return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der Spieler der das Ticket eröffnet hatte, hat sich ausgeloggt.");
		format(ticket,sizeof(ticket),"[SUPPORT] %s schrieb: %s",SpielerInfo[ticketID][sName], mysql_GetString("suptickets", "Text", "Name", SpielerInfo[ticketID][sName]));
		SendClientMessage(playerid,COLOR_YELLOW,"[Info]: {FFFFFF}Du hast das Support-Ticket weitergegeben.");
		SendClientMessage(pID,COLOR_YELLOW,"[Info]: {FFFFFF}Du hast ein neues Support-Ticket zugeleitet bekommen.");
		SendClientMessage(pID,COLOR_INFO,ticket);
		SetPVarInt(pID,"SupTicketTaked",ticketID);
		SetPVarInt(ticketID,"SupTicketAdmin",pID);
		format(ticket,sizeof(ticket),"[SUPPORT] %s %s a repris ton ticket. Continue à écrire via '/sup' avec ce membre du staff.",AdminName(pID),SpielerInfo[pID][sName]);
		SendClientMessage(ticketID,COLOR_YELLOW,ticket);
		SendClientMessage(ticketID,COLOR_YELLOW,"[SUPPORT] Bitte gebe dem neuem Teammitglied einen Moment Zeit sich in dein Ticket einzulesen.");
  		SetPVarInt(playerid,"SupTicketTaked",-1);
  		SpielerInfo[playerid][sTicketsBearbeitet]--;
	}
	return 1;
}

CMD:closeticket(playerid,params[])
{
    if(SpielerInfo[playerid][sAdmin] == 0)return NichtBerechtigt
	new pID;
	if(sscanf(params,"u",pID))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/closeticket [SpielerID]");
	if(!IsPlayerConnectedEx(pID))return NichtOnline
	if(GetPVarInt(pID,"SupTicket") == 0)return SendClientMessage(playerid,COLOR_GREY,"[Info]: Der Spieler hat kein offenes Support-Ticket.");
	if(GetPVarInt(pID,"SupTicketAdmin") != playerid)return SendClientMessage(playerid,COLOR_GREY,"[Info]: Du supportest dieses Ticket nicht.");
	new string[128];
	format(string,sizeof(string),"[SUPPORT] %s %s a fermé ton ticket de support. Ton avis aiderait beaucoup "SERV_NAME" !",AdminName(playerid),SpielerInfo[playerid][sName]);
	SendClientMessage(pID,COLOR_YELLOW,string);
	format(string,sizeof(string),"[SUPPORT] Tu as fermé le ticket de support de %s.",SpielerInfo[pID][sName]);
	SendClientMessage(playerid,COLOR_YELLOW,string);
	DeleteSupTicket(pID);
	DeletePVar(pID,"SupTicket");
	DeletePVar(pID,"SupTicketOpen");
	SetPVarInt(playerid,"SupTicketTaked",-1);
	DeletePVar(pID,"SupTicketAdmin");
	return 1;
}

CMD:ct(playerid, params[])
{
    new string[256];
	if(GetPVarInt(playerid,"SupTicket") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du hast kein offenes Support-Ticket.");
	switch(GetPVarInt(playerid,"SupTicketOpen"))
	{
	    case 0:
	    {
			format(string,sizeof(string),"%s a retiré son ticket de support sans réponse.",SpielerInfo[playerid][sName]);
			SendAdminMessage(COLOR_INFO,string);
			SendClientMessage(playerid,COLOR_YELLOW,"[SUPPORT] Du hast dein Support-Ticket gelöscht.");
			DeleteSupTicket(playerid);
			DeletePVar(playerid,"SupTicket");
			DeletePVar(playerid,"SupTicketOpen");
			return 1;
	    }
	    case 1:
	    {
			format(string,sizeof(string),"[SUPPORT] %s a supprimé son ticket de support.",SpielerInfo[playerid][sName]);
			SendClientMessage(GetPVarInt(playerid,"SupTicketAdmin"),COLOR_YELLOW,string);
			SendClientMessage(playerid,COLOR_YELLOW,"[SUPPORT] Du hast dein Support-Ticket gelöscht.");
			DeleteSupTicket(playerid);
			DeletePVar(playerid,"SupTicket");
			DeletePVar(playerid,"SupTicketOpen");
			SetPVarInt(GetPVarInt(playerid,"SupTicketAdmin"),"SupTicketTaked",-1);
			DeletePVar(playerid,"SupTicketAdmin");
			return 1;
	    }
	}
	return 1;
}