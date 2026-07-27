stock SaveHauser()
{
	new query[364];
	for(new mf=1;mf<MAX_HAUSER;mf++)
    {
        if(HausInfo[mf][hsErstellt] == false)continue;
   		mysql_format(sqlHandle, query,sizeof query,"UPDATE `hauser` SET `Besitzer`='%s', `Preis`='%d', `Ort`='%d', `Typ`='%d', `Interior`='%d', `Locked`='%d', `Mietbar`='%d', `Miete`='%d', `Health`='%d' WHERE `ID`='%d'",
	    HausInfo[mf][hsBesitzer],HausInfo[mf][hsPreis],HausInfo[mf][hsOrt],HausInfo[mf][hsTyp],HausInfo[mf][hsInterior],HausInfo[mf][hsLocked],HausInfo[mf][hsMietbar],HausInfo[mf][hsMiete],HausInfo[mf][hsHealth],mf);
		mysql_tquery(sqlHandle, query);
	}
	return 1;
}

stock SaveHouseById(mf) {
	new query[364];
	if(HausInfo[mf][hsErstellt] == false) return 1;
	mysql_format(sqlHandle, query,sizeof query,"UPDATE `hauser` SET `Besitzer`='%s', `Preis`='%d', `Ort`='%d', `Typ`='%d', `Interior`='%d', `Locked`='%d', `Mietbar`='%d', `Miete`='%d', `Health`='%d' WHERE `ID`='%d'",
	HausInfo[mf][hsBesitzer],HausInfo[mf][hsPreis],HausInfo[mf][hsOrt],HausInfo[mf][hsTyp],HausInfo[mf][hsInterior],HausInfo[mf][hsLocked],HausInfo[mf][hsMietbar],HausInfo[mf][hsMiete],HausInfo[mf][hsHealth],mf);
	mysql_tquery(sqlHandle, query);
	return 1;
}

stock AnHaus(playerid)
{
	for(new ts = 1;ts<MAX_HAUSER;ts++)
    {
		if(IsPlayerInRangeOfPoint(playerid, 1.5, HausInfo[ts][hsPos_X], HausInfo[ts][hsPos_Y], HausInfo[ts][hsPos_Z]))
		{
 	    	return 1;
		}
	}
	return 0;
}

stock GetNearHausID(playerid)
{
	for(new ts = 1;ts<MAX_HAUSER;ts++)
    {
		if(IsPlayerInRangeOfPoint(playerid, 3.0, HausInfo[ts][hsPos_X], HausInfo[ts][hsPos_Y], HausInfo[ts][hsPos_Z]))return ts;
	}
	return -1;
}

stock GetHausID(playerid)
{
	if(SpielerInfo[playerid][sHaus] != 0 && SpielerInfo[playerid][sSpawn] == 2)
	{
	    return SpielerInfo[playerid][sHaus];
	}
	else if(SpielerInfo[playerid][sGHaus] != 0 && SpielerInfo[playerid][sSpawn] == 3)
	{
	    return SpielerInfo[playerid][sGHaus];
	}
	else if(SpielerInfo[playerid][sMieter] != 0 && SpielerInfo[playerid][sSpawn] == 2)
	{
	    return SpielerInfo[playerid][sMieter];
	}
    return -1;
}

