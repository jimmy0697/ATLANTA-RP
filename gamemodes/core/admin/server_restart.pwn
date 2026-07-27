forward RestartServerTimer();
public RestartServerTimer() {
    GMX_Data[pendingRestartTime] --;
    if(GMX_Data[pendingRestartTime] <= 0) {
        ServerRestartFolgt = 1;
        SendClientMessageToAll(-1, "{FF8080}REDÉMARRAGE SERVEUR : {FFFFFF}Le serveur redémarre ! Toutes les données sont en cours de sauvegarde !");
		foreach(new i : Player) {
			if(IsPlayerNPC(i)) {
				KickPlayer(i,"Server Restart");
			} else {
			    SaveAccount(i);
	     		SavePlayerWeapons(i);
	  			SavePrivatCar(i);
                KickPlayer(i,"Server Restart");
  			}
		}
	    SaveFrakInfo();
    	SaveGangZones();
    	SaveDrogen();
    	SaveGruppen();
        SaveTankstellen();
        SaveAmmunations();
        SaveStores();
        SaveHauser();
        SaveGarage();
        SaveWerbetafel();
        SaveVehicles();

        KillTimer(_:GMX_Data[restartTimer]);

        SetTimer("ServerRestart", 10000, false);
    } else {
        SendClientMessageToAll(-1, "{FF8080}REDÉMARRAGE SERVEUR : {FFFFFF}Le serveur redémarre dans %i minutes (Membre du staff : %s)", GMX_Data[pendingRestartTime], GMX_Data[restartAdmin]);
    }
    return 1;
}

ServerRestart_OnDialogResponse(playerid, dialogid, response) {
    switch(dialogid) {
        case DIALOG_ADMIN_GMX: {
            if(!response) return 1;

            if(GMX_Data[restartActive]) return SendClientMessage(playerid, COLOR_ERRORTEXT, "Un redémarrage du serveur est déjà en cours (pour annuler : /cancelrestart).");
            new restart_time = GetPVarInt(playerid, "GMX_MINUTES");

            GMX_Data[restartActive] = true;
            GMX_Data[restartTime] = restart_time;
            GMX_Data[pendingRestartTime] = restart_time;
            format(GMX_Data[restartAdmin], MAX_PLAYER_NAME, "%s", GetName(playerid));

            GMX_Data[restartTimer] = Timer:SetTimer("RestartServerTimer", 60000, true);

            SendClientMessageToAll(-1, "{FF8080}REDÉMARRAGE SERVEUR : {FFFFFF}%s a lancé un redémarrage du serveur ! Le serveur redémarre dans %i minutes.", GetName(playerid), restart_time);
            SendClientMessageToAll(-1, "{FF8080}REDÉMARRAGE SERVEUR : {FFFFFF}Termine toutes tes activités pour ne pas perdre ta progression !");

            SendClientMessage(playerid, COLOR_YELLOW, "Pour annuler le redémarrage du serveur, utilise /cancelrestart");

            DeletePVar(playerid, "GMX_MINUTES");
            return 1;
        }

        case DIALOG_ADMIN_GMX_CANCEL: {
            if(!response) return 1;

            if(!GMX_Data[restartActive]) return SendClientMessage(playerid, COLOR_ERRORTEXT, "Aucun redémarrage du serveur n'est en cours (pour en lancer un : /serverrestart).");

            GMX_Data[restartActive] = false;
            GMX_Data[restartTime] = 0;
            GMX_Data[pendingRestartTime] = 0;
            format(GMX_Data[restartAdmin], MAX_PLAYER_NAME, "NIEMAND");

            stop GMX_Data[restartTimer];

            SendClientMessageToAll(-1, "{FF8080}REDÉMARRAGE SERVEUR : {FFFFFF}%s a annulé le redémarrage du serveur. Tu peux reprendre tes activités !", GetName(playerid));
            return 1;
        }
    }
    return 1;
}