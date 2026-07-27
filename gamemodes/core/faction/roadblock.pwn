stock AddSperre(playerid,id,Float:x,Float:y,Float:z,Float:a)
{
   	for(new i=0;i<MAX_SPERREN;i++)
	{
	 	if(RoadBlock[i][Erstellt] == false)
		{
		  	RoadBlock[i][oPosX] = x;
		   	RoadBlock[i][oPosY] = y;
		    RoadBlock[i][oPosZ] = z;
		    RoadBlock[i][Erstellt] = true;
		    RoadBlock[i][ID] = CreateDynamicObject(id,RoadBlock[i][oPosX],RoadBlock[i][oPosY],RoadBlock[i][oPosZ],0.0,0.0,a);
			SendClientMessage(playerid,COLOR_SUPER,"Tu as installé un barrage routier.");
			return i;
	    }
    }
    return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Le nombre maximum de barrages routiers est atteint.");
}

stock RemoveSperre(playerid)
{
	for(new i=0;i<MAX_SPERREN;i++)
 	{
	  	if(IsPlayerInRangeOfPoint(playerid,2.0,RoadBlock[i][oPosX],RoadBlock[i][oPosY],RoadBlock[i][oPosZ]))
	   	{
		    if(RoadBlock[i][Erstellt] == true)
		    {
			    RoadBlock[i][Erstellt] = false;
			    RoadBlock[i][oPosX] = -1;
			    RoadBlock[i][oPosY] = -1;
			    RoadBlock[i][oPosZ] = -1;
				DestroyDynamicObject(RoadBlock[i][ID]);
				SendClientMessage(playerid,COLOR_SUPER,"Tu as retiré un barrage routier.");
				new string[128];
				format(string,sizeof(string),"* %s %s démonte un barrage.",RangName(playerid),SpielerInfo[playerid][sName]);
				ProxDetector(12, playerid, string,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				return i;
		    }
	    }
    }
    return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Tu ne te trouves près d'aucun barrage routier.");
}

stock RemoveAllSperre()
{
	for(new i=0;i<MAX_SPERREN;i++)
 	{
	 	if(RoadBlock[i][Erstellt] == true)
		{
			RoadBlock[i][Erstellt] = false;
			RoadBlock[i][oPosX] = -1;
			RoadBlock[i][oPosY] = -1;
			RoadBlock[i][oPosZ] = -1;
			DestroyDynamicObject(RoadBlock[i][ID]);
		}
	}
 	return 1;
}

stock SperreCount()
{
	new index;
	for(new i=0;i<MAX_SPERREN;i++)
 	{
	 	if(RoadBlock[i][Erstellt] == true)
		index++;
	}
 	return index;
}