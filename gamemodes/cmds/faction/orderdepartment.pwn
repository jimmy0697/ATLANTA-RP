CMD:abschleppen(playerid, params[])
{
	if(SpielerInfo[playerid][sFraktion] != 7)return NichtBerechtigt
 	if(GetPVarInt(playerid,"OAmtDuty") != 1)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du sitzt in keinem TowTruck.");
	if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du hast kein Fahrzeug am Haken.");
	new car = GetVehicleTrailer(GetPlayerVehicleID(playerid));
	if(FahrzeugInfo[car][fFraktion] != 0 || FahrzeugInfo[car][fGruppe] != 0 || strlen(FahrzeugInfo[car][fBesitzer]) != 0)
	{
		SetPlayerCheckpointEx(playerid,1128.0292,-1687.3867,13.2602,5.0);
		SendClientMessage(playerid,COLOR_INFO,"[Info]: {FFFFFF}Bringe das Fahrzeug zum roten Marker.");
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
  		return 1;
	}
	else SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du kannst dieses Fahrzeug nicht abschleppen.");
	return 1;
}


CMD:givepunkte(playerid,params[])
{
	if(SpielerInfo[playerid][sFraktion] == 7)
	{
 		if(GetPVarInt(playerid,"OAmtDuty") == 1)
		{
			new string[128], Auswahl[20], pID, Anzahl, Grund[64];
			if(sscanf(params,"us[20]ds[64]",pID,Auswahl,Anzahl,Grund))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/givepunkte [SpielerID/Name] [Autoschein|Motorradschein|Flugschein|LKWschein|Bootsschein] [Anzahl] [Grund]");
			if(!IsPlayerConnectedEx(pID))return NichtOnline
			if(pID == playerid)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du kannst dir selber keine Punkte eintragen.");
			if(strcmp(Auswahl, "Autoschein", true, strlen(Auswahl)) == 0)
	    	{
	    	    if(SpielerInfo[pID][sCarLic] == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der angegebene Spieler besitzt kein Autoschein.");
	    	    new Punkte = SpielerInfo[pID][stvoCarLic]+Anzahl;
	    	    if(Punkte < 10)
	    	    {
	    	        SpielerInfo[pID][stvoCarLic] += Anzahl;
	    	        format(string,sizeof(string),"%s %s t'a inscrit %d point(s) de pénalité pour le permis auto. Raison : %s",RangName(playerid),SpielerInfo[playerid][sName],Anzahl,Grund);
	    	        SendClientMessage(pID,COLOR_RED,string);
	    	        format(string,sizeof(string),"Tu as inscrit %d point(s) de pénalité pour le permis auto à %s. Raison : %s",SpielerInfo[pID][sName],Anzahl,Grund);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        return 1;
	    	    }
	    	    else
	    	    {
	    	        SpielerInfo[pID][stvoCarLic] = 0;
	    	        SpielerInfo[pID][sCarLic] = 0;
		        	format(string,sizeof(string),"%s %s t'a inscrit %d point(s) de pénalité pour le permis auto. Raison : %s",RangName(playerid),SpielerInfo[playerid][sName],Anzahl,Grund);
	    	        SendClientMessage(pID,COLOR_RED,string);
	    	        SendClientMessage(pID,COLOR_RED,"[Info]: {FFFFFF}Dir wurde dein Autoschein entzogen, weil du mehr als 10 Strafpunkte oder 10 Strafpunkte hast.");
	    	        format(string,sizeof(string),"Tu as inscrit %d point(s) de pénalité pour le permis auto à %s. Raison : %s",SpielerInfo[pID][sName],Anzahl,Grund);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        format(string,sizeof(string),"Le permis auto de %s a été retiré.",SpielerInfo[pID][sName]);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        return 1;
			 	}
	    	}
			else if(strcmp(Auswahl, "Motorradschein", true, strlen(Auswahl)) == 0)
	    	{
	    	    if(SpielerInfo[pID][sBikeLic] == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der angegebene Spieler besitzt kein Motorradschein.");
	    	    new Punkte = SpielerInfo[pID][stvoBikeLic]+Anzahl;
	    	    if(Punkte < 10)
	    	    {
	    	        SpielerInfo[pID][stvoBikeLic] += Anzahl;
	    	        format(string,sizeof(string),"%s %s t'a inscrit %d point(s) de pénalité pour le permis moto. Raison : %s",RangName(playerid),SpielerInfo[playerid][sName],Anzahl,Grund);
	    	        SendClientMessage(pID,COLOR_RED,string);
	    	        format(string,sizeof(string),"Tu as inscrit %d point(s) de pénalité pour le permis moto à %s. Raison : %s",SpielerInfo[pID][sName],Anzahl,Grund);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        return 1;
	    	    }
	    	    else
	    	    {
	    	        SpielerInfo[pID][stvoBikeLic] = 0;
	    	        SpielerInfo[pID][sBikeLic] = 0;
		        	format(string,sizeof(string),"%s %s t'a inscrit %d point(s) de pénalité pour le permis moto. Raison : %s",RangName(playerid),SpielerInfo[playerid][sName],Anzahl,Grund);
	    	        SendClientMessage(pID,COLOR_RED,string);
	    	        SendClientMessage(pID,COLOR_RED,"[Info]: {FFFFFF}Dir wurde dein Motorradschein entzogen, weil du mehr als 10 Strafpunkte oder 10 Strafpunkte hast.");
	    	        format(string,sizeof(string),"Tu as inscrit %d point(s) de pénalité pour le permis moto à %s. Raison : %s",SpielerInfo[pID][sName],Anzahl,Grund);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        format(string,sizeof(string),"Le permis moto de %s a été retiré.",SpielerInfo[pID][sName]);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        return 1;
			 	}
	    	}
			else if(strcmp(Auswahl, "Flugschein", true, strlen(Auswahl)) == 0)
	    	{
	    	    if(SpielerInfo[pID][sFlugLic] == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der angegebene Spieler besitzt kein Flugschein.");
	    	    new Punkte = SpielerInfo[pID][stvoFlugLic]+Anzahl;
	    	    if(Punkte < 10)
	    	    {
	    	        SpielerInfo[pID][stvoFlugLic] += Anzahl;
	    	        format(string,sizeof(string),"%s %s t'a inscrit %d point(s) de pénalité pour le permis de vol. Raison : %s",RangName(playerid),SpielerInfo[playerid][sName],Anzahl,Grund);
	    	        SendClientMessage(pID,COLOR_RED,string);
	    	        format(string,sizeof(string),"Tu as inscrit %d point(s) de pénalité pour le permis de vol à %s. Raison : %s",SpielerInfo[pID][sName],Anzahl,Grund);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        return 1;
	    	    }
	    	    else
	    	    {
	    	        SpielerInfo[pID][stvoFlugLic] = 0;
	    	        SpielerInfo[pID][sFlugLic] = 0;
		        	format(string,sizeof(string),"%s %s t'a inscrit %d point(s) de pénalité pour le permis de vol. Raison : %s",RangName(playerid),SpielerInfo[playerid][sName],Anzahl,Grund);
	    	        SendClientMessage(pID,COLOR_RED,string);
	    	        SendClientMessage(pID,COLOR_RED,"[Info]: {FFFFFF}Dir wurde dein Flugschein entzogen, weil du mehr als 10 Strafpunkte oder 10 Strafpunkte hast.");
	    	        format(string,sizeof(string),"Tu as inscrit %d point(s) de pénalité pour le permis de vol à %s. Raison : %s",SpielerInfo[pID][sName],Anzahl,Grund);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        format(string,sizeof(string),"Le permis de vol de %s a été retiré.",SpielerInfo[pID][sName]);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        return 1;
			 	}
	    	}
			else if(strcmp(Auswahl, "LKWschein", true, strlen(Auswahl)) == 0)
	    	{
	    	    if(SpielerInfo[pID][sTruckLic] == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der angegebene Spieler besitzt kein LKWschein.");
	    	    new Punkte = SpielerInfo[pID][stvoTruckLic]+Anzahl;
	    	    if(Punkte < 10)
	    	    {
	    	        SpielerInfo[pID][stvoTruckLic] += Anzahl;
	    	        format(string,sizeof(string),"%s %s t'a inscrit %d point(s) de pénalité pour le permis poids lourd. Raison : %s",RangName(playerid),SpielerInfo[playerid][sName],Anzahl,Grund);
	    	        SendClientMessage(pID,COLOR_RED,string);
	    	        format(string,sizeof(string),"Tu as inscrit %d point(s) de pénalité pour le permis poids lourd à %s. Raison : %s",SpielerInfo[pID][sName],Anzahl,Grund);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        return 1;
	    	    }
	    	    else
	    	    {
	    	        SpielerInfo[pID][stvoTruckLic] = 0;
	    	        SpielerInfo[pID][sTruckLic] = 0;
		        	format(string,sizeof(string),"%s %s t'a inscrit %d point(s) de pénalité pour le permis poids lourd. Raison : %s",RangName(playerid),SpielerInfo[playerid][sName],Anzahl,Grund);
	    	        SendClientMessage(pID,COLOR_RED,string);
	    	        SendClientMessage(pID,COLOR_RED,"[Info]: {FFFFFF}Dir wurde dein LKWschein entzogen, weil du mehr als 10 Strafpunkte oder 10 Strafpunkte hast.");
	    	        format(string,sizeof(string),"Tu as inscrit %d point(s) de pénalité pour le permis poids lourd à %s. Raison : %s",SpielerInfo[pID][sName],Anzahl,Grund);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        format(string,sizeof(string),"Le permis poids lourd de %s a été retiré.",SpielerInfo[pID][sName]);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        return 1;
			 	}
	    	}
			else if(strcmp(Auswahl, "Bootsschein", true, strlen(Auswahl)) == 0)
	    	{
	    	    if(SpielerInfo[pID][sBootLic] == 0)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Der angegebene Spieler besitzt kein Bootsschein.");
	    	    new Punkte = SpielerInfo[pID][stvoBootLic]+Anzahl;
	    	    if(Punkte < 10)
	    	    {
	    	        SpielerInfo[pID][stvoBootLic] += Anzahl;
	    	        format(string,sizeof(string),"%s %s t'a inscrit %d point(s) de pénalité pour le permis bateau. Raison : %s",RangName(playerid),SpielerInfo[playerid][sName],Anzahl,Grund);
	    	        SendClientMessage(pID,COLOR_RED,string);
	    	        format(string,sizeof(string),"Tu as inscrit %d point(s) de pénalité pour le permis bateau à %s. Raison : %s",SpielerInfo[pID][sName],Anzahl,Grund);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        return 1;
	    	    }
	    	    else
	    	    {
	    	        SpielerInfo[pID][stvoBootLic] = 0;
	    	        SpielerInfo[pID][sBootLic] = 0;
		        	format(string,sizeof(string),"%s %s t'a inscrit %d point(s) pour le permis bateau. Raison : %s",RangName(playerid),SpielerInfo[playerid][sName],Anzahl,Grund);
	    	        SendClientMessage(pID,COLOR_RED,string);
	    	        SendClientMessage(pID,COLOR_RED,"[Info]: {FFFFFF}Dir wurde dein Bootsschein entzogen, weil du mehr als 10 Strafpunkte oder 10 Strafpunkte hast.");
	    	        format(string,sizeof(string),"Tu as inscrit %d point(s) de pénalité pour le permis bateau à %s. Raison : %s",SpielerInfo[pID][sName],Anzahl,Grund);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        format(string,sizeof(string),"Le permis bateau de %s a été retiré.",SpielerInfo[pID][sName]);
	    	        SendClientMessage(playerid,COLOR_SUPER,string);
	    	        return 1;
			 	}
	    	}
			return 1;
		}
		else SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
		return 1;
	}
	else NichtBerechtigt
	return 1;
}


CMD:parkkralle(playerid,params[])
{
	new carid, string[144], Float:Position[3];
	if(SpielerInfo[playerid][sFraktion] != 7)return NichtBerechtigt
	if(GetPVarInt(playerid,"OAmtDuty") != 1)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
	if(IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Im Fahrzeug nicht möglich.");
	if(sscanf(params,"d",carid))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/parkkralle [FahrzeugID]");
	if(!IsValidVehicle(carid))return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Dieses Fahrzeug exestiert nicht.");
	if(carid == BankRobVan || carid == WaffenTransporter)return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Dieses Fahrzeug hat zu dicke Reifenprofile.");
	if(FahrzeugInfo[carid][fNebenjob] != 0 || FahrzeugInfo[carid][fAutohaus] != 0 || FahrzeugInfo[carid][fFahrschule] != 0 || FahrzeugInfo[carid][fSupmobil] != 0
	|| FahrzeugInfo[carid][fZiviroller] != 0 || FahrzeugInfo[carid][fImportCar] != 0 || FahrzeugInfo[carid][fKurrierCar] != 0)return SendClientMessage(playerid,COLOR_YELLOW,"[Info]: {FFFFFF}Du kannst an dieses Fahrzeug keine Parkkralle befestigen.");
	GetVehiclePos(carid,Position[0],Position[1],Position[2]);
	if(!IsPlayerInRangeOfPoint(playerid,5.0,Position[0],Position[1],Position[2]))return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du befindest an keinem Fahrzeug.");
	if(FahrzeugInfo[carid][fParkkralle] == 1)
	{
	    FahrzeugInfo[carid][fParkkralle] = 0;
		PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
		format(string, sizeof(string), "* %s %s retire le sabot du véhicule.", RangName(playerid),SpielerInfo[playerid][sName]);
		ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		return 1;
	}
	FahrzeugInfo[carid][fParkkralle] = 1;
	Motor[carid] = false;
	GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(carid, false, false, alarm, doors, bonnet, boot, objective);
	PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
	format(string, sizeof(string), "* %s %s installe un sabot sur le véhicule.", RangName(playerid),SpielerInfo[playerid][sName]);
	ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}


CMD:letzterfahrer(playerid,params[])
{
	if(SpielerInfo[playerid][sFraktion] >= 1 && SpielerInfo[playerid][sFraktion] < 9)
    {
        if(GetPVarInt(playerid,"CopDuty") == 1 || GetPVarInt(playerid,"FBIDuty") == 1 || GetPVarInt(playerid,"MedicDuty") == 1)
        {
 			new vehid, string[144];
		   	if(sscanf(params,"d",vehid))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: {FFFFFF}/letzterfahrer [FahrzeugID]");
		   	if(strlen(FahrzeugInfo[vehid][fLastDriver]) > 0)
		   	{
		        format(string,sizeof(string),"Le dernier conducteur du véhicule (ID:%d) était : %s",vehid,FahrzeugInfo[vehid][fLastDriver]);
		        SendClientMessage(playerid,COLOR_INFO,string);
			}
            else
            {
  		        format(string,sizeof(string),"Le dernier conducteur du véhicule (ID:%d) était : Personne",vehid);
		        SendClientMessage(playerid,COLOR_INFO,string);
            }
            return 1;
		}
		else SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Du bist nicht im Dienst.");
		return 1;
	}
	else NichtBerechtigt
	return 1;
}
alias:letzterfahrer("lf")