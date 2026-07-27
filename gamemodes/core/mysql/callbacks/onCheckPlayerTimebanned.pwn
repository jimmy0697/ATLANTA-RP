
forward onCheckPlayerTimebanned(playerid);
public onCheckPlayerTimebanned(playerid)
{
    new rows, sqlquery[256];
    cache_get_row_count(rows);
    if(rows)
    {
        DeletePVar(playerid,"LoggedIn");
        new unban = mysql_GetInt("timebans", "serv_Data", "Name", SpielerInfo[playerid][sName]);
        if(gettime() < unban)
        {
            new differenz = unban - gettime();
            new minuten = differenz / 60;
            new bannedgstring[370];
            new Teamler[24];
            format(Teamler,sizeof(Teamler),"%s",mysql_GetString("timebans", "Teammitglied", "Name", SpielerInfo[playerid][sName]));
            new Bgrund[64];
            format(Bgrund,sizeof(Bgrund),"%s",mysql_GetString("timebans", "Bangrund", "Name", SpielerInfo[playerid][sName]));
            new UhrZeit[16];
            format(UhrZeit,sizeof(UhrZeit),"%s",mysql_GetString("timebans", "Uhrzeit", "Name", SpielerInfo[playerid][sName]));
            new DaTum[16];
            format(DaTum,sizeof(DaTum),"%s",mysql_GetString("timebans", "Datum", "Name", SpielerInfo[playerid][sName]));
            format(bannedgstring,sizeof(bannedgstring),"{FFFFFF}Ton compte a été banni temporairement !\nBanni par : %s\nRaison : %s\nHeure : %s \nDate : %s\nTemps restant : %i minutes\n\nSi tu penses avoir été banni à tort, appuie sur {007DFF}'F8'{FFFFFF} pour faire une capture d'écran\nde cette fenêtre, puis signale-le sur le forum en remplissant le modèle de demande de déban.",Teamler,Bgrund,UhrZeit,DaTum,minuten);
            ShowPlayerDialog(playerid,9992,DIALOG_STYLE_MSGBOX,"{007DFF}"SERV_NAME"{FFFFFF} - Gestion des comptes",bannedgstring,"Fermer","");
            KickPlayer(playerid,"");
            return 1;
        }
        else
        {
            mysql_format(sqlHandle, sqlquery, sizeof(sqlquery), "DELETE FROM `timebans` WHERE `Name` = '%s' ", SpielerInfo[playerid][sName]);
            mysql_tquery(sqlHandle, sqlquery);

            new logingstring[340];
            format(logingstring,sizeof(logingstring),"{FFFFFF}Bienvenue de retour sur "SERV_NAME" {007DFF}%s{FFFFFF}.\nNous avons trouvé ton compte dans notre base de données. Merci de te connecter en saisissant\nle mot de passe choisi lors de ton inscription. Pour toute question, contacte notre équipe.",SpielerInfo[playerid][sName]);
            ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"{007DFF}"SERV_NAME"{FFFFFF} - Connexion",logingstring,"Continuer","");
        }
    }
    mysql_format(sqlHandle, sqlquery, sizeof(sqlquery), "SELECT `Name` FROM `vip` WHERE `Name` = '%s'", SpielerInfo[playerid][sName]);
    mysql_tquery(sqlHandle, sqlquery, "onCheckPlayerVip", "i", playerid);
    return 1;
}