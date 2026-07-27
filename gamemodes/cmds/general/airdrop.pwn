COMMAND:airdrop(playerid, params[]) {
    if(!AirdropData[airActive]) return SendClientMessage(playerid, -1, "{CCFF33}AIRDROP: {FFFFFF}Tu ne te trouves pas près d'un colis aérien.");
    if(GetPVarInt(playerid, "AIRDROP_PICKING")) return SendClientMessage(playerid, -1, "{CCFF33}AIRDROP: {FFFFFF}Tu es déjà en train de ramasser le colis.");
	if(IsPlayerInRangeOfPoint(playerid, 7.5, AirdropData[rayX], AirdropData[rayY], AirdropData[rayZ] - 6.5)) {
        ApplyAnimation(playerid, "MISC", "pickup_box", 2.5, false, false, false, false, 2000);             
        GameTextForPlayer(playerid, "~b~~h~~h~~h~Ramassage...", 1500, 3);
        SetTimerEx("OnPlayerPickupAirdrop", 1000, false, "i", playerid);
        SetPVarInt(playerid, "AIRDROP_PICKING", 1);
    } else {
        SendClientMessage(playerid, -1, "{CCFF33}AIRDROP: {FFFFFF}Tu ne te trouves pas près d'un colis aérien.");
    }
    return 1;
}

COMMAND:gotoairdrop(playerid, params[]) {
    if(SpielerInfo[playerid][sAdmin] < 3)return NichtBerechtigt
    if(!AirdropData[airActive]) return SendClientMessage(playerid, COLOR_GREY, "Aktuell befindet sich kein Airdrop in San Andreas!");
	new Float:x, Float:y, Float:z;
	GetDynamicObjectPos(AirdropData[airObject], x, y, z);

    SetPlayerPos(playerid, x, y + 2.5, z);
    return 1;
}

COMMAND:setairdrop(playerid, params[]) {
    if(SpielerInfo[playerid][sAdmin] < 3)return NichtBerechtigt
    SendClientMessage(playerid, -1, "Colis aérien déclenché / supprimé !");
    if(!AirdropData[airActive]) GetNextAirdrop();
    else RemoveAirdrop();
    return 1;
}

COMMAND:airdroppos(playerid, params[]) {
    if(SpielerInfo[playerid][sAdmin] < 3)return NichtBerechtigt
    new query[128], Float:tempPos[3];
    GetPlayerPos(playerid, tempPos[0], tempPos[1], tempPos[2]);
    mysql_format(sqlHandle, query, sizeof(query), "INSERT INTO `airdroppos` (`x`, `y`) VALUES (%f, %f)", tempPos[0], tempPos[1]);
    mysql_tquery(sqlHandle, query);

    SendClientMessage(playerid, -1, "Position du colis aérien enregistrée.");
    return 1;
}