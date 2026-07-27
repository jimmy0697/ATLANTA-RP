forward onCheckPlayerVip(playerid);
public onCheckPlayerVip(playerid)
{
    new rows, sqlquery[256];
    cache_get_row_count(rows);
    if(rows)
    {
        new vip = mysql_GetInt("vip", "serv_Data", "Name", SpielerInfo[playerid][sName]);
        if(gettime() >= vip)
        {
            mysql_format(sqlHandle, sqlquery, sizeof(sqlquery), "DELETE FROM `vip` WHERE `Name` = '%s' ", SpielerInfo[playerid][sName]);
            mysql_tquery(sqlHandle, sqlquery);
        }
    }
    new logingstring[340];
    format(logingstring,sizeof(logingstring),"{FFFFFF}Bienvenue de retour sur "SERV_NAME" {007DFF}%s{FFFFFF}.\nNous avons trouvé ton compte dans notre base de données. Merci de te connecter en saisissant\nle mot de passe choisi lors de ton inscription. Pour toute question, contacte notre équipe.",SpielerInfo[playerid][sName]);
    ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"{007DFF}"SERV_NAME"{FFFFFF} - Connexion",logingstring,"Continuer","");
    return 1;
}