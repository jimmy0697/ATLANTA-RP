stock AddNagelBand(playerid)
{
	new Float:x,Float:y,Float:z,Float:a;
 	GetPlayerPos(playerid,x,y,z);
  	GetPlayerFacingAngle(playerid,a);
   	for(new i=0;i<MAX_NAGELBAENDER;i++)
	{
	 	if(NagelBand[i][Erstellt] == false)
		{
		  	NagelBand[i][oPosX] = x;
		   	NagelBand[i][oPosY] = y;
		    NagelBand[i][oPosZ] = z;
		    NagelBand[i][Erstellt] = true;
		    NagelBand[i][ID] = CreateDynamicObject(2899,NagelBand[i][oPosX],NagelBand[i][oPosY],NagelBand[i][oPosZ]-0.9,0.0,0.0,a+90.0);
			SendClientMessage(playerid,COLOR_SUPER,"Tu as posé une bande à clous.");
			return i;
	    }
    }
    return SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Le nombre maximum de bandes à clous est atteint.");
}

stock RemoveNagelBand(playerid)
{
	for(new i=0;i<MAX_NAGELBAENDER;i++)
	{
	  	if(IsPlayerInRangeOfPoint(playerid,2,NagelBand[i][oPosX],NagelBand[i][oPosY],NagelBand[i][oPosZ]))
	   	{
		    if(NagelBand[i][Erstellt] == true)
		    {
			    NagelBand[i][Erstellt] = false;
			    NagelBand[i][oPosX] = -1;
			    NagelBand[i][oPosY] = -1;
			    NagelBand[i][oPosZ] = -1;
				DestroyDynamicObject(NagelBand[i][ID]);
				SendClientMessage(playerid,COLOR_SUPER,"Tu as retiré une bande à clous.");
				return i;
		    }
	    }
    }
    return SendClientMessage(playerid,COLOR_SUPER,"Tu ne te trouves près d'aucune bande à clous.");
}

stock RemoveAllNagelBand()
{
	for(new i=0;i<MAX_NAGELBAENDER;i++)
	{
	 	if(NagelBand[i][Erstellt] == true)
		{
			NagelBand[i][Erstellt] = false;
			NagelBand[i][oPosX] = -1;
			NagelBand[i][oPosY] = -1;
			NagelBand[i][oPosZ] = -1;
			DestroyDynamicObject(NagelBand[i][ID]);
		}
	}
 	return 1;
}

stock NagelBandCount()
{
	new index;
	for(new i=0;i<MAX_NAGELBAENDER;i++)
	{
	 	if(NagelBand[i][Erstellt] == true)
		index++;
	}
 	return index;
}

stock ReifenPlatt(tire1,tire2,tire3,tire4)
{
	return tire1 | (tire2 << 1) | (tire3 << 2) | (tire4 << 3);
}