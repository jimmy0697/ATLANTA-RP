CMD:createpartei(playerid, params[]) {
    if(!IsPlayerAtPickupByType(playerid, 5.0, PICKUP_TYPE_CREATEPARTIE)) return SendClientMessage(playerid, COLOR_ERRORTEXT, "Eine Partei kann nur in der Stadthalle in Los Santos gegründet werden.");
    if(GetPVarInt(playerid, "PARTIE_TIMESTAMP") > gettime()) return SendClientMessage(playerid, COLOR_ERRORTEXT, "Derzeit kannst du keine Partei gründen.");
    
    new string[1028];
    strcat(string, "Bienvenue à la mairie de Los Santos !\n");
    strcat(string, "Tu as ici la possibilité de fonder ton propre parti\n");
    new partieCostMsg[64];
    format(partieCostMsg, sizeof(partieCostMsg), "in die Politik in San Andreas einzusteigen. Die Gründung einer Partei kostet %d$.\n", PARTIE_COSTS);
    strcat(string, partieCostMsg);
    strcat(string, "Tu ne peux fonder un parti qu'avec l'aide d'un autre joueur. Une fois ton parti\n");
    strcat(string, "créé, tu pourras participer aux élections du gouvernement.\n\n");
    strcat(string, "Convaincu(e) ? Tu peux maintenant commencer à fonder ton propre parti.");
    ShowPlayerDialog(playerid, DIALOG_CREATE_PARTIE, DIALOG_STYLE_MSGBOX, "{CC33FF}redv-reallife.de: {FFFFFF}Partei erstellen", string, "Bestätigen", "Abbrechen");
    return 1;
}