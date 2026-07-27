// Player Commands
CMD:chainsaw(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne peux pas utiliser cette commande dans un véhicule.");
    if(!IsPlayerNearALogBuyer(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves pas près d'un acheteur de bois.");
	if(GetPlayerMoneyEx(playerid) < CSAW_PRICE) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu n'as pas assez d'argent.");
    if(SpielerInfo[playerid][sChainsaw]) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu possèdes déjà une tronçonneuse.");
    GivePlayerMoneyEx(playerid, -CSAW_PRICE);
    SpielerInfo[playerid][sChainsaw] = 1;
    
    new string[128];
    format(string, sizeof(string), "BÛCHERON: {FFFFFF}Tu as acheté une tronçonneuse pour {2ECC71}$%d {FFFFFF}.", CSAW_PRICE);
   	SendClientMessage(playerid, 0x3498DBFF, string);
	return 1;
}

CMD:log(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Cette commande ne peut pas être utilisée dans un véhicule.");
    if(isnull(params)) return SendClientMessage(playerid, 0xE88732FF, "UTILISE: {FFFFFF}/log [load/take/takefromcar/takefromtree/sell]");
    
    if(!strcmp(params, "load", true)) {
        // loading to a bobcat
        if(!CarryingLog[playerid]) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne portes aucune bûche.");
		new id = GetNearestVehicleEx(playerid);
		if(GetVehicleModel(id) != 422) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves pas près d'un Bobcat.");
		new Float: x, Float: y, Float: z;
    	GetVehicleBoot(id, x, y, z);
    	if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu n'es pas près de la benne.");
    	if(Vehicle_LogCount(id) >= LOG_LIMIT) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Ce véhicule ne peut plus charger de bûches.");
    	for(new i; i < LOG_LIMIT; i++)
    	{
    	    if(!IsValidDynamicObject(LogObjects[id][i]))
    	    {
    	        LogObjects[id][i] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    			AttachDynamicObjectToVehicle(LogObjects[id][i], id, LogAttachOffsets[i][0], LogAttachOffsets[i][1], LogAttachOffsets[i][2], 0.0, 0.0, LogAttachOffsets[i][3]);
    			break;
    	    }
    	}
    	
    	Streamer_Update(playerid);
    	Player_RemoveLog(playerid);
    	SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Tu as chargé une bûche.");
    	// done
    }else if(!strcmp(params, "take")) {
        // taking from ground
        if(CarryingLog[playerid]) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu portes déjà une bûche.");
		new id = GetClosestLog(playerid);
		if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves près d'aucune bûche.");
		LogData[id][logSeconds] = 1;
		RemoveLog(id);
		
		Player_GiveLog(playerid);
		SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Tu as ramassé une bûche.");
		// done
    }else if(!strcmp(params, "takefromcar")) {
        // taking from a bobcat
        if(CarryingLog[playerid]) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu portes déjà une bûche.");
        new id = GetNearestVehicleEx(playerid);
		if(GetVehicleModel(id) != 422) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves pas près d'un Bobcat.");
		new Float: x, Float: y, Float: z;
    	GetVehicleBoot(id, x, y, z);
    	if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu n'es pas près de la benne.");
    	if(Vehicle_LogCount(id) < 1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}La benne est vide.");
    	for(new i = (LOG_LIMIT - 1); i >= 0; i--)
    	{
    	    if(IsValidDynamicObject(LogObjects[id][i]))
    	    {
    	        DestroyDynamicObject(LogObjects[id][i]);
    	        LogObjects[id][i] = -1;
    			break;
    	    }
    	}

    	Streamer_Update(playerid);
    	Player_GiveLog(playerid);
        SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Tu as retiré une bûche de la benne.");
        // done
    }else if(!strcmp(params, "takefromtree")) {
		// taking from a cut tree
		if(CarryingLog[playerid]) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu portes déjà une bûche.");
        new id = GetClosestTree(playerid);
        if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves près d'aucun arbre.");
        if(TreeData[id][treeSeconds] < 1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}L'arbre n'a pas été abattu.");
        if(TreeData[id][treeLogs] < 1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Cet arbre n'a plus de bûches.");
        TreeData[id][treeLogs]--;
        Tree_UpdateLogLabel(id);
        
        Player_GiveLog(playerid);
        SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Tu as ramassé une bûche.");
        // done
    }else if(!strcmp(params, "sell")) {
        // selling a log
        if(!CarryingLog[playerid]) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne portes aucune bûche.");
		if(!IsPlayerNearALogBuyer(playerid)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves près d'aucun acheteur de bois.");
		Player_RemoveLog(playerid);
		GivePlayerMoneyEx(playerid, LOG_PRICE);

		UpdateEconomyValue(ECONOMY_TYPE_WOOD, 1);
		
		new string[128];
		format(string, sizeof(string), "BÛCHERON: {FFFFFF}Tu as vendu une bûche pour {2ECC71}$%d {FFFFFF}.", LOG_PRICE);
    	SendClientMessage(playerid, 0x3498DBFF, string);
        // done
    }

	return 1;
}

// Admin Commands - Trees
CMD:createtree(playerid, params[])
{
	if(SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new id = Iter_Free(Trees);
	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Impossible de placer d'autres arbres.");
 	new Float: x, Float: y, Float: z, Float: a;
 	GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
 	x += (3.0 * floatsin(-a, degrees));
	y += (3.0 * floatcos(-a, degrees));
	z -= 1.0;
	
	TreeData[id][treeX] = x;
	TreeData[id][treeY] = y;
	TreeData[id][treeZ] = z;
	TreeData[id][treeRX] = TreeData[id][treeRY] = TreeData[id][treeRZ] = 0.0;
	
	TreeData[id][treeObjID] = CreateDynamicObject(657, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ], TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);

	new label[256];
	format(label, sizeof(label), "Arbre (%d)\n\n{FFFFFF}Utilise {F1C40F}~k~~CONVERSATION_NO~ {FFFFFF}pour abattre l'arbre.", id);
	TreeData[id][treeLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ] + 1.5, 5.0);
	Iter_Add(Trees, id);
    
    new query[256];

    mysql_format(sqlHandle, query, sizeof(query), "INSERT INTO `wood_trees` (`ID`, `PosX`, `PosY`, `PosZ`, `RotX`, `RotY`, `RotZ`) VALUES (%i, %f, %f, %f, %f, %f, %f)",
    id, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ], TreeData[id][treeRX], TreeData[id][treeRY], TreeData[id][treeRZ]);
    mysql_tquery(sqlHandle, query);


    EditingTreeID[playerid] = id;
    EditDynamicObject(playerid, TreeData[id][treeObjID]);
    
    SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Arbre créé.");
    SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Tu peux maintenant modifier cet arbre, à tout moment.");
	return 1;
}

CMD:edittree(playerid, params[])
{
    if(SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
    if(EditingTreeID[playerid] != -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu modifies déjà un arbre.");
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, 0xE88732FF, "UTILISE: {FFFFFF}/edittree [id arbre]");
	if(!Iter_Contains(Trees, id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}ID invalide.");
	if(TreeData[id][treeGettingCut]) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Cet arbre ne peut pas être modifié car il est actuellement utilisé.");
	if(!IsPlayerInRangeOfPoint(playerid, 30.0, TreeData[id][treeX], TreeData[id][treeY], TreeData[id][treeZ])) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Tu ne te trouves pas près de cet arbre.");
	EditingTreeID[playerid] = id;
	EditDynamicObject(playerid, TreeData[id][treeObjID]);
	return 1;
}

CMD:removetree(playerid, params[])
{
    if(SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, 0xE88732FF, "UTILISE: {FFFFFF}/removetree [id arbre]");
	if(!Iter_Contains(Trees, id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}ID invalide.");
	if(TreeData[id][treeGettingCut]) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Cet arbre ne peut pas être retiré car il est actuellement utilisé.");
	if(Tree_BeingEdited(id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Cet arbre ne peut pas être retiré car il est en cours de modification.");
	DestroyDynamicObject(TreeData[id][treeObjID]);
	DestroyDynamic3DTextLabel(TreeData[id][treeLabel]);
	if(TreeData[id][treeTimer] != -1) KillTimer(TreeData[id][treeTimer]);
	
	TreeData[id][treeLogs] = TreeData[id][treeSeconds] = 0;
	TreeData[id][treeObjID] = TreeData[id][treeTimer] = -1;
	TreeData[id][treeLabel] = Text3D: -1;
	Iter_Remove(Trees, id);
	
    new query[128];

	mysql_format(sqlHandle, query, sizeof(query), "DELETE FROM `wood_trees` WHERE `ID` = %i", id);
    mysql_tquery(sqlHandle, query);

	SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Arbre retiré.");
	return 1;
}

// Admin Commands - Log Buyers
CMD:createwoodbuyer(playerid, params[])
{
	if(SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new skin;
	if(sscanf(params, "i", skin)) return SendClientMessage(playerid, 0xE88732FF, "UTILISE: {FFFFFF}/createwoodbuyer [id skin]");
	if(!(0 <= skin <= 311)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}ID de skin invalide."); 
	new id = Iter_Free(Buyers);
	if(id == -1) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}Impossible de créer d'autres vendeurs.");
	GetPlayerPos(playerid, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ]);
	GetPlayerFacingAngle(playerid, BuyerData[id][buyerA]);

	BuyerData[id][buyerActorID] = CreateActor(skin, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA]);
	SetActorInvulnerable(BuyerData[id][buyerActorID], true);
	
	new label[256];
	format(label, sizeof(label), "Acheteur de bois (%d)\n\n{FFFFFF}Utilise {F1C40F}/chainsaw {FFFFFF}pour acheter une tronçonneuse pour {2ECC71}$%d{FFFFFF}.\n{FFFFFF}Utilise {F1C40F}/log sell{FFFFFF} pour vendre une bûche pour {2ECC71}$%d{FFFFFF}.", id, CSAW_PRICE, LOG_PRICE);
	BuyerData[id][buyerLabel] = CreateDynamic3DTextLabel(label, 0xF1C40FFF, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ] + 0.25, 5.0, .testlos = 1);
	Iter_Add(Buyers, id);

    new query[256];

    mysql_format(sqlHandle, query, sizeof(query), "INSERT INTO `wood_buyers` (`ID`, `Skin`, `PosX`, `PosY`, `PosZ`, `PosA`) VALUES (%i, %i, %f, %f, %f, %f)",
    id, skin, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA]);
    mysql_tquery(sqlHandle, query);

	SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Acheteur de bois créé.");
	SetPlayerPos(playerid, BuyerData[id][buyerX] + (1.5 * floatsin(-BuyerData[id][buyerA], degrees)), BuyerData[id][buyerY] + (1.5 * floatcos(-BuyerData[id][buyerA], degrees)), BuyerData[id][buyerZ]);
	return 1;
}

CMD:setwoodbuyerskin(playerid, params[])
{
	if(SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new id, skin;
	if(sscanf(params, "ii", id, skin)) return SendClientMessage(playerid, 0xE88732FF, "UTILISE: {FFFFFF}/setwoodbuyerskin [id vendeur] [id skin]");
	if(!Iter_Contains(Buyers, id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}ID invalide.");
	if(!(0 <= skin <= 311)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}ID de skin invalide.");
	BuyerData[id][buyerSkin] = skin;
	
	DestroyActor(BuyerData[id][buyerActorID]);
	BuyerData[id][buyerActorID] = CreateActor(skin, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA]);
	SetActorInvulnerable(BuyerData[id][buyerActorID], true);

    new query[256];

    mysql_format(sqlHandle, query, sizeof(query), "UPDATE `wood_buyers` SET `Skin` = %i, `PosX`= %f, `PosY` = %f, `PosZ` = %f, `PosA` = %f WHERE `ID` = %i",
    skin, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA], id);
    mysql_tquery(sqlHandle, query);

    SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Acheteur de bois modifié avec succès.");
	return 1;
}

CMD:setwoodbuyerpos(playerid, params[])
{
	if(SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, 0xE88732FF, "UTILISE: {FFFFFF}/setwoodbuyerpos [id vendeur]");
	if(!Iter_Contains(Buyers, id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}ID invalide.");
	GetPlayerPos(playerid, BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ]);
	GetPlayerFacingAngle(playerid, BuyerData[id][buyerA]);

	DestroyActor(BuyerData[id][buyerActorID]);
	BuyerData[id][buyerActorID] = CreateActor(BuyerData[id][buyerSkin], BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA]);
	SetActorInvulnerable(BuyerData[id][buyerActorID], true);

    Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BuyerData[id][buyerLabel], E_STREAMER_X, BuyerData[id][buyerX]);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BuyerData[id][buyerLabel], E_STREAMER_Y, BuyerData[id][buyerY]);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BuyerData[id][buyerLabel], E_STREAMER_Z, BuyerData[id][buyerZ] + 0.25);

	new query[256];

    mysql_format(sqlHandle, query, sizeof(query), "UPDATE `wood_buyers` SET `PosX`= %f, `PosY` = %f, `PosZ` = %f, `PosA` = %f WHERE `ID` = %i",
    BuyerData[id][buyerX], BuyerData[id][buyerY], BuyerData[id][buyerZ], BuyerData[id][buyerA], id);
    mysql_tquery(sqlHandle, query);

	SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Acheteur de bois modifié.");
    SetPlayerPos(playerid, BuyerData[id][buyerX] + (1.5 * floatsin(-BuyerData[id][buyerA], degrees)), BuyerData[id][buyerY] + (1.5 * floatcos(-BuyerData[id][buyerA], degrees)), BuyerData[id][buyerZ]);
	return 1;
}

CMD:removewoodbuyer(playerid, params[])
{
	if(SpielerInfo[playerid][sAdmin] < 4)return NichtBerechtigt
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, 0xE88732FF, "UTILISE: {FFFFFF}/removewoodbuyer [ID Vendeur]");
	if(!Iter_Contains(Buyers, id)) return SendClientMessage(playerid, 0xE74C3CFF, "ERREUR: {FFFFFF}ID invalide.");
	DestroyActor(BuyerData[id][buyerActorID]);
	DestroyDynamic3DTextLabel(BuyerData[id][buyerLabel]);
	
	BuyerData[id][buyerActorID] = -1;
	BuyerData[id][buyerLabel] = Text3D: -1;
	Iter_Remove(Buyers, id);
	
    new query[128];

	mysql_format(sqlHandle, query, sizeof(query), "DELETE FROM `wood_buyers` WHERE `ID` = %i", id);
    mysql_tquery(sqlHandle, query);

    SendClientMessage(playerid, 0x3498DBFF, "BÛCHERON: {FFFFFF}Acheteur de bois retiré.");
	return 1;
}