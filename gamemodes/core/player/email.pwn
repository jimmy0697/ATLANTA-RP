forward onPlayerStartChangeEmail(playerid);
public onPlayerStartChangeEmail(playerid) {
    new rows;
    cache_get_row_count(rows);
    if(!rows) {
        SendClientMessage(playerid, COLOR_GREY, "Ton compte est introuvable ou ton e-mail a déjà été vérifié.");
        SendClientMessage(playerid, COLOR_GREY, "Si ton e-mail a déjà été vérifié, tu ne peux le modifier que via l'UCP.");
        return 1;
    }
    new string[256];
    cache_get_value_name(0, "EMail", string);

    SetPVarString(playerid, "Email_Change", string);

    format(string, sizeof(string), "{FFFFFF}Ton e-mail actuel est : {164863}%s{FFFFFF} !\n \
    Falls du bei der Registration eine falsche E-Mail angegeben hast,\n \
    kannst du diese nun wechseln, um dich für das User Control Panel zu verifizieren.", string);

    ShowPlayerDialog(playerid, DIALOG_CHANGE_EMAIL, DIALOG_STYLE_INPUT, "{164863}"SERV_NAME": {FFFFFF}Modifier l'e-mail", string, "Modifier", "Annuler");
    return 1;
}

forward onCheckEmailBlacklist(playerid, const inputtext[]);
public onCheckEmailBlacklist(playerid, const inputtext[]) {
    new rows;
    cache_get_row_count(rows);
    if(rows) {
        new oldEmail[65], string[256];
        GetPVarString(playerid, "Email_Change", oldEmail);
        format(string, sizeof(string), "{FFFFFF}Ton e-mail actuel est : {164863}%s{FFFFFF} !\n \
        Falls du bei der Registration eine falsche E-Mail angegeben hast,\n \
        kannst du diese nun wechseln, um dich für das User Control Panel zu verifizieren.", string);

        ShowPlayerDialog(playerid, DIALOG_CHANGE_EMAIL, DIALOG_STYLE_INPUT, "{164863}"SERV_NAME": {FFFFFF}Modifier l'e-mail", string, "Modifier", "Annuler");

        SendClientMessage(playerid, COLOR_ERRORTEXT, "Le fournisseur de ton e-mail %s est sur liste noire et ne peut pas être utilisé", inputtext);
        SendClientMessage(playerid, COLOR_ERRORTEXT, "S'il s'agit d'une erreur, contacte la Direction du Projet !");
        return 1;
    }

    new query[128];
    mysql_format(sqlHandle, query, sizeof(query), "UPDATE `accounts` SET `EMail` = '%s' WHERE `ID` = %i", inputtext, SpielerInfo[playerid][sDBID]);
    mysql_tquery(sqlHandle, query);

    SendClientMessage(playerid, -1, "{164863}INFO: {FFFFFF} Tu as changé ton e-mail avec succès pour {164863}%s{FFFFFF}", inputtext);
    return 1;
}

PlayerEmail_DialogResponse(playerid, dialogid, response, const inputtext[]) {
    switch(dialogid) {
        case DIALOG_CHANGE_EMAIL: {
            if(!response) return 1;
            new string[256], oldEmail[65];

            if(strlen(inputtext) < 5 || strlen(inputtext) > 20) {
                GetPVarString(playerid, "Email_Change", oldEmail);
                format(string, sizeof(string), "{FFFFFF}Ton e-mail actuel est : {164863}%s{FFFFFF} !\n \
                Falls du bei der Registration eine falsche E-Mail angegeben hast,\n \
                kannst du diese nun wechseln, um dich für das User Control Panel zu verifizieren.", string);

                ShowPlayerDialog(playerid, DIALOG_CHANGE_EMAIL, DIALOG_STYLE_INPUT, "{164863}"SERV_NAME": {FFFFFF}Modifier l'e-mail", string, "Modifier", "Annuler");

                SendClientMessage(playerid, COLOR_ERRORTEXT, "Ta saisie '%s' est invalide !", inputtext);
                return 1;
            }
            
            new email[65], domain[15];
            if(sscanf(inputtext, "s[65]'@'s[15]'", email, domain)) {
                GetPVarString(playerid, "Email_Change", oldEmail);
                format(string, sizeof(string), "{FFFFFF}Ton e-mail actuel est : {164863}%s{FFFFFF} !\n \
                Falls du bei der Registration eine falsche E-Mail angegeben hast,\n \
                kannst du diese nun wechseln, um dich für das User Control Panel zu verifizieren.", string);

                ShowPlayerDialog(playerid, DIALOG_CHANGE_EMAIL, DIALOG_STYLE_INPUT, "{164863}"SERV_NAME": {FFFFFF}Modifier l'e-mail", string, "Modifier", "Annuler");

                SendClientMessage(playerid, COLOR_ERRORTEXT, "Ta saisie '%s' est invalide !", inputtext);
                return 1;
            }
            new query[128];
            mysql_format(sqlHandle, query, sizeof(query), "SELECT * FROM `email_blacklist` WHERE `name` = %s", domain);
            mysql_tquery(sqlHandle, query, "onCheckEmailBlacklist", "is", playerid, inputtext);
            return 1;
        }
    }
    return 1;  
}