public LoadHauser()
{
    new hausinfos;
	new hs = 1;
	new var[24], Text[224];

	new Cache:result = mysql_query(sqlHandle, "SELECT * FROM `hauser` ORDER BY `ID` ASC");

	for(new i = 0; i < cache_num_rows(); i++)
	{
		cache_get_value_name(i, "ID",var);	hs = strval(var); HausInfo[hs][hsID] = hs;
		cache_get_value_name(i, "Besitzer",HausInfo[hs][hsBesitzer]);
		cache_get_value_name(i, "Preis",var); HausInfo[hs][hsPreis] = strval(var);
		cache_get_value_name(i, "Ort",var); HausInfo[hs][hsOrt] = strval(var);
		cache_get_value_name(i, "Typ",var); HausInfo[hs][hsTyp] = strval(var);
		cache_get_value_name(i, "Interior",var); HausInfo[hs][hsInterior] = strval(var);
		cache_get_value_name(i, "Locked",var); HausInfo[hs][hsLocked] = strval(var);
		cache_get_value_name(i, "Mietbar",var); HausInfo[hs][hsMietbar] = strval(var);
		cache_get_value_name(i, "Miete",var); HausInfo[hs][hsMiete] = strval(var);
		cache_get_value_name(i, "Health",var); HausInfo[hs][hsHealth] = strval(var);
		cache_get_value_name(i, "Pos_X",var); HausInfo[hs][hsPos_X] = floatstr(var);
		cache_get_value_name(i, "Pos_Y",var); HausInfo[hs][hsPos_Y] = floatstr(var);
		cache_get_value_name(i, "Pos_Z",var); HausInfo[hs][hsPos_Z] = floatstr(var);
		cache_get_value_name(i, "IPos_X",var); HausInfo[hs][hsIPos_X] = floatstr(var);
		cache_get_value_name(i, "IPos_Y",var); HausInfo[hs][hsIPos_Y] = floatstr(var);
		cache_get_value_name(i, "IPos_Z",var); HausInfo[hs][hsIPos_Z] = floatstr(var);
		cache_get_value_name(i, "Gruppe",var); HausInfo[hs][hsGruppe] = strval(var);
		cache_get_value_name(i, "GruppenAnzeige",var); HausInfo[hs][hsGruppeAnzeige] = strval(var);
        if(strlen(HausInfo[hs][hsBesitzer]) < 2)
		{
		    if(HausInfo[hs][hsTyp] == 1)//Appartment
		    {
   				format(Text, sizeof(Text), "Appartement 'ID : {FF0000}%d{FFFFFF}' à vendre !\nPropriétaire : {FF0000}État{FFFFFF}\nPrix : {FF0000}%d${FFFFFF}\nUtilise '{FF0000}/kaufen{FFFFFF}'\npour acheter cet appartement", hs, HausInfo[hs][hsPreis]);
			}
			else if(HausInfo[hs][hsTyp] == 2)//Haus
   			{
  				format(Text, sizeof(Text), "Maison 'ID : {FF0000}%d{FFFFFF}' à vendre !\nPropriétaire : {FF0000}État{FFFFFF}\nPrix : {FF0000}%d${FFFFFF}\nUtilise '{FF0000}/kaufen{FFFFFF}'\npour acheter cette maison", hs, HausInfo[hs][hsPreis]);
   			}
   			else if(HausInfo[hs][hsTyp] == 3)//Villa
   			{
  				format(Text, sizeof(Text), "Villa 'ID : {FF0000}%d{FFFFFF}' à vendre !\nPropriétaire : {FF0000}État{FFFFFF}\nPrix : {FF0000}%d${FFFFFF}\nUtilise '{FF0000}/kaufen{FFFFFF}'\npour acheter cette villa", hs, HausInfo[hs][hsPreis]);
   			}
   			HausInfo[hs][hsPickup] = CreateDynamicPickup(1273, 23, HausInfo[hs][hsPos_X], HausInfo[hs][hsPos_Y], HausInfo[hs][hsPos_Z], -1);
      	}
       	else
  		{
  		    if(HausInfo[hs][hsMietbar] == 0)
  		    {
				if(HausInfo[hs][hsGruppe] > 0 && HausInfo[hs][hsGruppeAnzeige] > 0)
				{
				    if(HausInfo[hs][hsTyp] == 1)//Appartment
				    {
		    			format(Text, sizeof(Text), "Appartement 'ID : {FF0000}%d{FFFFFF}'\nPropriétaire : {FF0000}%s", hs, GruppenInfo[HausInfo[hs][hsGruppe]][gName]);
					}
					else if(HausInfo[hs][hsTyp] == 2)//Haus
		   			{
		   				format(Text, sizeof(Text), "Maison 'ID : {FF0000}%d{FFFFFF}'\nPropriétaire : {FF0000}%s", hs, GruppenInfo[HausInfo[hs][hsGruppe]][gName]);
		   			}
		   			else if(HausInfo[hs][hsTyp] == 3)//Villa
		   			{
		   				format(Text, sizeof(Text), "Villa 'ID : {FF0000}%d{FFFFFF}'\nPropriétaire : {FF0000}%s", hs, GruppenInfo[HausInfo[hs][hsGruppe]][gName]);
		   			}
				}
				else
				{
		    		if(HausInfo[hs][hsTyp] == 1)//Appartment
				    {
		    			format(Text, sizeof(Text), "Appartement 'ID : {FF0000}%d{FFFFFF}'\nPropriétaire : {FF0000}%s", hs, HausInfo[hs][hsBesitzer]);
					}
					else if(HausInfo[hs][hsTyp] == 2)//Haus
		   			{
		   				format(Text, sizeof(Text), "Maison 'ID : {FF0000}%d{FFFFFF}'\nPropriétaire : {FF0000}%s", hs, HausInfo[hs][hsBesitzer]);
		   			}
		   			else if(HausInfo[hs][hsTyp] == 3)//Villa
		   			{
		   				format(Text, sizeof(Text), "Villa 'ID : {FF0000}%d{FFFFFF}'\nPropriétaire : {FF0000}%s", hs, HausInfo[hs][hsBesitzer]);
		   			}
				}
			}
			else
			{
 				if(HausInfo[hs][hsTyp] == 1)//Appartment
			    {
	    			format(Text, sizeof(Text), "Appartement 'ID : {FF0000}%d{FFFFFF}'\nPropriétaire : {FF0000}%s{FFFFFF}\nLoyer : {FF0000}%d${FFFFFF}\nUtilise '{FF0000}/mieten{FFFFFF}' pour\nlouer ici", hs, HausInfo[hs][hsBesitzer], HausInfo[hs][hsMiete]);
				}
				else if(HausInfo[hs][hsTyp] == 2)//Haus
	   			{
	   				format(Text, sizeof(Text), "Maison 'ID : {FF0000}%d{FFFFFF}'\nPropriétaire : {FF0000}%s{FFFFFF}\nLoyer :	{FF0000}%d${FFFFFF}\nUtilise '{FF0000}/mieten{FFFFFF}' pour\nlouer ici", hs, HausInfo[hs][hsBesitzer], HausInfo[hs][hsMiete]);
	   			}
	   			else if(HausInfo[hs][hsTyp] == 3)//Villa
	   			{
	   				format(Text, sizeof(Text), "Villa 'ID : {FF0000}%d{FFFFFF}'\nPropriétaire : {FF0000}%s{FFFFFF}\nLoyer : {FF0000}%d${FFFFFF}\nUtilise '{FF0000}/mieten{FFFFFF}' pour\nlouer ici", hs, HausInfo[hs][hsBesitzer], HausInfo[hs][hsMiete]);
	   			}
			}
			HausInfo[hs][hsPickup] = CreateDynamicPickup(1272, 23, HausInfo[hs][hsPos_X], HausInfo[hs][hsPos_Y], HausInfo[hs][hsPos_Z], -1);
       	}
		HausInfo[hs][hsText] = CreateDynamic3DTextLabel(Text, COLOR_WHITE, HausInfo[hs][hsPos_X], HausInfo[hs][hsPos_Y], HausInfo[hs][hsPos_Z], 10.0);
		HausInfo[hs][hsErstellt] = true;
		hausinfos++;
	}
	cache_delete(result);
	printf(" Es wurden %d Haeuser erfolgreich geladen und erstellt.",hausinfos);
}

stock HausLocked(playerid)
{
	new hsinfo[35], hs = SpielerInfo[playerid][sHaus];
	switch(HausInfo[hs][hsLocked])
	{
	    case 0:{hsinfo="{9ACD32}Déverrouillée";}
		case 1:{hsinfo="{FF0000}Verrouillée";}
	}
	return hsinfo;
}

stock GHausLocked(playerid)
{
	new hsinfo[35], hs = SpielerInfo[playerid][sGHaus];
	switch(HausInfo[hs][hsLocked])
	{
	    case 0:{hsinfo="{9ACD32}Déverrouillée";}
		case 1:{hsinfo="{FF0000}Verrouillée";}
	}
	return hsinfo;
}

stock HausMietbar(playerid)
{
	new hsinfo[35], hs = SpielerInfo[playerid][sHaus];
	switch(HausInfo[hs][hsMietbar])
	{
	    case 0:{hsinfo="{9ACD32}Non";}
		case 1:{hsinfo="{FF0000}Ja";}
	}
	return hsinfo;
}