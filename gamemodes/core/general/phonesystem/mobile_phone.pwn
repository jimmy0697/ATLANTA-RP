stock MobilePhone_PlayerConnect(playerid) {

    HandyInfodraw[playerid] = CreatePlayerTextDraw(playerid,110,420,"_");
    PlayerTextDrawFont(playerid,HandyInfodraw[playerid],TEXT_DRAW_FONT_1);
    PlayerTextDrawAlignment(playerid,HandyInfodraw[playerid],TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawLetterSize(playerid,HandyInfodraw[playerid],0.350000,0.488880);
	PlayerTextDrawSetProportional(playerid,HandyInfodraw[playerid],true);
	PlayerTextDrawSetShadow(playerid,HandyInfodraw[playerid],1);
	
	HandyCalldraw[playerid] = CreatePlayerTextDraw(playerid,125,415,"_");
    PlayerTextDrawFont(playerid,HandyCalldraw[playerid],TEXT_DRAW_FONT_1);
    PlayerTextDrawAlignment(playerid,HandyCalldraw[playerid],TEXT_DRAW_ALIGN_LEFT);
	PlayerTextDrawLetterSize(playerid,HandyCalldraw[playerid],0.350000,0.488880);
	PlayerTextDrawSetProportional(playerid,HandyCalldraw[playerid],true);
	PlayerTextDrawSetShadow(playerid,HandyCalldraw[playerid],1);
    return 1;
}

stock MobilePhone_PlayerDisconnect(playerid) {

    PlayerTextDrawDestroy(playerid,HandyInfodraw[playerid]);
    PlayerTextDrawDestroy(playerid,HandyCalldraw[playerid]);
    return 1;
}

stock UpdateHandyTextdraw(playerid)
{
	new string[128];
	if(!SpielerInfo[playerid][sHandyFlat])
	{
		switch(ReturnHempfangRate(playerid))
		{
			case -1:
			{
				format(string,sizeof(string),"%s  Batterie:%.1f  %iCoins  Réseau:Aucun",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku],
                SpielerInfo[playerid][sGuthaben]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 1:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  %iCoins  Réseau:~g~IIIIII",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku],
                SpielerInfo[playerid][sGuthaben]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 2:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  %iCoins  Réseau:~g~IIIII",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku],
                SpielerInfo[playerid][sGuthaben]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 3:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  %iCoins  Réseau:~g~IIII",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku],
                SpielerInfo[playerid][sGuthaben]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 4:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  %iCoins  Réseau:~g~III",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku],
                SpielerInfo[playerid][sGuthaben]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 5:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  %iCoins  Réseau:~g~II",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku],
                SpielerInfo[playerid][sGuthaben]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 6:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  %iCoins  Réseau:~g~I",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku],
                SpielerInfo[playerid][sGuthaben]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
		}
    }
    else
    {
	    switch(ReturnHempfangRate(playerid))
		{
			case -1:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  Réseau:Aucun  Forfait illimité",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 1:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  Réseau:~g~IIIIII~w~  Forfait illimité",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 2:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  Réseau:~g~IIIII~w~  Forfait illimité",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 3:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  Réseau:~g~IIII~w~  Forfait illimité",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 4:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  Réseau:~g~III~w~  Forfait illimité",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 5:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  Réseau:~g~II~w~  Forfait illimité",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
			case 6:
			{
			    format(string,sizeof(string),"%s  Batterie:%.1f  Réseau:~g~I~w~  Forfait illimité",
                HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],
                SpielerInfo[playerid][sHandyAkku]);
			    PlayerTextDrawSetString(playerid,HandyInfodraw[playerid],string);
			}
		}
    }
	return 1;
}

stock GiveHandy(playerid)
{
	switch(SpielerInfo[playerid][sHandyDevice])
	{
		case 1: SetPlayerAttachedObject(playerid,8,18866,6,0.106000,-0.019000,0.028000,85.300003,-175.599975,-3.300000,1.000000,1.000000,1.000000);
		case 2: SetPlayerAttachedObject(playerid,8,18871,6,0.106000,-0.019000,0.028000,85.300003,-175.599975,-3.300000,1.000000,1.000000,1.000000);
		case 3: SetPlayerAttachedObject(playerid,8,18872,6,0.106000,-0.019000,0.028000,85.300003,-175.599975,-3.300000,1.000000,1.000000,1.000000);
		case 4: SetPlayerAttachedObject(playerid,8,18870,6,0.106000,-0.019000,0.028000,85.300003,-175.599975,-3.300000,1.000000,1.000000,1.000000);
	}
	return 1;
}

forward HandyAkku(playerid);
public HandyAkku(playerid)
{
	SpielerInfo[playerid][sHandyAkku] -= HandyInfo[SpielerInfo[playerid][sHandyDevice]][HandyVerbrauch];
	if(SpielerInfo[playerid][sHandyAkku] <= 0.0)
	{
		StopAudioStreamForPlayer(playerid);
		PlayerTextDrawHide(playerid, HandyInfodraw[playerid]);
		KillTimer(AkkuTimer[playerid]);
		SpielerInfo[playerid][sHandyState] = 0;
		SpielerInfo[playerid][sHandyAkku] = 0.0;
		if(SpielerInfo[playerid][sCallHim]) {
			new pID = SpielerInfo[playerid][sCall];
			SpielerInfo[playerid][sCallHim] = 0;
			SpielerInfo[pID][sCallHim] = 0;
			SpielerInfo[pID][sCall] = -1;
			SpielerInfo[playerid][sCall] = -1;
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
			SetPlayerSpecialAction(pID,SPECIAL_ACTION_STOPUSECELLPHONE);
			SendClientMessage(playerid, COLOR_YELLOW,"Tu as raccroché.");
			SendClientMessage(pID, COLOR_YELLOW, "Der Gesprächspartner hat aufgelegt.");
			PlayerTextDrawHide(playerid,HandyCalldraw[playerid]);
			PlayerTextDrawHide(pID,HandyCalldraw[pID]);
			PlayerPlaySound(playerid,1077,0.0,0.0,0.0);
			PlayerPlaySound(pID,1077,0.0,0.0,0.0);
			RemovePlayerAttachedObject(pID,8);
			RemovePlayerAttachedObject(playerid,8);
		}
	}
	return 1;
}

MobilePhone_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) {

	switch(dialogid) {
		case DIALOG_HANDY_CALL: {
			new time = ReturnHempfangRate(playerid),savetime;
			if(response == 0) {
			    ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
			    return 1;
		    }
		    if(response == 1)
		    {
			    if(!strlen(inputtext))
			    {
					return ShowPlayerDialog(playerid,DIALOG_HANDY_CALL,DIALOG_STYLE_INPUT,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				}
				if(!IsNumeric(inputtext))
				{
					return ShowPlayerDialog(playerid,DIALOG_HANDY_CALL,DIALOG_STYLE_INPUT,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"N'entre que des chiffres !\nSaisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				}
				PlayerPlaySound(playerid,3600,0.0,0.0,0.0);
			    SendClientMessage(playerid, COLOR_GREY, "Verbinde...");
				if(time == -1) {
					savetime = 10;
				} else {
					savetime = ReturnHempfangRate(playerid);
				}
				SpielerInfo[playerid][sCallEntry] = strval(inputtext);
				SetTimerEx("HandySendConnect", savetime*1000, false, "ii", playerid, 0);
				return 1;
			}
			return 1;
		}
		case DIALOG_HANDY_MENU: {
			new string[128];
		    if(!response) {
			    format(string,sizeof(string),"** %s range son %s dans sa poche **", SpielerInfo[playerid][sName], HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname]);
				ProxDetector(10.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
				SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
				RemovePlayerAttachedObject(playerid,8);
				return 1;
		    }
			switch(listitem) {
				case 0: {
					SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid,8);
					if(SpielerInfo[playerid][sMuted] == 1)return SendClientMessage(playerid,COLOR_GREY,"Tu es muet et ne peux donc appeler personne.");
					if(ReturnHempfangRate(playerid) == -1) {
						ShowPlayerDialog(playerid, DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
						return SendClientMessage(playerid, COLOR_GREY, "Pas de réseau.");
					}
					if(!SpielerInfo[playerid][sHandyFlat]) {
						if(!SpielerInfo[playerid][sGuthaben]) {
							ShowPlayerDialog(playerid, DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
							return SendClientMessage(playerid,COLOR_GREY,"Crédit insuffisant !");
						}
					}
					if(SpielerInfo[playerid][sCallHim]) {
						ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
						return SendClientMessage(playerid,COLOR_GREY,"Tu es déjà en communication.");
					}
					return ShowPlayerDialog(playerid,DIALOG_HANDY_CALL,DIALOG_STYLE_INPUT,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				}
				case 1: {
					SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid,8);
					if(SpielerInfo[playerid][sMuted] == 1)return SendClientMessage(playerid,COLOR_GREY,"Tu es muet et ne peux donc envoyer de SMS à personne.");
					if(ReturnHempfangRate(playerid) == -1) {
						ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
						return SendClientMessage(playerid,COLOR_GREY,"Pas de réseau.");
					}
					if(!SpielerInfo[playerid][sHandyFlat]) {
						if(!SpielerInfo[playerid][sGuthaben]) {
							ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
							return SendClientMessage(playerid,COLOR_GREY,"Crédit insuffisant !");
						}
					}
					return ShowPlayerDialog(playerid,DIALOG_HANDY_SMS,DIALOG_STYLE_INPUT,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Saisis le numéro du joueur à qui envoyer un SMS.","Continuer","Retour");
				}
				case 2: {
					SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
					RemovePlayerAttachedObject(playerid,8);
					if(ReturnHempfangRate(playerid) == -1) {
						ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
						return SendClientMessage(playerid,COLOR_GREY,"Pas de réseau.");
					}
					return ShowPlayerDialog(playerid,DIALOG_SERVICE,DIALOG_STYLE_LIST,"{007DFF}"SERV_NAME"{FFFFFF} - Service","Polizei\nFBI\nFeuerwehr\nNotarzt\nOrdnungsamt (auch Mechaniker)","Weiter","Abbrechen");

				}
				case 3: {
					return SendClientMessage(playerid, COLOR_ERRORTEXT, "ACTUELLEMENT INDISPONIBLE");
				}
			}
		}
	}
	return 1;
}

stock IsHandyNummerEnable(phonenumber) {
	foreach(new i : Player) {
	 	if(IsPlayerConnected(i) && !IsPlayerNPC(i)) {
			if(SpielerInfo[i][sHandy] == phonenumber && phonenumber != 0)
			return i;
		}
	}
	return -1;
}

forward HandySendConnect(playerid,count);
public HandySendConnect(playerid,count)
{
	new string[154], nummer = SpielerInfo[playerid][sCallEntry];
	switch(count) {
		case 0: { //CALL
    		if(ReturnHempfangRate(playerid) == -1) {
				ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandy]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
				return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			if(nummer == 911 || nummer == 110) {
				return ShowPlayerDialog(playerid,DIALOG_SERVICE,DIALOG_STYLE_LIST,"{007DFF}"SERV_NAME"{FFFFFF} - Service","Polizei\nFBI\nFeuerwehr\nNotarzt\nOrdnungsamt (auch Mechaniker)","Weiter","Abbrechen");
			}
			if(IsHandyNummerEnable(nummer) == -1) {
				ShowPlayerDialog(playerid,DIALOG_HANDY_CALL,DIALOG_STYLE_INPUT,HandyInfo[SpielerInfo[playerid][sHandy]][Handyname],"Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
	    		return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			new pID = IsHandyNummerEnable(nummer);
			if(ReturnHempfangRate(pID) == -1) {
				ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandy]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
				return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			if(SpielerInfo[playerid][sCall] == SpielerInfo[playerid][sHandy]) {
				ShowPlayerDialog(playerid,DIALOG_HANDY_CALL,DIALOG_STYLE_INPUT,HandyInfo[SpielerInfo[playerid][sHandy]][Handyname],"Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			if(SpielerInfo[pID][sCallHim] == 1) {
				ShowPlayerDialog(playerid,DIALOG_HANDY_CALL,DIALOG_STYLE_INPUT,HandyInfo[SpielerInfo[playerid][sHandy]][Handyname],"Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			if(SpielerInfo[pID][sHandyState] == 0) {
				ShowPlayerDialog(playerid,DIALOG_HANDY_CALL,DIALOG_STYLE_INPUT,HandyInfo[SpielerInfo[playerid][sHandy]][Handyname],"Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			SpielerInfo[playerid][sCall] = pID;
			SpielerInfo[pID][sCall] = playerid;
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
			GiveHandy(playerid);
			PlayerPlaySound(pID,1076,0.0,0.0,0.0);
			format(string,sizeof(string),"** %s %s commence à sonner **",GetName(pID),HandyInfo[SpielerInfo[pID][sHandy]][Handyname]);
			ProxDetector(10.0, pID, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
			format(string,sizeof(string),"Tu appelles %s...",GetName(pID));
			PlayerTextDrawSetString(playerid,HandyCalldraw[playerid],string);
			PlayerTextDrawShow(playerid,HandyCalldraw[playerid]);
			format(string,sizeof(string),"Tu appelles %s...",GetName(pID));
			SendClientMessage(playerid,COLOR_YELLOW,string);
			format(string,sizeof(string),"%s t'appelle. Tape '/pickup' pour décrocher...",GetName(playerid));
			SendClientMessage(pID, COLOR_WHITE,string);
			format(string,sizeof(string),"%s t'appelle...",GetName(playerid));
			PlayerTextDrawSetString(pID,HandyCalldraw[pID],string);
			PlayerTextDrawShow(pID,HandyCalldraw[pID]);
			if(SpielerInfo[playerid][sGuthaben] != 0 && SpielerInfo[playerid][sHandyFlat] == 0)
			{
				SpielerInfo[playerid][sGuthaben]--;
				UpdateHandyTextdraw(playerid);
			}
			return 1;
		}
		case 1: { //sms dialog 2
			if(ReturnHempfangRate(playerid) == -1) {
				ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandy]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
				return SendClientMessage(playerid,COLOR_GREY,"Senden fehlgeschlagen");
			}
			if(IsHandyNummerEnable(nummer) == -1) {
				ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandy]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
				return SendClientMessage(playerid,COLOR_GREY,"Senden fehlgeschlagen");
			}
			new pID = IsHandyNummerEnable(nummer);
			if(SpielerInfo[pID][sHandyState] == 0) {
				ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandy]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");
				return SendClientMessage(playerid,COLOR_GREY,"Senden fehlgeschlagen");
			}
			SendClientMessage(playerid, COLOR_WHITE, "Nachricht abgesendet.");
			format(string,sizeof(string),"SMS : %s, Destinataire : %s (%i)",SpielerInfo[playerid][sSMSText],GetName(pID),SpielerInfo[pID][sHandy]);
			SendClientMessage(playerid, COLOR_YELLOW,string);
			format(string,sizeof(string),"SMS : %s, Expéditeur : %s (%i)",SpielerInfo[playerid][sSMSText],GetName(playerid),SpielerInfo[playerid][sHandy]);
			SendClientMessage(pID,COLOR_YELLOW,string);
			PlayerPlaySound(pID,1137,0.0,0.0,0.0);
			SpielerInfo[playerid][sCall] = -1;
			ShowPlayerDialog(playerid,DIALOG_HANDY_MENU,DIALOG_STYLE_LIST,HandyInfo[SpielerInfo[playerid][sHandy]][Handyname],"Anrufen\nSMS\nService List\nMusik","Auswählen","Abbrechen");

			if(SpielerInfo[playerid][sGuthaben] != 0 && SpielerInfo[playerid][sHandyFlat] == 0)
			{
				SpielerInfo[playerid][sGuthaben]--;
				UpdateHandyTextdraw(playerid);
			}
			return 1;
		}
		case 2: {
			if(IsHandyNummerEnable(nummer) == -1) {
				ShowPlayerDialog(playerid,DIALOG_TELEFONZELLE_CALL,DIALOG_STYLE_INPUT,"Téléphone","Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			new pID = IsHandyNummerEnable(nummer);
			if(ReturnHempfangRate(pID) == -1) {
				ShowPlayerDialog(playerid,DIALOG_TELEFONZELLE_CALL,DIALOG_STYLE_INPUT,"Téléphone","Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			if(SpielerInfo[playerid][sCall] == SpielerInfo[playerid][sHandy]) {
				ShowPlayerDialog(playerid,DIALOG_TELEFONZELLE_CALL,DIALOG_STYLE_INPUT,"Téléphone","Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			if(SpielerInfo[pID][sCallHim] == 1) {
				ShowPlayerDialog(playerid,DIALOG_TELEFONZELLE_CALL,DIALOG_STYLE_INPUT,"Téléphone","Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			if(SpielerInfo[pID][sHandyState] == 0) {
				ShowPlayerDialog(playerid,DIALOG_TELEFONZELLE_CALL,DIALOG_STYLE_INPUT,"Téléphone","Saisis le numéro du joueur que tu souhaites appeler !","Appeler","Retour");
				return SendClientMessage(playerid,COLOR_GREY,"Anruf fehlgeschlagen");
			}
			SpielerInfo[playerid][sCall] = pID;
			SpielerInfo[pID][sCall] = playerid;
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
			PlayerPlaySound(pID,1076,0.0,0.0,0.0);
			format(string,sizeof(string),"** %s %s commence à sonner **",GetName(pID),HandyInfo[SpielerInfo[pID][sHandy]][Handyname]);
			ProxDetector(10.0, pID, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
			format(string,sizeof(string),"Tu appelles %s...",GetName(pID));
			PlayerTextDrawSetString(playerid,HandyCalldraw[playerid],string);
			PlayerTextDrawShow(playerid,HandyCalldraw[playerid]);
			format(string,sizeof(string),"Tu appelles %s...",GetName(pID));
			SendClientMessage(playerid,COLOR_YELLOW,string);
			SendClientMessage(pID, COLOR_WHITE, "Unbekannter ruft an Tippe '/pickup' um abzuheben...");
			PlayerTextDrawSetString(pID,HandyCalldraw[pID],"Unbekannter ruft an...");
			PlayerTextDrawShow(pID,HandyCalldraw[pID]);
			return 1;
		}
	}
	return printf("ERREUR : fonction HandySendConnect(playerid=%i,count=%i) non reconnue !",playerid,count);
}