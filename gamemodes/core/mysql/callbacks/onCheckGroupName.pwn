forward onCheckGroupName(playerid, const inputtext[]);
public onCheckGroupName(playerid, const inputtext[]) {
    new rows, query[164], GruppenName[24];
    cache_get_row_count(rows);
    if(rows) {
        GetPVarString(playerid, "GruppenName", GruppenName, sizeof(GruppenName));

        DeletePVar(playerid,"GruppenName");
        format(query, sizeof(query), "{FFFFFF}Le nom de groupe : {FF0000}%s{FFFFFF} est déjà pris.\nMerci d'en indiquer un nouveau ci-dessous.", GruppenName);
        ShowPlayerDialog(playerid,DIALOG_CREATE_GRUPPE,DIALOG_STYLE_INPUT,"{007DFF}"SERV_NAME"{FFFFFF} - Créer un groupe",query,"Continuer","Annuler");
        return 1;
    }
    mysql_format(sqlHandle, query, sizeof(query), "SELECT `Kennzeichen` FROM `gruppen` WHERE `Kennzeichen` = '%s'", inputtext);
    mysql_tquery(sqlHandle, query, "onCheckGroupNumberplate", "is", playerid, inputtext);
    return 1;
}