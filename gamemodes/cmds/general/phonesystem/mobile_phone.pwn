COMMAND:togphone(playerid, params[]) {
    new string[128];
    if(SpielerInfo[playerid][sHandy] < 1)return SendClientMessage(playerid, COLOR_RED, "Tu ne possèdes pas de téléphone.");
    if(SpielerInfo[playerid][sHandyAkku] <= 0.0)return SendClientMessage(playerid, COLOR_RED, "Dein Akku ist leer.");
    if(SpielerInfo[playerid][sHandyState] == 0) {
        SpielerInfo[playerid][sHandyState] = 1;
        SendClientMessage(playerid, COLOR_GREEN,"Handy an.");
        format(string,sizeof(string),"** %s sort son %s **", SpielerInfo[playerid][sName], HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname]);
        ProxDetector(10.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
        PlayerTextDrawShow(playerid,HandyInfodraw[playerid]);
        UpdateHandyTextdraw(playerid);
        AkkuTimer[playerid] = SetTimerEx("HandyAkku",120000,true,"i",playerid);
    } else if(SpielerInfo[playerid][sHandyState] == 1) {
        StopAudioStreamForPlayer(playerid);
        SpielerInfo[playerid][sHandyState] = 0;
        SendClientMessage(playerid, COLOR_GREEN,"Handy aus.");
        format(string,sizeof(string),"** %s range son %s dans sa poche **", SpielerInfo[playerid][sName], HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname]);
        ProxDetector(10.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
        PlayerTextDrawHide(playerid,HandyInfodraw[playerid]);
        KillTimer(AkkuTimer[playerid]);
        if(SpielerInfo[playerid][sCallHim] == 1) {
            new pID = SpielerInfo[playerid][sCall];
            SpielerInfo[playerid][sCallHim] = 0;
            SpielerInfo[pID][sCallHim] = 0;
            SpielerInfo[pID][sCall] = -1;
            SpielerInfo[playerid][sCall] = -1;
            SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
            SetPlayerSpecialAction(pID,SPECIAL_ACTION_STOPUSECELLPHONE);
            SendClientMessage(playerid, COLOR_YELLOW,"Du hast das Gespräch beendet.");
            SendClientMessage(pID, COLOR_YELLOW,"Der Gesprächspartner hat aufgelegt.");
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

COMMAND:handy(playerid,params[]) {
	new string[128];
	if(SpielerInfo[playerid][sHandy] < 1)return SendClientMessage(playerid, COLOR_GREY, "Tu ne possèdes pas de téléphone.");
	if(SpielerInfo[playerid][sHandyState] == 0)return SendClientMessage(playerid, COLOR_GREY, "Ton téléphone est éteint.");
	format(string,sizeof(string),"** %s sort son %s **",SpielerInfo[playerid][sName], HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname]);
	ProxDetector(10.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	ShowPlayerDialog(playerid, DIALOG_HANDY_MENU, DIALOG_STYLE_LIST, HandyInfo[SpielerInfo[playerid][sHandyDevice]][Handyname],"Anrufen\nSMS\nService List","Auswählen","Abbrechen");
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
	GiveHandy(playerid);
	return 1;
}
/*
COMMAND:call(playerid,params[]) {
    #pragma unused params
	if(ImTutorial[playerid] != 0)return SendClientMessage(playerid,GRAU,"Tu ne peux pas utiliser de commandes pendant le tutoriel.");
	if(GetPVarInt(playerid,"Eingeloggt") == 0)return SendClientMessage(playerid,GRAU,"Tu n'es pas connecté !");
	if(Spieler[playerid][pAWAYFROMKEYBOARD] == 1)return SendClientMessage(playerid,WRONGCMD,"Tu es en mode AFK et ne peux donc pas utiliser de commandes."),SendClientMessage(playerid,WRONGCMD,"UTILISE : /back");
    if(Spieler[playerid][pInPrison] == 1)return SendClientMessage(playerid,GRAU,"Tu es en prison.");
	if(Spieler[playerid][pFriedhof] == 1)return SendClientMessage(playerid,GRAU,"Tu es mort.");
	if(Spieler[playerid][pDeath] == 1)return SendClientMessage(playerid,GRAU,"Tu es blessé.");
	new string[128];
	if(Spieler[playerid][pHandy] == 0)return SendClientMessage(playerid,GRAU,"Tu ne possèdes pas de téléphone.");
	if(Spieler[playerid][pHandystate] == 0)return SendClientMessage(playerid,GRAU,"Ton téléphone est éteint.");
	if(ReturnHempfangRate(playerid) == -1)return SendClientMessage(playerid,GRAU,"Pas de réseau.");
	if(Spieler[playerid][pMuted] == 1)return SendClientMessage(playerid,GRAU,"Tu es muet et ne peux donc appeler personne.");
	if(Spieler[playerid][pHandyFlat] == 0)
	{
		if(Spieler[playerid][pHandyCoins] == 0)return SendClientMessage(playerid,GRAU,"Crédit insuffisant !");
	}
	if(Spieler[playerid][pCallHim] == 1)return SendClientMessage(playerid,GRAU,"Tu es déjà en communication.");
	ShowPlayerDialog(playerid,DIALOG_HANDY_CALL,DIALOG_STYLE_INPUT,HandyInfo[Spieler[playerid][sHandyDevice]][Handyname],"Gib nun bitte die Nummer des Spielers ein,denn du anrufen willst!","Anrufen","Zur?ck");
    format(string,sizeof(string),"** %s sort son %s **",SpielerInfo[playerid][sName],HandyInfo[Spieler[playerid][sHandyDevice]][Handyname]);
	ProxDetector(10.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	return 1;
}

COMMAND:sms(playerid,params[])
{
    #pragma unused params
	if(ImTutorial[playerid] != 0)return SendClientMessage(playerid,GRAU,"Tu ne peux pas utiliser de commandes pendant le tutoriel.");
	if(GetPVarInt(playerid,"Eingeloggt") == 0)return SendClientMessage(playerid,GRAU,"Tu n'es pas connecté !");
	if(Spieler[playerid][pAWAYFROMKEYBOARD] == 1)return SendClientMessage(playerid,WRONGCMD,"Tu es en mode AFK et ne peux donc pas utiliser de commandes."),SendClientMessage(playerid,WRONGCMD,"UTILISE : /back");
    if(Spieler[playerid][pInPrison] == 1)return SendClientMessage(playerid,GRAU,"Tu es en prison.");
	if(Spieler[playerid][pFriedhof] == 1)return SendClientMessage(playerid,GRAU,"Tu es mort.");
	if(Spieler[playerid][pDeath] == 1)return SendClientMessage(playerid,GRAU,"Tu es blessé.");
	new string[128];
	if(Spieler[playerid][pHandy] == 0)return SendClientMessage(playerid,GRAU,"Tu ne possèdes pas de téléphone.");
	if(Spieler[playerid][pHandystate] == 0)return SendClientMessage(playerid,GRAU,"Ton téléphone est éteint.");
	if(ReturnHempfangRate(playerid) == -1)return SendClientMessage(playerid,GRAU,"Pas de réseau.");
	if(Spieler[playerid][pMuted] == 1)return SendClientMessage(playerid,GRAU,"Tu es muet et ne peux donc appeler personne.");
    if(Spieler[playerid][pHandyFlat] == 0)
	{
		if(Spieler[playerid][pHandyCoins] == 0)return SendClientMessage(playerid,GRAU,"Crédit insuffisant !");
	}
	if(Spieler[playerid][pCallHim] == 1)return SendClientMessage(playerid,GRAU,"Tu es déjà en communication.");
	ShowPlayerDialog(playerid,DIALOG_HANDY_SMS_eins,DIALOG_STYLE_INPUT,HandyInfo[Spieler[playerid][pHandy]][Handyname],"Gib nun bitte die Nummer des Spielers ein,denn du eine SMS schreiben willst.","Weiter","Zur?ck");
	format(string,sizeof(string),"** %s sort son %s **",SpielerInfo[playerid][sName],HandyInfo[Spieler[playerid][pHandy]][Handyname]);
	ProxDetector(10.0, playerid, string, 0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA,0xC2A2DAAA);
	return 1;
}*/