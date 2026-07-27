/*
 * Rosalife 2025 - Tglicher automatischer Neustart um 5 Uhr
 * Erstellt von ShadowKev1999
 */

// Forward declarations
forward DailyRestartCheck();
forward DailyRestartExecute();

// Globale Variablen
new bool:DailyRestartActive = false;
new DailyRestartHour = 5; // 5 Uhr morgens

// Timer fr tgliche berprfung (jede Minute)
task DailyRestartCheck[60000]()
{
    // Aktuelle Zeit holen
    new hour, minute, second;
    gettime(hour, minute, second);
    
    // Prfen ob es 5:00 Uhr ist und der Neustart noch nicht aktiv ist
    if(hour == DailyRestartHour && minute == 0 && second == 0 && !DailyRestartActive)
    {
        DailyRestartActive = true;
        
        // Automatischen Neustart starten
        printf("[DAILY-RESTART] Redémarrage quotidien de 05:00 en cours de lancement !");
        
        // Nachricht an alle Spieler
        SendClientMessageToAll(-1, "{FF8080}{FFFF00}REDÉMARRAGE QUOTIDIEN : {FFFFFF}Le serveur redémarre chaque jour à 05:00 !");
        SendClientMessageToAll(-1, "{FF8080}{FFFF00}REDÉMARRAGE QUOTIDIEN : {FFFFFF}Toutes les données sont sauvegardées. Le serveur sera de nouveau accessible dans 2 minutes.");
        
        // Neustart mit 2 Minuten Vorwarnzeit
        GMX_Data[restartActive] = true;
        GMX_Data[restartTime] = 2;
        GMX_Data[pendingRestartTime] = 2;
        format(GMX_Data[restartAdmin], MAX_PLAYER_NAME, "System");
        
        // Neustart-Timer starten
        GMX_Data[restartTimer] = Timer:SetTimer("RestartServerTimer", 60000, true);
        
        // Timer zurcksetzen nach 5 Minuten (um mehrfache Ausfhrung zu verhindern)
        SetTimer("ResetDailyRestartFlag", 300000, false);
    }
    
    return 1;
}

// Reset der DailyRestart Flag
forward ResetDailyRestartFlag();
public ResetDailyRestartFlag()
{
    DailyRestartActive = false;
    printf("[DAILY-RESTART] Indicateur de redémarrage quotidien réinitialisé.");
    return 1;
}

// Manuelles Auslsen des tglichen Neustarts (fr Admins)
stock TriggerDailyRestart()
{
    if(DailyRestartActive)
    {
        printf("[DAILY-RESTART] Le redémarrage quotidien est déjà actif.");
        return 0;
    }
    
    DailyRestartActive = true;
    
    printf("[DAILY-RESTART] Redémarrage quotidien manuel déclenché !");
    
    // Nachricht an alle Spieler
    SendClientMessageToAll(-1, "{FF8080}{FFFF00}REDÉMARRAGE QUOTIDIEN : {FFFFFF}Le serveur redémarre maintenant (déclenché manuellement) !");
    SendClientMessageToAll(-1, "{FF8080}{FFFF00}REDÉMARRAGE QUOTIDIEN : {FFFFFF}Toutes les données sont sauvegardées. Le serveur sera de nouveau accessible dans 2 minutes.");
    
    // Neustart mit 2 Minuten Vorwarnzeit
    GMX_Data[restartActive] = true;
    GMX_Data[restartTime] = 2;
    GMX_Data[pendingRestartTime] = 2;
    format(GMX_Data[restartAdmin], MAX_PLAYER_NAME, "System");
    
    // Neustart-Timer starten
    GMX_Data[restartTimer] = Timer:SetTimer("RestartServerTimer", 60000, true);
    
    // Timer zurcksetzen nach 5 Minuten
    SetTimer("ResetDailyRestartFlag", 300000, false);
    
    return 1;
}

// Status des tglichen Neustarts abfragen
stock IsDailyRestartActive()
{
    return DailyRestartActive;
}

// Zeit des tglichen Neustarts setzen
stock SetDailyRestartHour(hour)
{
    if(hour < 0 || hour > 23)
    {
        printf("[DAILY-RESTART] Heure invalide : %d (0-23 autorisé)", hour);
        return 0;
    }
    
    DailyRestartHour = hour;
    printf("[DAILY-RESTART] Redémarrage quotidien réglé sur %02d:00.", hour);
    return 1;
}

// Aktuelle Zeit des tglichen Neustarts abfragen
stock GetDailyRestartHour()
{
    return DailyRestartHour;
}
