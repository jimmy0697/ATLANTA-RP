
forward onCheckPlayerAccount(playerid);
public onCheckPlayerAccount(playerid)
{
    new rows, sqlquery[256];
    cache_get_row_count(rows);
    if(rows)
    {
        mysql_format(sqlHandle, sqlquery, sizeof(sqlquery), "SELECT `Name` FROM `accbans` WHERE `Name` = '%s'", SpielerInfo[playerid][sName]);
	    mysql_tquery(sqlHandle, sqlquery, "onCheckPlayerBanned", "i", playerid);
    }
    else
    {
        if(strfind(SpielerInfo[playerid][sName], "[", true) != -1)
        {
            SendClientMessage(playerid,COLOR_RED,"[Attention]: Les tags de clan ou crochets ne sont pas tolérés.");
            KickPlayer(playerid,"ClanTag-Login");
        }
        else
        {
            new reggstring[500];
            format(reggstring,sizeof(reggstring),"{FFFFFF}Bienvenue sur "SERV_NAME", {007DFF}/%s{FFFFFF}.\n\
            Toute l'équipe et la communauté sont ravies de t'accueillir. Avant de commencer, laisse-nous te présenter le serveur.",SpielerInfo[playerid][sName]);
            ShowPlayerDialog(playerid,DIALOG_TUTORIAL,DIALOG_STYLE_MSGBOX,"{007DFF}"SERV_NAME"{FFFFFF} - Bienvenue ! (1/3)",reggstring,"Continuer","");
        }
    }
    return 1;
}