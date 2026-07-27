
Insurance_ConnectPlayer(playerid) {
    SpielerInfo[playerid][sHealthInsurance] = -1;
    return 1;
}

ShowInsuranceDialog(playerid) {
    ShowPlayerDialog(playerid, DIALOG_INSURANCE_LIST, DIALOG_STYLE_LIST, "{FF0000}RSL: {FFFFFF}Versicherungen", "Krankenversicherung", "Auswählen", "Abbrechen");
    return 1;
}

Insurance_DialogResponse(playerid, dialogid, response, listitem) {
    switch(dialogid) {
        case DIALOG_INSURANCE_LIST: {
            if(!response) return 1;

            new string[512];

            switch(listitem) {
                case 0: { //Krankenversicherung
                    strcat(string, "Durée\tCoût");
                    for(new i = 0; i < MAX_HEALTH_INSURANCE_TYPES; i++) {
                        format(string, sizeof(string), "%s\n%i jours\t%i $", string, HealthInsuranceTime[i], HealthInsuranceCosts[i]);
                    }
                    SendClientMessage(playerid, COLOR_WHITE, " ");
                    SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Michelle S.{FFFFFF} dit : Avec une assurance maladie, tu économises sur les frais hospitaliers.");
                    SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Michelle S.{FFFFFF} sagt: L'assurance maladie sera prélevée lors de ton payday.");
                    ShowPlayerDialog(playerid, DIALOG_INSURANCE_HEALTH, DIALOG_STYLE_TABLIST_HEADERS, "{FF0000}RSL: {FFFFFF}Krankenversicherung", string, "Auswählen", "Zurück");
                    return 1;
                }
            }
            return 1;
        }

        case DIALOG_INSURANCE_HEALTH: {
            if(!response) return ShowInsuranceDialog(playerid);

            if(SpielerInfo[playerid][sHealthInsurance] != -1) {
                SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Michelle S.{FFFFFF} dit : Tu possèdes déjà une assurance maladie.");
                SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Michelle S.{FFFFFF} sagt: Eine neue Krankenversicherung kann erst nach Ablauf der alten Krankenversicherung abgeschlossen werden.");
                return 1;
            }

            SpielerInfo[playerid][sHealthInsurance] = listitem;
            SpielerInfo[playerid][sHealthInsuranceTime] = gettime() + (60*60*24*HealthInsuranceTime[listitem]);

            SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Michelle S.{FFFFFF} sagt: Félicitations pour ta nouvelle assurance maladie.");
            SendClientMessage(playerid, COLOR_WHITE, "{FF0000}Michelle S.{FFFFFF} sagt: Die Laufzeit beträgt %i Tage. Die Gebühr pro PayDay beträgt %i $.", 
            HealthInsuranceTime[listitem], HealthInsuranceCosts[listitem]);
        }
    }
    return 1;
}