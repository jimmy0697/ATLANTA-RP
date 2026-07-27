stock ShowPlayerAchievement(playerid)
{
	for(new id = 0; id < 6; id++)
    {
    	PlayerTextDrawShow(playerid, AchievementDraw[playerid][id]);
	}
	return 1;
}

stock HideAchievement(playerid)
{
	for(new id = 0; id < 6; id++)
    {
    	PlayerTextDrawHide(playerid, AchievementDraw[playerid][id]);
	}
	return 1;
}


stock GiveTagesBelohnung(playerid)
{
	SpielerInfo[playerid][sLastTagesbelohnung] = gettime() + 86400;
	switch(SpielerInfo[playerid][sTagesbelohnung])
	{
	    case 0:
	    {
	        SendClientMessage(playerid,COLOR_INFO,"[Récompense quotidienne - Jour 1]: Tu as reçu +2.500$ !");
	        GivePlayerMoneyEx(playerid,2500);
	        SpielerInfo[playerid][sTagesbelohnung] = 1;
	        return 1;
	    }
	    case 1:
	    {
	        SendClientMessage(playerid,COLOR_INFO,"[Récompense quotidienne - Jour 2]: Tu as reçu une trousse de premiers secours gratuite ! Utilise-la en cas d'urgence avec \"/erstehilfe\".");
	        SpielerInfo[playerid][sPaket] = 1;
	        SpielerInfo[playerid][sTagesbelohnung] = 2;
	        return 1;
	    }
	    case 2:
	    {
			SendClientMessage(playerid,COLOR_INFO,"[Récompense quotidienne - Jour 3]: Tu as reçu +250 EXP !");
			GivePlayerEXP(playerid,250);
			SpielerInfo[playerid][sTagesbelohnung] = 3;
			return 1;
	    }
	    case 3:
	    {
            SendClientMessage(playerid,COLOR_INFO,"[Récompense quotidienne - Jour 4]: Tu as reçu +25 minutes sur ton payday !");
            SendClientMessage(playerid,COLOR_INFO,"[Récompense quotidienne - Jour 4]: Si tes minutes de payday dépassent 45, attends une minute.");
			SpielerInfo[playerid][sPayDay] += 25;
			SpielerInfo[playerid][sTagesbelohnung] = 4;
			return 1;
	    }
	    case 4:
	    {
			SendClientMessage(playerid,COLOR_INFO,"[Récompense quotidienne - Jour 5]: Tu as reçu +5.000$ !");
			GivePlayerMoneyEx(playerid,5000);
			SpielerInfo[playerid][sTagesbelohnung] = 5;
			return 1;
	    }
	    case 5:
	    {
			SendClientMessage(playerid,COLOR_INFO,"[Récompense quotidienne - Jour 6]: Tu as reçu +75 bouteilles consignées et un sac !");
			SpielerInfo[playerid][sPfandflaschen] += 75;
			SpielerInfo[playerid][sBeutel] += 1;
			SpielerInfo[playerid][sTagesbelohnung] = 6;
			return 1;
	    }
	    case 6:
	    {
	        if(SpielerInfo[playerid][sVIP] < 1)
	        {
	            SendClientMessage(playerid,COLOR_INFO,"[Récompense quotidienne - Jour 7]: Tu profites maintenant de tous les avantages VIP pendant 24 heures !");
	            GiveVIP(SpielerInfo[playerid][sName],1,"Tagesbelohnung");
	            SpielerInfo[playerid][sVIP] = 1;
		        if(SpielerInfo[playerid][sAchivVIP] < 1)
		        {
		            SpielerInfo[playerid][sAchivVIP] = 1;
					ShowAchievement(playerid,"Werde VIP Mitglied","+ 2250 EXP");
					GivePlayerEXP(playerid,2250);
		        }
			}
			else
			{
                SendClientMessage(playerid,COLOR_INFO,"[Récompense quotidienne - Jour 7]: Tu reçois à la place 350 EXP et 2.500$ !");
                GivePlayerEXP(playerid,350);
                GivePlayerMoneyEx(playerid,2500);
			}
	        SpielerInfo[playerid][sTagesbelohnung] = 0;
            return 1;
	    }
	}
	return 1;
}