public SchwarzmarktHack(playerid)
{
	if(!IsPlayerInRangeOfPoint(playerid,15.0,-1634.1162,-2241.6426,31.4766))
	{
		SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Tu es trop loin. Emilio a annulé l'opération !");
		TogglePlayerControllable(playerid, true);
		SetCameraBehindPlayer(playerid);
		DeletePVar(playerid,"Schwarzmarkt");
		return 1;
	}
	new wantedsWeg = random(GetPlayerWantedLevelEx(playerid));
	if(wantedsWeg == 0)
	{
	    SendClientMessage(playerid,COLOR_WHITE,"{FF0000}Emilio{FFFFFF} dit : Désolé mon frère, je n'ai vraiment rien pu faire pour toi.");
	}
	else if(wantedsWeg == GetPlayerWantedLevelEx(playerid))
	{
	    SendClientMessage(playerid,COLOR_WHITE,"{FF0000}Emilio{FFFFFF} dit : Tous tes wanted ont disparu, frérot. Je gère toujours.");
	}
	else
	{
	    new string[128];
	    format(string,sizeof(string),"{FF0000}Emilio{FFFFFF} sagt: Bin durch, ich konnte dir %d deiner Wanteds entfernen.",wantedsWeg);
	    SendClientMessage(playerid,COLOR_WHITE,string);
	}
	SetPlayerWantedLevelEx(playerid, GetPlayerWantedLevelEx(playerid) - wantedsWeg);
	SetTimerEx("SchwarzmarktHackGemacht",1800000,false,"i",playerid);
	SetPVarInt(playerid,"SchwarzmarktHackGemacht",1);
 	TogglePlayerControllable(playerid, true);
	SetCameraBehindPlayer(playerid);
	DeletePVar(playerid,"Schwarzmarkt");
	return 1;
}

public SchwarzmarktHackGemacht(playerid)
{
	DeletePVar(playerid,"SchwarzmarktHackGemacht");
	return 1;
}