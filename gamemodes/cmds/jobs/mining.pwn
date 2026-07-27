CMD:mineveh(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, 0xE88732FF, "UTILISE: {FFFFFF}/mineveh [ores/take]");
    if(!strcmp(params, "ores", true)) {
        new vehicleid = GetNearestVehicleEx(playerid);
        if(!IsValidVehicle(vehicleid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves à côté d'aucun véhicule.");
        if(!Vehicle_IsMiningVehicle(vehicleid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Ce véhicule n'est pas adapté.");
        new string[196], title[32];
        format(string, sizeof(string), "Nom\tQuantité\tValeur\n");
        for(new i; i < MAX_ORE_TYPES; i++) format(string, sizeof(string), "%s%s\t%d\t{2ECC71}$%d\n", string, OreData[i][oName], LoadedOres[vehicleid][i], Vehicle_GetOreValueByType(vehicleid, i));
        format(title, sizeof(title), "Minerais chargés {E74C3C}(%d/%d)", Vehicle_LoadedOres(vehicleid), MINING_VEHICLE_LIMIT);
        ShowPlayerDialog(playerid, DIALOG_ORE_INFO, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Schließen", "");
    }else if(!strcmp(params, "take")) {
        if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu te trouves dans un véhicule.");
        if(MiningVein[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu es en train d'extraire un minerai.");
        if(CarryingOre[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu portes déjà un minerai.");
        new id = GetNearestVehicleEx(playerid);
        if(!IsValidVehicle(id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves à côté d'aucun véhicule.");
        if(!Vehicle_IsMiningVehicle(id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Ce véhicule n'est pas adapté.");
        new Float: x, Float: y, Float: z;
        GetVehicleBoot(id, x, y, z);
        if(GetPlayerDistanceFromPoint(playerid, x, y, z) > 3.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu n'es pas près du coffre.");
        new string[196], title[32];
        format(string, sizeof(string), "Nom\tQuantité\n");
        for(new i; i < MAX_ORE_TYPES; i++) format(string, sizeof(string), "%s%s\t%d\n", string, OreData[i][oName], LoadedOres[id][i]);
        format(title, sizeof(title), "Minerais {E74C3C}(%d/%d)", Vehicle_LoadedOres(id), MINING_VEHICLE_LIMIT);
        ShowPlayerDialog(playerid, DIALOG_ORE_TAKE, DIALOG_STYLE_TABLIST_HEADERS, title, string, "Nehmen", "Schließen");
    }
 
    return 1;
}

CMD:mineinfo(playerid, params[]) {
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, 817.1186, 856.8585, 12.7891)) return SendClientMessage(playerid, -1, "ERREUR: {FFFFFF}Tu ne te trouves pas à la mine de San Andreas (/gps).");
    new mainstring[1500];
    strcat(mainstring, "{FFFFFF}Bienvenue à la {E74C3C}mine de San Andreas{FFFFFF} !\n");
    strcat(mainstring, "{FFFFFF}Pour extraire un minerai, tu as besoin d'un véhicule adapté, qu'il s'agisse\n");
    strcat(mainstring, "{FFFFFF}d'un véhicule personnel, de faction ou de groupe. Les modèles suivants peuvent être\n");
    strcat(mainstring, "{FFFFFF}utilisés : {E74C3C}Mule{FFFFFF}, {E74C3C}Flatbed{FFFFFF}, {E74C3C}Yankee{FFFFFF}, {E74C3C}Boxville{FFFFFF} ou {E74C3C}Benson{FFFFFF} !\n");
    strcat(mainstring, "{FFFFFF}Conduis ton véhicule dans la mine et commence à extraire des minerais. Tu devras ensuite\n");
    strcat(mainstring, "{FFFFFF}les charger dans ton véhicule. Tu pourras ensuite les vendre à un négociant en minerai.\n");
    strcat(mainstring, "\n");
    strcat(mainstring, "{E74C3C}ATTENTION: {FFFFFF}Tu ne dois {E74C3C}pas{FFFFFF} changer de véhicule pendant l'extraction ! Utilise uniquement ton véhicule\n");
    strcat(mainstring, "{FFFFFF}jusqu'à ce que tu aies livré et vendu tous tes minerais !");
    ShowPlayerDialog(playerid, DIALOG_NULL, DIALOG_STYLE_MSGBOX, "{E74C3C}RSL: {FFFFFF}Mining", mainstring, "Schließen", "");
    return 1;
}
 
CMD:ore(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, 0xE88732FF, "UTILISE: {FFFFFF}/ore [info/mine/take]");
    if(!strcmp(params, "info", true)) {
        new id = Player_GetClosestVein(playerid);
        if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves près d'aucun gisement..");
        new string[128], type = VeinData[id][Type];
        format(string, sizeof(string), "Nom\t{%06x}%s\nValeur\t{2ECC71}$%d\nValeur du filon\t{2ECC71}$%d\nTemps d'extraction\t%.2f secondes", OreData[type][oColor] >>> 8, OreData[type][oName], OreData[type][Value], (OreData[type][Value] * VeinData[id][Amount]), Vein_CalculateTime(id) / 1000);
        ShowPlayerDialog(playerid, DIALOG_ORE_INFO, DIALOG_STYLE_TABLIST, "Erz Information", string, "Schließen", "");
    }else if(!strcmp(params, "mine")) {
        if(!Vehicle_IsMiningVehicle(GetPVarInt(playerid, "mine_LastVehicleID"))) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Ce véhicule n'est pas adapté.");
        if(MiningVein[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Du baust bereits ein Erz ab.");
        if(CarryingOre[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu portes déjà un minerai.");
        new id = Player_GetClosestVein(playerid);
        if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves près d'aucun gisement..");
        if(VeinData[id][BeingMined]) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Ce gisement est déjà exploité par un autre joueur.");
        if(VeinData[id][Amount] < 1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Ce gisement est épuisé.");
        new Float: x, Float: y, Float: z;
        GetVehicleBoot(GetPVarInt(playerid, "mine_LastVehicleID"), x, y, z);
        if(GetPlayerDistanceFromPoint(playerid, x, y, z) > 60.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Ton véhicule est trop loin de toi.");
        MiningVein[playerid] = id;
 
        MiningTimer[playerid] = SetTimerEx("Player_Mine", MINING_UPDATE_RATE, true, "i", playerid);
        SetPlayerProgressBarColour(playerid, MiningBar[playerid], OreData[ VeinData[id][Type] ][oColor]);
        SetPlayerProgressBarValue(playerid, MiningBar[playerid], 0.0);
        ShowPlayerProgressBar(playerid, MiningBar[playerid]);
        SetPlayerAttachedObject(playerid, ATTACH_INDEX, 19631, 6, 0.048, 0.029, 0.103, -80.0, 80.0, 0.0);
        TogglePlayerControllable(playerid, false);
        SetPlayerArmedWeapon(playerid, WEAPON_FIST);
        ApplyAnimation(playerid, "BASEBALL", "Bat_1", 4.1, true, false, false, true, 0, SYNC_ALL);
 
        new string[64];
        format(string, sizeof(string), "~n~~y~~h~Extraction de %s...", OreData[ VeinData[id][Type] ][oName]);
        GameTextForPlayer(playerid, string, floatround(Vein_CalculateTime(id)) + 1000, 3);
 
        VeinData[id][BeingMined] = true;
        Vein_Update(id);
    }else if(!strcmp(params, "take")) {
        if(!Vehicle_IsMiningVehicle(GetPVarInt(playerid, "mine_LastVehicleID"))) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Ce véhicule n'est pas adapté.");
        if(MiningVein[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Du baust bereits ein Erz ab.");
        if(CarryingOre[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu portes déjà un minerai.");
        new id = Player_GetClosestOre(playerid);
        if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves près d'aucun minerai.");
        new Float: x, Float: y, Float: z;
        GetVehicleBoot(GetPVarInt(playerid, "mine_LastVehicleID"), x, y, z);
        if(GetPlayerDistanceFromPoint(playerid, x, y, z) > 60.0) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Ton véhicule est trop loin de toi.");
        Player_GiveOre(playerid, DroppedOres[id][Type]);
        Ore_Destroy(id);
    }
    
    return 1;
}