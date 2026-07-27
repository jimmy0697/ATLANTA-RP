CMD:makeadm(playerid,params[])
{
	if(SpielerInfo[playerid][sAdmin] == 5 || IsPlayerAdmin(playerid))
	{
		new pID, Rang, string[128];
		if(sscanf(params,"ui",pID,Rang))return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: /makeadmin [SpielerID] [Rang]");
	    if(Rang > 5 || Rang < 0)return SendClientMessage(playerid,COLOR_YELLOW,"Benutze: /makeadmin [SpielerID] [Rang(1-5)]");
	    if(!IsPlayerConnectedEx(pID))return NichtOnline
	    SpielerInfo[pID][sAdmin] = Rang;
	    if(Rang != 0)
	    {
		    format(string,128,"%s %s a nommé %s '%s'. Bienvenue dans l'équipe !",AdminName(playerid),SpielerInfo[playerid][sName],SpielerInfo[pID][sName],AdminName(pID));
			SendAdminMessage(COLOR_INFO,string);

			givePlayerTitle(pID, TITLE_TEAMMEMBER);
		}
		else if(Rang == 0)
		{
		    if(GetPVarInt(pID,"AdminDuty") > 0)
			{
			    SetPlayerHealth(pID,100);
	  			if(GetPVarInt(pID,"Supmobil") != 0)
		    	{
					DeleteVehicle(GetPVarInt(pID,"Supmobil"));
					DeletePVar(pID,"Supmobil");
					SendClientMessage(pID,COLOR_RED,"Supmobil wurde gelöscht.");
				}
	   			format(string,sizeof(string),"%s",SpielerInfo[pID][sName]);
			    SetPlayerName(pID, string);
				DeletePVar(pID,"AdminDuty");
				DestroyDynamic3DTextLabel(AdmDutyLabel[playerid]);
			}

		    format(string,128,"%s %s a nommé %s '%s'. Il ne fait plus partie de l'équipe.",AdminName(playerid),SpielerInfo[playerid][sName],SpielerInfo[pID][sName],AdminName(pID));
			SendAdminMessage(COLOR_INFO,string);
			format(string,128,"%s %s t'a nommé '%s'. Tu ne fais plus partie de l'équipe.",AdminName(playerid),SpielerInfo[playerid][sName],AdminName(pID));
			SendClientMessage(pID,COLOR_INFO,string);
		}
		new log_admstring[128];
		format(log_admstring,sizeof(log_admstring),"%s %s a utilisé la commande '/makeadmin'. [%d]",AdminName(playerid),SpielerInfo[playerid][sName],GetPVarInt(playerid,"AdminDuty"));
		CreateServerLogEntry("ADMIN_LOG", log_admstring);
		return 1;
	}
	else NichtBerechtigt
	return 1;
}