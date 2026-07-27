CMD:startlotto(playerid,params[])
{
    if(SpielerInfo[playerid][sFraktion] == 8 || SpielerInfo[playerid][sAdmin] >= 5)
    {
        if(SpielerInfo[playerid][sAdmin] == 0 && GetPVarInt(playerid,"SanNewsDuty") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
	    new string[200];
	    format(string,200,"Le tirage du loto a commencé !");
	    sendNewsMessage(string);
	    SetTimer("Lottostart",10000,false);
		return 1;
	}
	else NichtBerechtigt
	return 1;
}
CMD:n(playerid,params[])
{
	if(SpielerInfo[playerid][sFraktion] != 8)return NichtBerechtigt
	if(GetPVarInt(playerid,"SanNewsDuty") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
    new text[128], string[144];
    if(sscanf(params,"s[128]",text))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/n [Text]");
    format(string,200,"Journaliste %s: %s",SpielerInfo[playerid][sName],text);
    sendNewsMessage(string);
    return 1;
}
CMD:live(playerid,params[])
{
    if(SpielerInfo[playerid][sFraktion] != 8)return NichtBerechtigt
	if(GetPVarInt(playerid,"SanNewsDuty") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
   	if(GetPVarInt(playerid,"News_Live") == 1)
	{
	    SendClientMessage(playerid,COLOR_YELLOW,"Du bist nicht mehr auf Sendung!");
   	    DeletePVar(playerid,"News_Live");
   	    return 1;
	}
   	if(FahrzeugInfo[GetPlayerVehicleID(playerid)][fFraktion] != 8)return SendClientMessage(playerid,COLOR_YELLOW,"Du bist nicht in einem News-Fahrzeug!");
	if(isNewsLive(playerid))return SendClientMessage(playerid,COLOR_YELLOW,"Dieses Fahrzeug ist bereits Live auf Sendung!");

	foreach(new i : Player)
	{
	    if(GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
	    {
	        SetPVarInt(playerid,"News_Live",1);
  		 	SendClientMessage(playerid,COLOR_YELLOW,"Du bist nun Live auf Sendung und kannst über den normalen Chat LIVE schreiben.");
	    }
	}
    return 1;
}
CMD:itstandorte(playerid, params[])
{
    if(SpielerInfo[playerid][sFraktion] != 8)return NichtBerechtigt
	if(GetPVarInt(playerid,"SanNewsDuty") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
	new cmdparams[24];
    if(sscanf(params,"s[24]",cmdparams))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/itstandorte [farblager|papierlager|itlager]");
	if(strcmp(cmdparams, "farblager", true, strlen(cmdparams)) == 0)
	{
	    SetPlayerCheckpointEx(playerid,DRUCKER_FARBEN_LAGER_POS, 3.5);
	    SendClientMessage(playerid,COLOR_SUPER,"Das Lager für die Druckerfarben wurde auf der Minimap markiert.");
	}
	else if(strcmp(cmdparams, "papierlager", true, strlen(cmdparams)) == 0)
	{
	    SetPlayerCheckpointEx(playerid,DRUCKER_PAPIER_LAGER_POS, 3.5);
	    SendClientMessage(playerid,COLOR_SUPER,"Das Lager für das Druckerpapier wurde auf der Minimap markiert.");
	}
	else if(strcmp(cmdparams, "itlager", true, strlen(cmdparams)) == 0)
	{
	    SetPlayerCheckpointEx(playerid,IT_LAGER_POS, 3.5);
	    SendClientMessage(playerid,COLOR_SUPER,"Das Interglobal Television Lager wurde auf der Minimap markiert.");
	}
	return 1;
}
CMD:getfarbe(playerid, params[])
{
    if(SpielerInfo[playerid][sFraktion] != 8)return NichtBerechtigt
	if(GetPVarInt(playerid,"SanNewsDuty") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
    if(FahrzeugInfo[GetPlayerVehicleID(playerid)][fFraktion] != 8)return SendClientMessage(playerid,COLOR_YELLOW,"Du bist nicht in einem News-Fahrzeug!");
	if(!IsPlayerInRangeOfPoint(playerid,5.0,DRUCKER_FARBEN_LAGER_POS))return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist {CD262F}nicht{FFFFFF} in der Nähe des Lagers.");
	new amount, string[144];
	if(sscanf(params,"i",amount))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/getfarbe [Anzahl]");
	if(amount < 0 || amount > 25)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Die Anzahl darf sich nur zwischen 1 - 25 befinden.");
	if(ServerLager[drucker_farbe] < amount)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Es befindet sich nicht genügend Druckerfarbe im Lager.");
	if(GetPVarInt(playerid, "NewsFARBE") + amount > 25)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}So viel Farbe kannst du nicht auf einmal befördern.");
	ServerLager[drucker_farbe] -= amount;
	SetPVarInt(playerid, "NewsLoadVeh", GetPlayerVehicleID(playerid));
	SetPVarInt(playerid, "NewsFARBE", amount);
	format(string, sizeof(string), "{FF6600}Interglobal Television\nStock d'encre\n%i/%i", ServerLager[drucker_farbe], MAX_DRUCKER_FARBE_IN_LAGER);
	UpdateDynamic3DTextLabelText(ServerLager[druckerfarbe_label], COLOR_WHITE, string);
	format(string, sizeof(string),"Tu as chargé %i encre dans ton véhicule. Amène-la au dépôt Interglobal Television.");
	SendClientMessage(playerid, COLOR_YELLOW, "Du kannst die Farbe am Interglobal Television Lager mit '/itlager' abliefern.");
	return 1;
}
CMD:getpapier(playerid, params[])
{
    if(SpielerInfo[playerid][sFraktion] != 8)return NichtBerechtigt
	if(GetPVarInt(playerid,"SanNewsDuty") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
    if(FahrzeugInfo[GetPlayerVehicleID(playerid)][fFraktion] != 8)return SendClientMessage(playerid,COLOR_YELLOW,"Du bist nicht in einem News-Fahrzeug!");
	if(!IsPlayerInRangeOfPoint(playerid,5.0,DRUCKER_PAPIER_LAGER_POS))return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist {CD262F}nicht{FFFFFF} in der Nähe des Lagers.");
	new amount, string[144];
	if(sscanf(params,"i",amount))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/getpapier [Anzahl]");
	if(amount < 0 || amount > 50)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Die Anzahl darf sich nur zwischen 1 - 50 befinden.");
	if(ServerLager[drucker_papier] < amount)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Es befindet sich nicht genügend Druckerpapier im Lager.");
	if(GetPVarInt(playerid, "NewsPAPIER") + amount > 50)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}So viel Papier kannst du nicht auf einmal befördern.");
	ServerLager[drucker_papier] -= amount;
	SetPVarInt(playerid, "NewsLoadVeh", GetPlayerVehicleID(playerid));
	SetPVarInt(playerid, "NewsPAPIER", amount);
	format(string, sizeof(string), "{FF6600}Interglobal Television\nStock de papier\n%i/%i", ServerLager[drucker_papier], MAX_DRUCKER_PAPIER_IN_LAGER);
	UpdateDynamic3DTextLabelText(ServerLager[druckerpapier_label], COLOR_WHITE, string);
	format(string, sizeof(string),"Tu as chargé %i papier dans ton véhicule. Amène-le au dépôt Interglobal Television.");
	SendClientMessage(playerid, COLOR_YELLOW, string);
	SendClientMessage(playerid, COLOR_YELLOW, "Du kannst das Papier am Interglobal Television Lager mit '/itlager' abliefern.");
	return 1;
}
CMD:itlager(playerid, params[])
{
    if(SpielerInfo[playerid][sFraktion] != 8)return NichtBerechtigt
	if(GetPVarInt(playerid,"SanNewsDuty") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
    if(FahrzeugInfo[GetPlayerVehicleID(playerid)][fFraktion] != 8)return SendClientMessage(playerid,COLOR_YELLOW,"Du bist nicht in einem News-Fahrzeug!");
    if(!IsPlayerInRangeOfPoint(playerid,5.0,IT_LAGER_POS))return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist {CD262F}nicht{FFFFFF} in der Nähe des Lagers.");
    if(GetPlayerVehicleID(playerid) != GetPVarInt(playerid,"NewsLoadVeh"))return SendClientMessage(playerid,COLOR_YELLOW,"In diesem Fahrzeug befindet sich keine Farbe oder Papier.");
    new paperamount = GetPVarInt(playerid, "NewsPAPIER"), farbeamount = GetPVarInt(playerid, "NewsFARBE"),string[144];
    if(paperamount > 0)
    {
        format(string, sizeof(string), "Tu as déposé %i papier au dépôt Interglobal Television.");
        SendClientMessage(playerid, COLOR_YELLOW, string);
        ServerLager[it_lager_papier] += paperamount;
        DeletePVar(playerid, "NewsPAPIER");
	}
	if(farbeamount > 0)
    {
        format(string, sizeof(string), "Tu as déposé %i encre au dépôt Interglobal Television.");
        SendClientMessage(playerid, COLOR_YELLOW, string);
        ServerLager[it_lager_farbe] += farbeamount;
        DeletePVar(playerid, "NewsFARBE");
	}
	DeletePVar(playerid, "NewsLoadVeh");
	format(string, sizeof(string), "{FF6600}Interglobal Television - Stock\n{FFCC99}Encre : %i\nPapier : %i\nJournaux : %i",
	ServerLager[it_lager_farbe], ServerLager[it_lager_papier], ServerLager[it_lager_newspaper]);
	UpdateDynamic3DTextLabelText(ServerLager[it_lager_label], COLOR_WHITE, string);
    return 1;
}
CMD:newspaper(playerid, params[])
{
    if(SpielerInfo[playerid][sFraktion] != 8)return NichtBerechtigt
	if(GetPVarInt(playerid,"SanNewsDuty") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
	if(!IsPlayerInRangeOfPoint(playerid,5.0,IT_LAGER_POS))return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist {CD262F}nicht{FFFFFF} in der Nähe des Lagers.");
	new cmdparams[24], amount, string[144];
    if(sscanf(params,"s[24]i",cmdparams, amount))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/newspaper [new|delete|list|print|select|price][slot/id/menge]");
	if(strcmp(cmdparams, "new", true, strlen(cmdparams)) == 0)
	{
		new newsslot = getEmptyNewsPaperSlot();
		if(newsslot == -1)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Es können keine weiteren Zeitungen geschrieben werden. Lösche zuvor eine Zeitung (/newspaper delete).");
		SetPVarInt(playerid, "NewNewspaper", newsslot);
		return ShowPlayerDialog(playerid, DIALOG_NEW_NEWSPAPER, DIALOG_STYLE_INPUT, "IT - Newspaper", "Gib den gewünschten Titel ein:\n(maximal 32 Zeichen)", "Auswählen", "Schließen");
	}
	else if(strcmp(cmdparams, "delete", true, strlen(cmdparams)) == 0)
	{
	    if(amount < 0 || amount > MAX_NEWS_PAPER)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Ungültige SlotID ausgewählt.");
	    if(NewsPaper[amount][SlotUsed] == 0)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Ungültige SlotID ausgewählt. Der Slot wird aktuell nicht verwendet.");
	    new titlestring[64], allnpcstring[256];
	    format(string, sizeof(string),"Titre : %s\n\nTexte :\n", NewsPaper[amount][Title]);
	    strcat(allnpcstring, string);
	    for(new lines = 0; lines < NewsPaper[amount][Lines]; lines++)
	    {
	        strcat(allnpcstring, NewsPaperLines[amount][lines]);
	        strcat(allnpcstring, "\n");
		}
		strcat(allnpcstring, "\n\nEs-tu sûr(e) de vouloir supprimer ce journal ?");
	    format(titlestring, sizeof(titlestring), "IT - Journal (ID : %i)", amount);
	    SetPVarInt(playerid, "ChoosenNewspaper", amount);
	    return ShowPlayerDialog(playerid, DIALOG_DELETE_NEWSPAPER, DIALOG_STYLE_MSGBOX, titlestring, allnpcstring, "Löschen", "Abbrechen");
	}
	else if(strcmp(cmdparams, "list", true, strlen(cmdparams)) == 0)
	{
	    new allnpstring[256], counter = 0;
	    for(new i = 0; i < MAX_NEWS_PAPER; i++)
	    {
	        if(NewsPaper[i][SlotUsed] == 0)continue;
	        format(string, sizeof(string),"ID Emplacement : %i/%i | %i | Lignes : %i/%i",
			i, MAX_NEWS_PAPER, NewsPaper[i][Title], NewsPaper[i][Lines],MAX_LINES_NEWSPAPER);
     		strcat(allnpstring,string);
     		counter++;
		}
		if(counter == 0)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Es wurden noch keine Zeitungen verfasst.");
		return ShowPlayerDialog(playerid, DIALOG_LIST_NEWSPAPER, DIALOG_STYLE_MSGBOX, "IT - Newspaper", allnpstring, "Schließen", "");
	}
	else if(strcmp(cmdparams, "print", true, strlen(cmdparams)) == 0)
	{
	    if(ServerLager[it_lager_newspaper_id] == -1)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Es wurde keine Zeitung zum Verkauf ausgewählt (/newspaper select).");
		new newsslot = getNewsSlot();
		if(newsslot == -1)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Die Auswahl ist fehlgeschlagen! Es liegt ein Fehler in der Datenbank vor.");
		if(ServerLager[it_lager_papier] < amount*NewsPaper[newsslot][Lines])return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Es wird mehr Papier benötigt (Zeitungsanzahl x Zeile = pro Druck).");
		if(ServerLager[it_lager_farbe] < amount*2)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Es wird mehr Farbe benötigt (Zeitungsanzahl x 2 = pro Druck).");
        GivePlayerEXP(playerid,5*amount);
		ServerLager[it_lager_papier] -= amount*NewsPaper[newsslot][Lines];
		ServerLager[it_lager_farbe] -= amount*2;
		ServerLager[it_lager_newspaper] += amount;
	    format(string, sizeof(string), "{FF6600}Interglobal Television - Stock\n{FFCC99}Encre : %i\nPapier : %i\nJournaux : %i",
		ServerLager[it_lager_farbe], ServerLager[it_lager_papier], ServerLager[it_lager_newspaper]);
		UpdateDynamic3DTextLabelText(ServerLager[it_lager_label], COLOR_WHITE, string);
		format(string, sizeof(string), "{FF6600}Interglobal Television - Stock\n{FFCC99}Journaux : %i\n/getnewspaper",ServerLager[it_lager_newspaper]);
        UpdateDynamic3DTextLabelText(ServerLager[it_newspaper_lager_label], COLOR_WHITE, string);
        format(string, sizeof(string),"Tu as fabriqué %i journaux avec succès (%i EXP reçus).", amount, 5*amount);
        return SendClientMessage(playerid, COLOR_YELLOW, string);
	}
	else if(strcmp(cmdparams, "select", true, strlen(cmdparams)) == 0)
	{
	    if(amount < 0 || amount > MAX_NEWS_PAPER)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Ungültige SlotID ausgewählt.");
     	if(NewsPaper[amount][SlotUsed] == 0)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Ungültige SlotID ausgewählt. Der Slot wird aktuell nicht verwendet.");
     	if(NewsPaper[amount][dbID] == ServerLager[it_lager_newspaper_id])return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Die ausgewählte Zeitung wird derzeit bereits verkauft.");
		SetPVarInt(playerid, "SelectNewspaper", amount);
		format(string, sizeof(string),"Veux-tu sélectionner le journal '%s' pour la vente ?\n\nLes journaux déjà imprimés en stock seront cependant supprimés !", NewsPaper[amount][Title]);
		return ShowPlayerDialog(playerid, DIALOG_SELECT_NEWSPAPER, DIALOG_STYLE_MSGBOX, "IT - Newspaper", string, "Auswählen", "Abbrechen");
	}
	else if(strcmp(cmdparams, "price", true, strlen(cmdparams)) == 0)
	{
	    if(amount < 50)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Der Preis für eine Zeitung muss mindestens bei 50 $ liegen.");
	    ServerLager[it_newspaper_price] = amount;
	    for(new i = 0; i < MAX_KIOSKS; i++)
		{
		    if(NewsPaperKiosk[i][SlotUsed] == 1)
		    {
		        format(string, sizeof(string),"Kiosque à journaux\n\nJournaux : %i\n/buynewspaper\n%i $",
				ServerLager[it_newspaper_price]);
				UpdateDynamic3DTextLabelText(NewsPaperKiosk[i][nkLabel], COLOR_WHITE, string);
		    }
		}
	    format(string, sizeof(string),"Tu as fixé le prix par journal à %i $.", amount);
	    return SendClientMessage(playerid, COLOR_YELLOW, string);
	}
	return 1;
}
CMD:newskiosk(playerid, params[])
{
    if(SpielerInfo[playerid][sFraktion] != 8)return NichtBerechtigt
	if(GetPVarInt(playerid,"SanNewsDuty") == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
	if(SpielerInfo[playerid][sRank] < 3)return KeinRang
	new cmdparams[24], string[144];
    if(sscanf(params,"s[24]",cmdparams))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/newskiosk [add|delete]");
	if(strcmp(cmdparams, "add", true, strlen(cmdparams)) == 0)
	{
		for(new i = 0; i < MAX_KIOSKS; i++)
		{
		    if(NewsPaperKiosk[i][SlotUsed] == 0)
		    {
		        NewsPaperKiosk[i][SlotUsed] = 1;
		        NewsPaperKiosk[i][ZeitungAmount] = 0;
		        GetPlayerPos(playerid, NewsPaperKiosk[i][nkX], NewsPaperKiosk[i][nkY], NewsPaperKiosk[i][nkZ]);
		        NewsPaperKiosk[i][Ersteller] = SpielerInfo[playerid][sDBID];
		        format(string, sizeof(string),"Kiosque à journaux\n\nJournaux : %i\n/buynewspaper\n%i $",NewsPaperKiosk[i][ZeitungAmount],ServerLager[it_newspaper_price]);
				NewsPaperKiosk[i][nkLabel] = CreateDynamic3DTextLabel(string, COLOR_WHITE, NewsPaperKiosk[i][nkX], NewsPaperKiosk[i][nkY], NewsPaperKiosk[i][nkZ]+0.2, 10.0);
                NewsPaperKiosk[i][nkPickup] = CreatePickup(2894, 23, NewsPaperKiosk[i][nkX], NewsPaperKiosk[i][nkY], NewsPaperKiosk[i][nkZ], -1);
				mysql_format(sqlHandle, string, sizeof(string),"INSERT INTO `newskiosk` (`nkX`, `nkY`, `nkZ`, `ZeitungAmount`, `Ersteller`) VALUES ('%f', '%f', '%f', '%i', '%i')",
				NewsPaperKiosk[i][nkX], NewsPaperKiosk[i][nkY], NewsPaperKiosk[i][nkZ], NewsPaperKiosk[i][ZeitungAmount], NewsPaperKiosk[i][Ersteller]);
				mysql_tquery(sqlHandle, string);
			 	NewsPaperKiosk[i][dbID] = mysql_GetIntEx("SELECT LAST_INSERT_ID() FROM `newskiosk` LIMIT 1;");
                return SendClientMessage(playerid, COLOR_YELLOW, "Du hast erfolgreich einen Zeitungsstand erstellt.");
			}
		}
		return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Es können keine weiteren Zeitungsstände erstellt werden.");
	}
	else if(strcmp(cmdparams, "delete", true, strlen(cmdparams)) == 0)
	{
		new kioskid = AmNewsKiosk(playerid);
		if(kioskid == -1)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du befindest dich an keinem Zeittungsstand.");
		mysql_format(sqlHandle, string, sizeof(string), "DELETE FROM `newskiosk` WHERE `ID` = '%d'", NewsPaperKiosk[kioskid][dbID]);
		mysql_tquery(sqlHandle, string);
		NewsPaperKiosk[kioskid][SlotUsed] = 0;
		NewsPaperKiosk[kioskid][dbID] = -1;
		NewsPaperKiosk[kioskid][nkX] = 0.000;
		NewsPaperKiosk[kioskid][nkY] = 0.000;
		NewsPaperKiosk[kioskid][nkZ] = 0.000;
		NewsPaperKiosk[kioskid][ZeitungAmount] = 0;
		NewsPaperKiosk[kioskid][Ersteller] = -1;
		DestroyDynamic3DTextLabel(NewsPaperKiosk[kioskid][nkLabel]);
		NewsPaperKiosk[kioskid][nkLabel] = Text3D:INVALID_3DTEXT_ID;
		DestroyPickup(NewsPaperKiosk[kioskid][nkPickup]);
		format(string, sizeof(string),"Tu as supprimé le kiosque à journaux ID %i avec succès.", kioskid);
		return SendClientMessage(playerid, COLOR_YELLOW, string);
	}
	return 1;
}
CMD:getnewspaper(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid,5.0,NEWSPAPER_GET_POS))return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist {CD262F}nicht{FFFFFF} in der Nähe des Lagers.");
    if(GetPlayerScore(playerid) > 3)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du kannst keine Zeitung mehr ausliefern (max. Level 3).");
    if(ServerLager[it_lager_newspaper_id] == -1)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Es wurde keine Zeitung zum Verkauf ausgewählt.");
    if(ServerLager[it_lager_newspaper] == 0)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Es müssen erst wieder Zeitungen gedruckt werden.");
    new amount,_counter = 0, string[144], mainstring[512],_distancevar;
    if(sscanf(params,"i",amount))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/getnewspaper [Menge]");
    if(amount < 0 || amount > 10)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Du kannst nicht so viele Zeitungen tragen (Wert muss zwischen 1-10 liegen).");
    if(GetPVarInt(playerid, "NewsPaperAmount")+amount > 10)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Du kannst nicht so viele Zeitungen tragen (max. 10 Stück).");
	if(ServerLager[it_lager_newspaper] < amount)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}So viele Zeitungen wurden nicht gedruckt.");
	for(new i = 0; i < MAX_KIOSKS; i++)
	{
	    if(NewsPaperKiosk[i][SlotUsed] == 1)
		{
			_counter++;
		    _distancevar = Func_GetDistance(NEWSPAPER_GET_POS, NewsPaperKiosk[i][nkX], NewsPaperKiosk[i][nkY], NewsPaperKiosk[i][nkZ]);
		    format(string, sizeof(string),"[ID : %i] Journaux disponibles : %i | Distance : %i mètres",
			i, NewsPaperKiosk[i][ZeitungAmount], _distancevar);
		}
		else
		{
		    format(string, sizeof(string),"[ID : %i] Kiosque vide");
		}
	    strcat(mainstring, string);
	}
	if(_counter == 0)return SendClientMessage(playerid, COLOR_RED,"[Info]: {FFFFFF}Es existieren derzeit keine Zeitungsstände.");
	SetPVarInt(playerid, "NewsPaperAmount", amount);
	return ShowPlayerDialog(playerid, DIALOG_SELECT_ZEITUNGSSTAND, DIALOG_STYLE_LIST, "Zeitungsstand auswählen", mainstring, "Auswählen", "Abbrechen");
}
CMD:buynewspaper(playerid, params[])
{
	if(GetPVarInt(playerid,"LoggedIn") == 0)return NichtBerechtigt
    new kioskid = AmNewsKiosk(playerid), string[144];
	if(kioskid == -1)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du befindest dich an keinem Zeittungsstand.");
	if(NewsPaperKiosk[kioskid][ZeitungAmount] == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der Zeitungsstand muss erst beliefert werden.");
	FrakInfo[8][fiFrakKasse] += ServerLager[it_newspaper_price];
	GivePlayerMoneyEx(playerid,-ServerLager[it_newspaper_price]);
	SetPVarInt(playerid, "GetNewsPaper", 1);
	format(string, sizeof(string), "Tu as acheté un journal pour %i $ avec succès. Lis-le avec /readnewspaper.");
	return SendClientMessage(playerid, COLOR_YELLOW, string);
}