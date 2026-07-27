/*
 * Rosalife 2025 - Taeglicher Neustart Admin-Befehle
 * Erstellt von ShadowKev1999
 */

// Befehl zum manuellen Ausloesen des taeglichen Neustarts
cmd:dailyrestart(playerid, params[])
{
    if(SpielerInfo[playerid][sAdmin] < 5) return NichtBerechtigt
    
    if(DailyRestartActive)
    {
        SendClientMessage(playerid, COLOR_ERRORTEXT, "[ERROR] Der taegliche Neustart ist bereits aktiv!");
        return 1;
    }
    
    new string[128];
    format(string, sizeof(string), "{FFFF00}Veux-tu déclencher le redémarrage quotidien manuellement maintenant ?\n\n{FFFFFF}Le serveur redémarrera dans 2 minutes.");
    ShowPlayerDialog(playerid, DIALOG_ADMIN_DAILY_RESTART, DIALOG_STYLE_MSGBOX, "{164863}redv-reallife.de: {FFFFFF}Taeglicher Neustart", string, "Ausloesen", "Abbrechen");
    return 1;
}

// Befehl zum Abbrechen des taeglichen Neustarts
cmd:canceldailyrestart(playerid, params[])
{
    if(SpielerInfo[playerid][sAdmin] < 5) return NichtBerechtigt
    
    if(!DailyRestartActive)
    {
        SendClientMessage(playerid, COLOR_ERRORTEXT, "[ERROR] Der taegliche Neustart ist aktuell nicht aktiv!");
        return 1;
    }
    
    if(!GMX_Data[restartActive])
    {
        SendClientMessage(playerid, COLOR_ERRORTEXT, "[ERROR] Es laeuft aktuell kein Neustart!");
        return 1;
    }
    
    // Neustart abbrechen
    GMX_Data[restartActive] = false;
    GMX_Data[restartTime] = 0;
    GMX_Data[pendingRestartTime] = 0;
    format(GMX_Data[restartAdmin], MAX_PLAYER_NAME, "NIEMAND");
    KillTimer(_:GMX_Data[restartTimer]);
    
    // Daily Restart Flag zuruecksetzen
    DailyRestartActive = false;
    
    SendClientMessageToAll(-1, "{FF8080}{FFFF00}REDÉMARRAGE QUOTIDIEN: {FFFFFF}%s a annulé le redémarrage quotidien. Tu peux reprendre tes activités !", GetName(playerid));
    return 1;
}

// Debug-Befehl um den Status zu pruefen
cmd:dailyrestartstatus(playerid, params[])
{
    if(SpielerInfo[playerid][sAdmin] < 5) return NichtBerechtigt
    
    new string[256], hour, minute, second;
    gettime(hour, minute, second);
    
    format(string, sizeof(string), "DailyRestartActive : %s\nHeure : %02d:%02d:%02d\nHeure cible : %02d:00:00", 
        DailyRestartActive ? "JA" : "NEIN",
        hour, minute, second,
        DailyRestartHour);
        
    SendClientMessage(playerid, -1, string);
    return 1;
}

// Debug-Befehl um die Neustart-Zeit zu aendern
cmd:setdailyrestarttime(playerid, params[])
{
    if(SpielerInfo[playerid][sAdmin] < 5) return NichtBerechtigt
    
    new time;
    if(sscanf(params, "i", time)) return SendUsage(playerid, "/setdailyrestarttime [Heure (0-23)]");
    
    if(time < 0 || time > 23) return SendError(playerid, "Indique une heure entre 0 et 23.");
    
    DailyRestartHour = time;
    
    new string[128];
    format(string, sizeof(string), "Heure du redémarrage quotidien réglée sur %02d:00.", DailyRestartHour);
    SendClientMessage(playerid, -1, string);
    return 1;
}
