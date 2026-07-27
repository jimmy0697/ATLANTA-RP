
public TheoriAufgaben(playerid)
{
	ClearChat(playerid,10);
	if(GetPVarInt(playerid,"TheoriTest") == 1)
	{
	    SetPVarInt(playerid,"TheoriTest",2);
		SendClientMessage(playerid, COLOR_RED, "|_____________________~ Question 1/4 ~_____________________|");
	  	SendClientMessage(playerid, COLOR_WHITE, "Sur quelle voie as-tu le droit de dépasser un autre véhicule ?");
	  	SendClientMessage(playerid, COLOR_RED, "_________________________________________________________");
	 	SendClientMessage(playerid, COLOR_WHITE, "A : Gauche");//Richtig
	   	SendClientMessage(playerid, COLOR_WHITE, "B : Droite");
	   	SendClientMessage(playerid, COLOR_WHITE, "C : Les deux");
   	}
	else if(GetPVarInt(playerid,"TheoriTest") == 2)
	{
	    SetPVarInt(playerid,"TheoriTest",3);
		SendClientMessage(playerid, COLOR_RED, "|_____________________~ Question 2/4 ~_____________________|");
		SendClientMessage(playerid, COLOR_WHITE, "Quelle est la limite de vitesse en ville ?");
		SendClientMessage(playerid, COLOR_RED, "_________________________________________________________");
		SendClientMessage(playerid, COLOR_WHITE, "A : Il n'y a pas de limite, on s'adapte");
		SendClientMessage(playerid, COLOR_WHITE, "B : Jusqu'à 90 KM/H sur route et en ville");
		SendClientMessage(playerid, COLOR_WHITE, "C : 90 KM/H maximum en ville, recommandé max. 160 KM/H hors agglomération");//Richtig
	}
	else if(GetPVarInt(playerid,"TheoriTest") == 3)
	{
        SetPVarInt(playerid,"TheoriTest",4);
		SendClientMessage(playerid, COLOR_RED, "|_____________________~ Question 3/4 ~_____________________|");
		SendClientMessage(playerid, COLOR_WHITE, "Que dois-tu faire si tu croises un véhicule d'intervention ?");
		SendClientMessage(playerid, COLOR_RED, "_________________________________________________________");
		SendClientMessage(playerid, COLOR_WHITE, "A : Klaxonner pour prévenir les autres conducteurs");
		SendClientMessage(playerid, COLOR_WHITE, "B : Prévenir la police et prier pour de l'aide");
		SendClientMessage(playerid, COLOR_WHITE, "C : Se ranger à droite et faire de la place");//Richtig
	}
	else if(GetPVarInt(playerid,"TheoriTest") == 4)
	{
        SetPVarInt(playerid,"TheoriTest",5);
		SendClientMessage(playerid, COLOR_RED, "|_____________________~ Question 4/4 ~_____________________|");
		SendClientMessage(playerid, COLOR_WHITE, "Combien de temps peux-tu garer ton véhicule sur le bord de la route ?");
		SendClientMessage(playerid, COLOR_RED, "_________________________________________________________");
		SendClientMessage(playerid, COLOR_WHITE, "A : Il n'y a pas de règle, c'est à ma discrétion");
		SendClientMessage(playerid, COLOR_WHITE, "B : 3 minutes maximum, sauf en cas de panne");//Richtig
		SendClientMessage(playerid, COLOR_WHITE, "C : Seulement 5 minutes, plus si je me gare à côté d'un parking");
	}
	else if(GetPVarInt(playerid,"TheoriTest") == 5)
	{
        SetPVarInt(playerid,"TheoriTest",6);
	}
}

public TheoriFlugAufgaben(playerid)
{
	ClearChat(playerid,10);
	if(GetPVarInt(playerid,"TheoriTest") == 1)
	{
	    SetPVarInt(playerid,"TheoriTest",2);
		SendClientMessage(playerid, COLOR_RED, "|_____________________~ Question 1/4 ~_____________________|");
	  	SendClientMessage(playerid, COLOR_WHITE, "Laquelle des règles suivantes existe ?");
	  	SendClientMessage(playerid, COLOR_RED, "_________________________________________________________");
	 	SendClientMessage(playerid, COLOR_WHITE, "A : Interdiction de vol à basse altitude");//Richtig
	   	SendClientMessage(playerid, COLOR_WHITE, "B : Autorisation de vol à basse altitude");
	   	SendClientMessage(playerid, COLOR_WHITE, "C : Il n'y a aucune règle en vol");
   	}
	else if(GetPVarInt(playerid,"TheoriTest") == 2)
	{
	    SetPVarInt(playerid,"TheoriTest",3);
		SendClientMessage(playerid, COLOR_RED, "|_____________________~ Question 2/4 ~_____________________|");
		SendClientMessage(playerid, COLOR_WHITE, "Où est-il autorisé d'atterrir ?");
		SendClientMessage(playerid, COLOR_RED, "_________________________________________________________");
		SendClientMessage(playerid, COLOR_WHITE, "A : On peut atterrir n'importe où");
		SendClientMessage(playerid, COLOR_WHITE, "B : Uniquement à l'aéroport et sur terrain dégagé");
		SendClientMessage(playerid, COLOR_WHITE, "C : Uniquement dans les aéroports et hélisurfaces désignées");//Richtig
	}
	else if(GetPVarInt(playerid,"TheoriTest") == 3)
	{
        SetPVarInt(playerid,"TheoriTest",4);
		SendClientMessage(playerid, COLOR_RED, "|_____________________~ Question 3/4 ~_____________________|");
		SendClientMessage(playerid, COLOR_WHITE, "As-tu le droit de voler la nuit ?");
		SendClientMessage(playerid, COLOR_RED, "_________________________________________________________");
		SendClientMessage(playerid, COLOR_WHITE, "A : Non, le vol de nuit est interdit");
		SendClientMessage(playerid, COLOR_WHITE, "B : Oui, mais seulement avec une licence de vol de nuit");
		SendClientMessage(playerid, COLOR_WHITE, "C : Oui, en faisant simplement plus attention");//Richtig
	}
	else if(GetPVarInt(playerid,"TheoriTest") == 4)
	{
        SetPVarInt(playerid,"TheoriTest",5);
		SendClientMessage(playerid, COLOR_RED, "|_____________________~ Question 4/4 ~_____________________|");
		SendClientMessage(playerid, COLOR_WHITE, "Existe-t-il une zone d'interdiction de vol ? Si oui, laquelle ?");
		SendClientMessage(playerid, COLOR_RED, "_________________________________________________________");
		SendClientMessage(playerid, COLOR_WHITE, "A : Non, ça n'existe pas");
		SendClientMessage(playerid, COLOR_WHITE, "B : Oui. Ce sont les bâtiments d'État comme la police et le gouvernement");//Richtig
		SendClientMessage(playerid, COLOR_WHITE, "C : Oui, mais je peux la survoler sans problème");
	}
	else if(GetPVarInt(playerid,"TheoriTest") == 5)
	{
        SetPVarInt(playerid,"TheoriTest",6);
	}
}

public Praxis(playerid)
{
    SetPVarInt(playerid,"FahrschulStunde",1);
    TogglePlayerControllable(playerid,true);
}