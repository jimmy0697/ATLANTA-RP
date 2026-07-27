
forward onCheckPlayerBanned(playerid);
public onCheckPlayerBanned(playerid)
{
    new rows, sqlquery[256];
    cache_get_row_count(rows);
    if(rows)
    {
        DeletePVar(playerid,"LoggedIn");
        new bannedgstring[400];
        new Teamler[24];
        format(Teamler,sizeof(Teamler),"%s",mysql_GetString("accbans", "Teammitglied", "Name", SpielerInfo[playerid][sName]));
        new Bgrund[64];
        format(Bgrund,sizeof(Bgrund),"%s",mysql_GetString("accbans", "Bangrund", "Name", SpielerInfo[playerid][sName]));
        new UhrZeit[16];
        format(UhrZeit,sizeof(UhrZeit),"%s",mysql_GetString("accbans", "Uhrzeit", "Name", SpielerInfo[playerid][sName]));
        new DaTum[16];
        format(DaTum,sizeof(DaTum),"%s",mysql_GetString("accbans", "Datum", "Name", SpielerInfo[playerid][sName]));
        format(bannedgstring,sizeof(bannedgstring),"{FFFFFF}Ton compte a été banni !\nBanni par : %s\nRaison : %s\nHeure : %s\nDate : %s\n\nSi tu penses avoir été banni à tort, appuie sur {007DFF}'F8'{FFFFFF} pour faire une capture d'écran\nde cette fenêtre, puis signale-le sur le forum en remplissant le modèle de demande de déban.",Teamler,Bgrund,UhrZeit,DaTum);
        ShowPlayerDialog(playerid,9992,DIALOG_STYLE_MSGBOX,"{007DFF}"SERV_NAME"{FFFFFF} - Gestion des comptes",bannedgstring,"Fermer","");
        KickPlayer(playerid,"");
    }
    else
    {
        mysql_format(sqlHandle, sqlquery, sizeof(sqlquery), "SELECT `Name` FROM `timebans` WHERE `Name` = '%s'", SpielerInfo[playerid][sName]);
		mysql_tquery(sqlHandle, sqlquery, "onCheckPlayerTimebanned", "i", playerid);
    }
    return 1;
}