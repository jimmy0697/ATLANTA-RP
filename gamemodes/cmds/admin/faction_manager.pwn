CMD:givegangfight(playerid,params[])
{
	if(SpielerInfo[playerid][sFV] < 1 && SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new Zone, Fraktion, Punkte;
	if(sscanf(params,"iii",Zone,Fraktion,Punkte))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/giveganfight [ZonenID] [FraktionsID] [Punkte]");
	{
	    if(GangZoneInfo[Zone][gzFightTime] < 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}In diesem Gebiet wird zurzeit nicht gekämpft.");
	    if(GangZoneInfo[Zone][gzOwner] != Fraktion && GangZoneInfo[Zone][gzAttacker] != Fraktion)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Diese Fraktion nimmt nicht an diesem Gangfight teil.");
        new anzeige[8], string[128];
        if(Fraktion == GangZoneInfo[Zone][gzOwner])
		{
			GangZoneInfo[Zone][gzOwnerPunkte] += Punkte;
  			format(anzeige,sizeof(anzeige),"%d KILLS",GangZoneInfo[Zone][gzOwnerPunkte]);
		}
        else if(Fraktion == GangZoneInfo[Zone][gzAttacker])
		{
			GangZoneInfo[Zone][gzAttackerPunkte] += Punkte;
			format(anzeige,sizeof(anzeige),"%d KILLS",GangZoneInfo[Zone][gzAttackerPunkte]);
		}
		SendClientMessage(playerid,COLOR_SUPER,"[Info]: {FFFFFF}Punkte abgesendet.");
        format(string,sizeof(string),"[Gangfight]: {FFFFFF}La faction '%s' a reçu '+%d points' administrativement !",FrakName(Fraktion),Punkte);
        foreach(new i : Player)
		{
			if(SpielerInfo[i][sFraktion] == GangZoneInfo[Zone][gzOwner] || SpielerInfo[i][sFraktion] == GangZoneInfo[Zone][gzAttacker])
			{
			    SendClientMessage(i,COLOR_GANGFIGHT,string);
				PlayerTextDrawSetString(i, Gangfight[i][4], anzeige);
			}
		}
	}
	new log_admstring[128];
	format(log_admstring,sizeof(log_admstring),"%s %s a utilisé la commande '/givegangfight'. [%d]",AdminName(playerid),SpielerInfo[playerid][sName],GetPVarInt(playerid,"AdminDuty"));
	CreateServerLogEntry("ADMIN_LOG", log_admstring);
	return 1;
}

CMD:astaatskasse(playerid,params[])
{
	if(SpielerInfo[playerid][sFV] < 1 && SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new string[128], Betrag;
	format(string,sizeof(string),"[Info]: {FFFFFF}La caisse de l'État contient : $%d",GovVars[govKasse]);
	SendClientMessage(playerid,COLOR_INFO,string);
	if(sscanf(params,"i",Betrag))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/astaatskasse [Betrag]");
	if(Betrag < 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}In die Staatskasse kann administrativ nur ausgezahlt, jedoch nichts eingezahlt werden.");
	if(GovVars[govKasse]-Betrag < 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}In der Staatskasse befindet sich nicht so viel Geld.");
	format(string,sizeof(string),"[Info]: {FFFFFF}Tu as retiré $%d de la caisse de l'État.",Betrag);
	SendClientMessage(playerid,COLOR_RED,string);
	format(string,sizeof(string),"[Info]: {FFFFFF}%s %s a retiré $%d de la caisse de l'État.",AdminName(playerid),SpielerInfo[playerid][sName],Betrag);
	SendAdminMessage(COLOR_RED,string);
	format(string,sizeof(string),"%s %s a retiré $%d de la caisse de l'État.",AdminName(playerid),SpielerInfo[playerid][sName],Betrag);
	CreateServerLogEntry("STAATSKASSE_LOG", string);
	GovVars[govKasse] -= Betrag;
	new log_admstring[128];
	format(log_admstring,sizeof(log_admstring),"%s %s a utilisé la commande '/astaatskasse'. [%d]",AdminName(playerid),SpielerInfo[playerid][sName],GetPVarInt(playerid,"AdminDuty"));
	CreateServerLogEntry("ADMIN_LOG", log_admstring);
	return 1;
}


CMD:fraksperre(playerid,params[])
{
	if(SpielerInfo[playerid][sFV] < 1 && SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new pID;
	if(sscanf(params,"u",pID))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/fraksperre [SpielerID]");
	if(!IsPlayerConnectedEx(pID))return NichtOnline
	if(IsPlayerNPC(pID))return IstBot
	if(SpielerInfo[pID][sFrakSperre] > 0)
	{
	    SpielerInfo[pID][sFrakSperre] = 0;
	    new string[128];
	    format(string,sizeof(string),"[FrakSperre]: {FFFFFF}Tu as retiré le bannissement de faction de %s.",SpielerInfo[pID][sName]);
	    SendClientMessage(playerid,COLOR_SUPER,string);
	    format(string,sizeof(string),"[FrakSperre]: {FFFFFF}%s %s t'a retiré ton bannissement de faction.",AdminName(playerid),SpielerInfo[playerid][sName]);
	    SendClientMessage(pID,COLOR_SUPER,string);
	}
	else
	{
	    SpielerInfo[pID][sFrakSperre] = 1;
	    new string[128];
	    format(string,sizeof(string),"[FrakSperre]: {FFFFFF}Tu as appliqué un bannissement de faction à %s.",SpielerInfo[pID][sName]);
	    SendClientMessage(playerid,COLOR_RED,string);
	    format(string,sizeof(string),"[FrakSperre]: {FFFFFF}%s %s t'a donné un bannissement de faction.",AdminName(playerid),SpielerInfo[playerid][sName]);
	    SendClientMessage(pID,COLOR_RED,string);
	}
	new log_admstring[128];
	format(log_admstring,sizeof(log_admstring),"%s %s a utilisé la commande '/fraksperre'. [%d]",AdminName(playerid),SpielerInfo[playerid][sName],GetPVarInt(playerid,"AdminDuty"));
	CreateServerLogEntry("ADMIN_LOG", log_admstring);
	return 1;
}

CMD:givegangpunkte(playerid,params[])
{
	if(SpielerInfo[playerid][sFV] < 1 && SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new fID, Betrag;
	if(sscanf(params,"ii",fID,Betrag))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/givegangpunkte [FraktionsID] [Anzahl]");
	{
	    if(fID > 18 || fID < 9)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Nur kriminelle Organisationen können Materialien besitzen.");
	    FrakInfo[fID][fiGangpunkte] += Betrag;
		new string[128];
		format(string,sizeof(string),"[Info]: {FFFFFF}Tu as donné '%d' points de gang à la faction '%s'.",FrakName(fID),Betrag);
		SendClientMessage(playerid,COLOR_SUPER,string);
		format(string,sizeof(string),"[Info]: {FFFFFF}%s %s a donné '%d' points de gang à votre faction.",AdminName(playerid),SpielerInfo[playerid][sName],Betrag);
		foreach(new i : Player)
		{
		    if(SpielerInfo[i][sFraktion] == fID)
		    {
		        SendClientMessage(i,COLOR_SUPER,string);
		    }
		}
	}
	new log_admstring[128];
	format(log_admstring,sizeof(log_admstring),"%s %s a utilisé la commande '/givegangpunkte'. [%d]",AdminName(playerid),SpielerInfo[playerid][sName],GetPVarInt(playerid,"AdminDuty"));
	CreateServerLogEntry("ADMIN_LOG", log_admstring);
	return 1;
}

CMD:givefmoney(playerid,params[])
{
	if(SpielerInfo[playerid][sFV] < 1 && SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new fID, Betrag;
	if(sscanf(params,"ii",fID,Betrag))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/givefmoney [FraktionsID] [Anzahl]");
	{
	    if(fID > 20 || fID < 1)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Diese FraktionsID existiert nicht.");
	    FrakInfo[fID][fiFrakKasse] += Betrag;
		new string[128];
		format(string,sizeof(string),"[Info]: {FFFFFF}Tu as donné '%d' dollars à la faction '%s'.",FrakName(fID),Betrag);
		SendClientMessage(playerid,COLOR_SUPER,string);
		format(string,sizeof(string),"[Info]: {FFFFFF}%s %s a donné '%d' dollars à votre faction.",AdminName(playerid),SpielerInfo[playerid][sName],Betrag);
		foreach(new i : Player)
		{
		    if(SpielerInfo[i][sFraktion] == fID)
		    {
		        SendClientMessage(i,COLOR_SUPER,string);
		    }
		}
	}
	new log_admstring[128];
	format(log_admstring,sizeof(log_admstring),"%s %s a utilisé la commande '/givefmoney'. [%d]",AdminName(playerid),SpielerInfo[playerid][sName],GetPVarInt(playerid,"AdminDuty"));
	CreateServerLogEntry("ADMIN_LOG", log_admstring);
	return 1;
}

CMD:makefv(playerid, params[])
{
    new pID, fvid, string[128];
    if(SpielerInfo[playerid][sAdmin] < 4)return SendClientMessage(playerid, COLOR_RED, NoRights);
    if(sscanf(params, "ui", pID, fvid))return SendClientMessage(playerid, COLOR_BLUE, INFO_STRING"/Makefv [SpielerID/Name] [Rank]");
    if(!IsPlayerConnected(playerid))return SendClientMessage(playerid, COLOR_RED, "Der Spieler ist nicht online. (Benutze /offmakefv)");
    if(fvid >= 0 || fvid <= 2)
    {
        new fvname[30];
        if(fvid == 0){ fvname="Joueur normal";}
        else if(fvid == 1){ fvname ="Gestionnaire de faction";}
        else if(fvid == 2){ fvname ="Chef gestionnaire de faction";}
        SpielerInfo[pID][sFV] = fvid;
        format(string, sizeof(string), "%s %s a nommé %s au poste de %s.", AdminName(playerid), SpielerInfo[playerid][sName], SpielerInfo[pID][sName], fvname);
        SendAdminMessage(COLOR_RED, string);
        SaveAccount(playerid);
    }
    return 1;
}

CMD:offmakefv(playerid, params[]){
    new pID[24], admid, id;
    if (SpielerInfo[playerid][sAdmin] < 4) return SendClientMessage(playerid, COLOR_WHITE, ERROR_ADMIN);
    if (sscanf(params, "s[24]i", pID, admid)) return SendClientMessage(playerid, COLOR_BLUE, INFO_STRING" /Offmakefv [Name] [0-2]");
    if (!sscanf(pID, "u", id) && IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "[FRAKTIONSVERWALTUNG] {FFFFFF}Der Spieler ist zurzeit online. Benutze /makefv.");
    if(admid == 0 || admid == 1) {
        new str[24];
        format(str, sizeof(str), "%s", pID);
        SetPVarString(playerid, "MAKEADMINNAME", str);
        SetPVarInt(playerid, "MAKEADMINRANK", admid);
        new query[256];
        mysql_format(sqlHandle, query, sizeof(query), "UPDATE `Name` FROM `accounts` WHERE `Name` = '%s' LIMIT 1", pID);
    	mysql_tquery(sqlHandle, query);
        return 1;
    }
    return SendClientMessage(playerid, COLOR_RED, "[FRAKTIONSVERWALTUNG] {FFFFFF}Der Rank muss zwischen 0 und 1 liegen.");
}

CMD:makeleader(playerid,params[])
{
	if(SpielerInfo[playerid][sFV] < 1 && SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new pID, FrakID, string[265];
	if(sscanf(params,"ui",pID,FrakID))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/makeleader [SpielerID] [FraktionsID]");
    if(FrakID > 19 || FrakID < 0)return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/makeleader [SpielerID] [FraktionsID(1-19)]");
    if(!IsPlayerConnectedEx(pID))return NichtOnline
    if(GetPlayerScore(pID) < 2)return SendClientMessage(playerid,COLOR_RED,"Der angegebene Spieler hat nicht das zweite Level erreicht.");
    if(SpielerInfo[pID][sFrakSperre] == 1)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der einzuladene Spieler hat eine aktive Fraksperre.");
	if(GetPVarInt(pID,"CopDuty") == 1){DeletePVar(pID,"CopDuty"); CopDuty--;}
	if(GetPVarInt(pID,"FBIDuty") == 1){DeletePVar(pID,"FBIDuty"); FBIDuty--;}
	if(GetPVarInt(pID,"MedicDuty") == 1){DeletePVar(pID,"MedicDuty"); MedicDuty--;}
	if(GetPVarInt(pID,"FeuerwehrDuty") == 1){DeletePVar(pID,"FeuerwehrDuty"); MedicDuty--;}
	SetPlayerSkin(pID,mysql_GetInt("accounts", "SkinID", "Name", SpielerInfo[playerid][sName]));
	ResetPlayerWeapons(pID);
	SetPlayerArmour(pID,0);
	SetPlayerColor(pID,COLOR_WHITE);
	SetPlayerColor(playerid, GetPlayerColor(playerid) & 0xFFFFFF00);

	PlayerTextDrawDestroy(pID, Gangfight[pID][0]); PlayerTextDrawDestroy(pID, Gangfight[pID][1]); PlayerTextDrawDestroy(pID, Gangfight[pID][2]);
	PlayerTextDrawDestroy(pID, Gangfight[pID][3]); PlayerTextDrawDestroy(pID, Gangfight[pID][4]); PlayerTextDrawDestroy(pID, Gangfight[pID][5]); PlayerTextDrawDestroy(pID, Gangfight[pID][6]);

	if(FrakID != 0)
    {
		SpielerInfo[pID][sFraktion] = FrakID;
		SpielerInfo[pID][sLeader] = FrakID;
		SpielerInfo[pID][sRank] = 7;
		FrakInfo[FrakID][fiFrakMembers]++;
		if(FrakID == 1)
		{
		    format(string,265,"%s %s a assermenté le joueur %s en tant que Président des États-Unis de San Andreas.",AdminName(playerid),SpielerInfo[playerid][sName],SpielerInfo[pID][sName]);
			SendICPMsg(string);
		}
		else
		{
		    format(string,265,"%s %s a nommé le joueur %s leader de la faction '%s'.",AdminName(playerid),SpielerInfo[playerid][sName],SpielerInfo[pID][sName],FrakName(SpielerInfo[pID][sFraktion]));
			SendICPMsg(string);
			if(SpielerInfo[pID][sAchivLeader] < 1)
			{
				ShowAchievement(pID,"Devenir leader d'une faction","+ 300 EXP");
				GivePlayerEXP(pID,300);
				SpielerInfo[pID][sAchivLeader] = 1;
			}
		}
		format(string,265,"%s %s t'a nommé leader de la faction '%s'.",AdminName(playerid),SpielerInfo[playerid][sName],FrakName(SpielerInfo[pID][sFraktion]));
		SendClientMessage(pID,COLOR_INFO,string);

		SendClientMessage(pID,COLOR_INFO,"Hinweis: Benutze '/spawnchange' um dein Spawnpunkt zu ändern.");
		SendClientMessage(pID,COLOR_INFO,"Hinweis: Mit '/spawnme' kannst du dich einmalig neu spawnen lassen.");
		SetPVarInt(pID,"IamFreshLeader",1);
		SaveAccount(playerid);
	}
	else if(FrakID == 0)
	{
	    format(string,144,"%s %s a démis le joueur %s de sa faction. Il n'est plus leader.",AdminName(playerid),SpielerInfo[playerid][sName],SpielerInfo[pID][sName]);
		SendAdminMessage(COLOR_INFO,string);
		format(string,144,"%s %s t'a démis de ta faction. Tu n'es plus leader.",AdminName(playerid),SpielerInfo[playerid][sName]);
		SendClientMessage(pID,COLOR_INFO,string);
		SpielerInfo[pID][sFraktion] = 0;
		SpielerInfo[pID][sLeader] = 0;
		SpielerInfo[pID][sRank] = 0;
    	if(SpielerInfo[pID][sSpawn] == 1){SpielerInfo[pID][sSpawn] = 0;}
    	FrakInfo[FrakID][fiFrakMembers]--;
		SaveAccount(playerid);
	}
	SpawnPlayerEx(pID);
	new log_admstring[128];
	format(log_admstring,sizeof(log_admstring),"%s %s a utilisé la commande '/makeleader'. [%d]",AdminName(playerid),SpielerInfo[playerid][sName],GetPVarInt(playerid,"AdminDuty"));
	CreateServerLogEntry("ADMIN_LOG", log_admstring);
	return 1;
}

CMD:ainvite(playerid,params[])
{
	if(SpielerInfo[playerid][sFV] < 1 && SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new pID, FrakID, string[128];
	if(sscanf(params,"ui",pID,FrakID))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/ainvite [SpielerID] [FraktionsID]");
    if(!IsPlayerConnectedEx(pID))return NichtOnline
    if(GetPlayerScore(pID) < 2)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der angegebene Spieler hat nicht das zweite Level erreicht.");
    if(SpielerInfo[pID][sFrakSperre] == 1)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der einzuladene Spieler hat eine aktive Fraksperre.");
    FrakInfo[FrakID][fiFrakMembers]++;
    SpielerInfo[pID][sFraktion] = FrakID;
    SpielerInfo[pID][sRank] = 1;
    SpawnPlayerEx(pID);
	format(string,sizeof(string),"%s %s t'a invité dans la faction %s.",AdminName(playerid),SpielerInfo[playerid][sName],FrakName(FrakID));
	SendClientMessage(pID,COLOR_SUPER,string);
	format(string,sizeof(string),"Tu as invité %s dans la faction %s.",SpielerInfo[pID][sName],FrakName(FrakID));
	SendClientMessage(playerid,COLOR_SUPER,string);
	new log_admstring[128];
	format(log_admstring,sizeof(log_admstring),"%s %s a utilisé la commande '/ainvite'. [%d]",AdminName(playerid),SpielerInfo[playerid][sName],GetPVarInt(playerid,"AdminDuty"));
	CreateServerLogEntry("ADMIN_LOG", log_admstring);
	return 1;
}

CMD:auninvite(playerid,params[])
{
	if(SpielerInfo[playerid][sFV] < 1 && SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new pID, FrakID, string[128];
	if(sscanf(params,"ui",pID))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/auninvite [SpielerID]");
    if(!IsPlayerConnectedEx(pID))return NichtOnline
    if(pID == playerid && SpielerInfo[playerid][sRank] == 7)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du kannst dich als Leader nicht selber uninviten.");
	format(string,sizeof(string),"%s %s t'a exclu de ta faction.",AdminName(playerid),SpielerInfo[playerid][sName]);
	SendClientMessage(pID,COLOR_SUPER,string);
	format(string,sizeof(string),"Tu as exclu %s de sa faction.",SpielerInfo[pID][sName]);
	SendClientMessage(playerid,COLOR_SUPER,string);
 	FrakInfo[FrakID][fiFrakMembers]++;
    SpielerInfo[pID][sFraktion] = 0;
    SpielerInfo[pID][sRank] = 0;
    SpawnPlayerEx(pID);
    new log_admstring[128];
	format(log_admstring,sizeof(log_admstring),"%s %s a utilisé la commande '/auninvite'. [%d]",AdminName(playerid),SpielerInfo[playerid][sName],GetPVarInt(playerid,"AdminDuty"));
	CreateServerLogEntry("ADMIN_LOG", log_admstring);
	return 1;
}