forward onCheckGroupNumberplate(playerid, const inputtext[]);
public onCheckGroupNumberplate(playerid, const inputtext[]) {
    new rows, query[164], GruppenName[24];
    cache_get_row_count(rows);
    if(rows) {
        DeletePVar(playerid,"GruppenName");
        format(query, sizeof(query), "{FFFFFF}Ta plaque souhaitée : {FF0000}%s{FFFFFF} est déjà prise.\nMerci d'en indiquer une nouvelle ci-dessous.", inputtext);
        ShowPlayerDialog(playerid,DIALOG_CREATE_GRUPPE3,DIALOG_STYLE_INPUT,"{007DFF}"SERV_NAME"{FFFFFF} - Créer un groupe",query,"Continuer","Annuler");
        return 1;
    }
    GetPVarString(playerid, "GruppenName", GruppenName, sizeof(GruppenName));
    DeletePVar(playerid,"GruppenName");

    for(new mf=1;mf<MAX_GRUPPEN;mf++) {
        if(GruppenInfo[mf][gErstellt] == true)continue;
        format(GruppenInfo[mf][gName], 24, GruppenName);
        format(GruppenInfo[mf][gSchild], 5, inputtext);
        GruppenInfo[mf][gErstellt] = true;
        GruppenInfo[mf][gKasse] = 200000;

        GivePlayerMoneyEx(playerid,-250000);
        SpielerInfo[playerid][sGruppe] = mf;
        SpielerInfo[playerid][sGLeader] = mf;
        SpielerInfo[playerid][sGRank] = 7;

        format(query, 144, "Tu as fondé le groupe %s avec succès.", GruppenName);
        SendClientMessage(playerid,COLOR_SUPER,query);
        mysql_format(sqlHandle, query, sizeof(query), "INSERT INTO `gruppen` (`ID`, `Name`, `Kennzeichen`, `Kasse`) VALUES ('%d', '%s', '%s', '200000')", mf, GruppenName, inputtext);
        mysql_tquery(sqlHandle, query);

        mysql_format(sqlHandle, query, sizeof(query), "INSERT INTO `grangnamen` (`gid`) VALUES ('%d')", mf);
        mysql_tquery(sqlHandle, query);
        break;
    }
    return 1;
}