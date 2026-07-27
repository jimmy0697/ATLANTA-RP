#define IsPlayerBoxing(%0) 			(g_boxingPlayerData[ %0 ] [ E_FIGHTING ])
#define SendBoxing(%0,%1) 			(SendClientMessage( %0, -1, "{B74AFF}[BOXING] {FFFFFF}" # %1))
#define SendBoxingGlobal(%0) 		(SendClientMessage( INVALID_PLAYER_ID, -1, "{B74AFF}[BOXING] {FFFFFF}" # %0))
#define IsPlayerNearBoxingArena(%0) (GetPlayerDistanceFromPoint( %0, 2654.885986, 1613.157958, 1506.269042 ) < 25.0)

/* ** Variables ** */
enum E_BOXER_DATA {
	bool: E_FIGHTING,
	E_OPPONENT,
	bool: E_INVITED,
	E_INVITE_TIMESTAMP,
	E_ROUNDS_SET,
	E_BET_AMOUNT_SET,
	bool: E_IS_HOST,
	E_SCORE,
	Float: E_PRIOR_HEALTH,
	Float: E_PRIOR_ARMOUR,
	E_PRIOR_WEP[ 12 ],
	E_PRIOR_WEP_AMMO[ 12 ],
	E_PRIOR_SKIN
};

enum E_ARENA_DATA {
	bool: E_OCCUPIED,
	E_CD_TIMER,
	E_CURRENT_ROUNDS,
	E_ROUNDS,
	E_BET
};

new g_boxingPlayerData 				[ MAX_PLAYERS ] [ E_BOXER_DATA ];
new g_boxingArenaData 				[ E_ARENA_DATA ];
new Text3D: arenaLabel 				= Text3D: INVALID_3DTEXT_ID;

/* ** Hooks ** */
Boxing_Init() {
	arenaLabel = CreateDynamic3DTextLabel( "Boxing Arena\n{FFFFFF}/boxing fight", COLOR_GREY, 2655.3022, 1613.6146, 1507.0977, 15.0 );
	return 1;
}

Boxer_OnPlayerConnect(playerid) {
	g_boxingPlayerData[ playerid ] [ E_FIGHTING ] = false;
	g_boxingPlayerData[ playerid ] [ E_OPPONENT ] = -1;
	g_boxingPlayerData[ playerid ] [ E_INVITED ] = false;
	g_boxingPlayerData[ playerid ] [ E_ROUNDS_SET ] = 1;
	g_boxingPlayerData[ playerid ] [ E_BET_AMOUNT_SET ] = 0;
	g_boxingPlayerData[ playerid ] [ E_IS_HOST ] = false;
	g_boxingPlayerData[ playerid ] [ E_SCORE ] = 0;
	return 1;
}

Boxer_OnPlayerDisconnect(playerid) {
	boxing_ForfeitMatch( playerid, g_boxingPlayerData[ playerid ] [ E_OPPONENT ] );
	return 1;
}


Boxer_OnPlayerDeath(playerid)
{
	boxing_ForfeitMatch( playerid, g_boxingPlayerData[ playerid ] [ E_OPPONENT ] );
	return 1;
}

/* ** Commands ** */
CMD:boxing( playerid, params[ ] ) {

	if ( !IsPlayerNearBoxingArena( playerid ) )
		return SendClientMessage( playerid, COLOR_RED, "Tu dois te trouver à l'arène de boxe." );

	if ( g_boxingArenaData[ E_OCCUPIED ] == true )
		return SendClientMessage( playerid, COLOR_RED, "L'arène est actuellement occupée, attends la fin du combat." );

	if ( GetPlayerWantedLevelEx( playerid ) )
		return SendClientMessage( playerid, COLOR_RED, "Tu ne peux pas participer à un combat de boxe si tu es recherché." );

	if ( !strcmp( params, "fight", true, 5 ) ) {

		new targetID, betAmount, rounds;

		if ( g_boxingPlayerData[ playerid ] [ E_FIGHTING ] == true )
			return SendClientMessage( playerid, COLOR_RED, "Tu es déjà en train de combattre. Termine d'abord ton combat actuel." );

		if ( sscanf( params[ 6 ], "uD(0)D(3)", targetID, betAmount, rounds ) )
			return SendClientMessage( playerid, COLOR_YELLOW, "Utilise : /boxing fight [ID_JOUEUR] [Mise (0)] [Rounds (3)]" );

		if ( ! IsPlayerConnected( targetID ) )
			return SendClientMessage( playerid, COLOR_RED, "Ce joueur n'est pas en ligne." );

		if ( targetID == playerid )
			return SendClientMessage( playerid, COLOR_RED, "Tu ne peux pas te défier toi-même." );

		if ( !IsPlayerNearBoxingArena( targetID ) )
			return SendClientMessage( playerid, COLOR_RED, "Le joueur sélectionné ne se trouve pas à l'arène de boxe." );

		if ( GetPlayerMoneyEx( targetID ) < betAmount )
			return SendClientMessage( playerid, COLOR_RED, "Le joueur sélectionné n'a pas assez d'argent pour ce défi." );

		if ( ! ( 0 <= betAmount <= 100000 ) )
			return SendClientMessage( playerid, COLOR_RED, "Choisis un montant entre $0 et $100 000." );

		if ( rounds != 1 && rounds != 3 && rounds != 5 && rounds != 9 )
			return SendClientMessage( playerid, COLOR_RED, "Choisis parmi les rounds suivants : 1, 3, 5 ou 9." );

		if ( g_boxingPlayerData[ targetID ] [ E_INVITED ] == true )
			return SendClientMessage( playerid, COLOR_RED, "Ce joueur a déjà été défié pour un combat." );

		if ( g_boxingPlayerData[ targetID ] [ E_FIGHTING ] == true )
			return SendClientMessage( playerid, COLOR_RED, "Ce joueur combat déjà. Attends qu'il termine son combat de boxe." );

		if ( GetPlayerWantedLevelEx( targetID ) )
			return SendClientMessage( playerid, COLOR_RED, "Tu ne peux pas combattre contre un joueur recherché." );

		if ( g_boxingPlayerData[ playerid ] [ E_INVITED ] == true ) {
			SendBoxing( playerid, "Tu as annulé ton défi contre %s.", ReturnPlayerName( g_boxingPlayerData[ playerid ] [ E_OPPONENT ] ) );
			SendBoxing( g_boxingPlayerData[ playerid ] [ E_OPPONENT ], "%s hat seine Herausfordern abgebrochen.", ReturnPlayerName( playerid ) );
			ResetBoxingPlayerVariables( playerid, g_boxingPlayerData[ playerid ] [ E_OPPONENT ] );
		}

		g_boxingPlayerData[ playerid ] [ E_INVITED ] = true;
		g_boxingPlayerData[ playerid ] [ E_OPPONENT ] = targetID;
		g_boxingPlayerData[ playerid ] [ E_IS_HOST ] = true;
		g_boxingPlayerData[ playerid ] [ E_ROUNDS_SET ] = rounds;
		g_boxingPlayerData[ playerid ] [ E_BET_AMOUNT_SET ] = betAmount;
		g_boxingPlayerData[ targetID ] [ E_INVITED ] = true;
		g_boxingPlayerData[ targetID ] [ E_OPPONENT ] = playerid;
		g_boxingPlayerData[ targetID ] [ E_INVITE_TIMESTAMP ] = gettime() + 30000;

		if ( g_boxingPlayerData[ playerid ] [ E_BET_AMOUNT_SET ] == 0 ) {

			SendBoxing( playerid, "Tu as défié %s pour un combat de boxe de %i round(s).", ReturnPlayerName( targetID ), g_boxingPlayerData[ playerid ] [ E_ROUNDS_SET ] );
			SendBoxing( playerid, "Pour annuler le défi, utilise /boxing [CANCEL]." );

			SendBoxing( targetID, "%s hat dich zu einem Boxkampf mit %i Runde(n) herausgefordert.", ReturnPlayerName( playerid ), g_boxingPlayerData[ playerid ] [ E_ROUNDS_SET ] );
			SendBoxing( targetID, "Pour accepter ou refuser le défi, utilise /boxing [ACCEPT/DECLINE]." );

		} else {

			SendBoxing( playerid, "Tu as défié %s pour un combat de boxe de %s en %i round(s).", ReturnPlayerName( targetID ), cash_format( g_boxingPlayerData[ playerid ] [ E_BET_AMOUNT_SET ] ), g_boxingPlayerData[ playerid ] [ E_ROUNDS_SET ] );
			SendBoxing( playerid, "Pour annuler le défi, utilise /boxing [CANCEL]." );

			SendBoxing( targetID, "%s hat dich zu einem Boxkampf um %s mit %i Runde(n) herausgefordert.", ReturnPlayerName( playerid ), cash_format( g_boxingPlayerData[ playerid ] [ E_BET_AMOUNT_SET ] ), g_boxingPlayerData[ playerid ] [ E_ROUNDS_SET ] );
			SendBoxing( targetID, "Pour accepter ou refuser le défi, utilise /boxing [ACCEPT/DECLINE]." );

		}
		return 1;

	} else if ( !strcmp( params, "cancel", true, 6 ) ) {

		new opponent = g_boxingPlayerData[ playerid ] [ E_OPPONENT ];

		if ( g_boxingPlayerData[ playerid ] [ E_FIGHTING ] == true )
			return SendClientMessage( playerid, COLOR_RED, "Tu es en plein combat de boxe. Utilise /boxing [FORFEIT] pour abandonner." );

		if ( g_boxingPlayerData[ playerid ] [ E_IS_HOST ] == false )
			return SendClientMessage( playerid, COLOR_RED, "Tu n'as aucun défi à annuler." );

		SendBoxing( opponent, "%s a annulé le défi de combat de boxe.", SpielerInfo[playerid][sName] );
		SendBoxing( playerid, "Tu as annulé le défi de combat de boxe envers %s.", SpielerInfo[opponent][sName] );
		ResetBoxingPlayerVariables( playerid, opponent );
		return 1;

	} else if ( !strcmp( params, "accept", true, 6 ) ) {

		new opponent = g_boxingPlayerData[ playerid ] [ E_OPPONENT ];

		if ( gettime() > g_boxingPlayerData[ playerid ] [ E_INVITE_TIMESTAMP ] && g_boxingPlayerData[ playerid ] [ E_INVITED ] ) {
			SendClientMessage( opponent, COLOR_WHITE, "%s a essayé d'accepter le défi, mais celui-ci a expiré.", SpielerInfo[playerid][sName] );
			ResetBoxingPlayerVariables( playerid, opponent );
			return SendClientMessage( playerid, COLOR_RED, "Le défi a expiré." );
		}

		if ( g_boxingPlayerData[ playerid ] [ E_INVITED ] == false )
			return SendClientMessage( playerid, COLOR_RED, "Tu n'as aucun défi de combat de boxe à accepter." );

		if ( opponent == -1 )
			return SendClientMessage( playerid, COLOR_RED, "Ton adversaire n'est plus disponible." );

		if ( !IsPlayerNearBoxingArena( opponent ) ) {

			SendClientMessage( playerid, COLOR_RED, "%s ne se trouve plus à l'arène de boxe. Le défi a été annulé.", SpielerInfo[opponent][sName] );
			SendBoxing( opponent, "%s a essayé d'accepter ton défi, mais tu ne te trouves plus à l'arène de boxe.", SpielerInfo[playerid][sName] );
			return ResetBoxingPlayerVariables( playerid, opponent );

		}

		if ( GetPlayerMoneyEx( playerid ) < g_boxingPlayerData[ opponent ] [ E_BET_AMOUNT_SET ] ) {

			SendClientMessage( playerid, COLOR_RED, "Tu n'as pas assez d'argent pour participer au combat de boxe." );
			SendClientMessage( opponent, COLOR_RED, "%s n'a pas assez d'argent pour participer au combat de boxe.", ReturnPlayerName( playerid ) );
			return ResetBoxingPlayerVariables( playerid, opponent );

		} else if ( GetPlayerMoneyEx( opponent ) < g_boxingPlayerData[ opponent ] [ E_BET_AMOUNT_SET ] ) {

			SendClientMessage( opponent, COLOR_RED, "Tu n'as pas assez d'argent pour participer au combat de boxe." );
			SendClientMessage( playerid, COLOR_RED, "%s n'a pas assez d'argent pour participer au combat de boxe.", ReturnPlayerName( opponent ) );
			return ResetBoxingPlayerVariables( playerid, opponent );

		}

		g_boxingArenaData[ E_OCCUPIED ] = true;

		g_boxingPlayerData[ playerid ] [ E_FIGHTING ] = true;
		g_boxingPlayerData[ playerid ] [ E_INVITED ] = false;

		g_boxingPlayerData[ opponent ] [ E_FIGHTING ] = true;
		g_boxingPlayerData[ opponent ] [ E_INVITED ] = false;
		g_boxingPlayerData[ opponent ] [ E_IS_HOST ] = true;

		return StartMatch( playerid, opponent );

	} else if ( !strcmp( params, "decline", true, 7 ) ) {

		new opponent = g_boxingPlayerData[ playerid ] [ E_OPPONENT ];

		if ( g_boxingPlayerData[ playerid ] [ E_INVITED ] == false )
			return SendClientMessage( playerid, COLOR_RED, "Tu n'as reçu aucun défi de combat de boxe." );

		if ( g_boxingPlayerData[ playerid ] [ E_OPPONENT ] == -1 )
			return SendClientMessage( playerid, COLOR_RED, "Ton défi de combat de boxe a expiré." );

		SendBoxing( opponent, "%s a refusé ton défi de combat de boxe.", ReturnPlayerName( playerid ) );

		SendBoxing( playerid, "Tu as refusé le défi de combat de boxe de %s.", ReturnPlayerName( opponent ) );

		return ResetBoxingPlayerVariables( playerid, opponent );

	} else if ( !strcmp( params, "forfeit", true, 7 ) ) {
		if ( ! boxing_ForfeitMatch( playerid, g_boxingPlayerData[ playerid ] [ E_OPPONENT ] ) ) {
			return SendClientMessage( playerid, COLOR_RED, "Tu ne combats pas." );
		}
		return 1;
	}
	return SendClientMessage( playerid, COLOR_YELLOW, "Utilise : /boxing [FIGHT/CANCEL/ACCEPT/DECLINE/FORFEIT]" );
}

/* ** Functions ** */
stock StartMatch( playerid, targetID ) {

	if ( g_boxingPlayerData[ playerid ] [ E_FIGHTING ] && g_boxingPlayerData[ targetID ] [ E_FIGHTING ] ) {

		new Float:health_P, Float:armour_P, Float:health_T, Float:armour_T;

		ClearAnimations( playerid );
		GetPlayerHealth( playerid, health_P );
		GetPlayerArmour( playerid, armour_P );
		SetPlayerSpecialAction( playerid, SPECIAL_ACTION_NONE );
		g_boxingPlayerData[ playerid ] [ E_PRIOR_HEALTH ] = health_P;
		g_boxingPlayerData[ playerid ] [ E_PRIOR_ARMOUR ] = armour_P;
		g_boxingPlayerData[ playerid ] [ E_PRIOR_SKIN ] = GetPlayerSkin( playerid );
		SetPlayerSkin( playerid, 81 );

		ClearAnimations( targetID );
		GetPlayerHealth( targetID, health_T );
		GetPlayerArmour( targetID, armour_T );
		SetPlayerSpecialAction( targetID, SPECIAL_ACTION_NONE );
		g_boxingPlayerData[ targetID ] [ E_PRIOR_HEALTH ] = health_T;
		g_boxingPlayerData[ targetID ] [ E_PRIOR_ARMOUR ] = armour_T;
		g_boxingPlayerData[ targetID ] [ E_PRIOR_SKIN ] = GetPlayerSkin( targetID );
		SetPlayerSkin( targetID, 80 );

		// save weapons
		for( new iSlot = 0; iSlot != 12; iSlot++ ) {
			GetPlayerWeaponData( playerid, WEAPON_SLOT:iSlot, WEAPON:g_boxingPlayerData[ playerid ] [ E_PRIOR_WEP ] [ iSlot ], g_boxingPlayerData[ playerid ] [ E_PRIOR_WEP_AMMO ] [ iSlot ] );
			GetPlayerWeaponData( targetID, WEAPON_SLOT:iSlot, WEAPON:g_boxingPlayerData[ targetID ] [ E_PRIOR_WEP ] [ iSlot ], g_boxingPlayerData[ targetID ] [ E_PRIOR_WEP_AMMO ] [ iSlot ] );
		}

		g_boxingArenaData[ E_ROUNDS ] = g_boxingPlayerData[ targetID ] [ E_ROUNDS_SET ];
		g_boxingArenaData[ E_BET ] = g_boxingPlayerData[ targetID ] [ E_BET_AMOUNT_SET ];

		if ( g_boxingArenaData[ E_BET ] > 0 ) {
			GivePlayerMoneyEx( playerid, -g_boxingArenaData[ E_BET ] );
			GivePlayerMoneyEx( targetID, -g_boxingArenaData[ E_BET ] );
		}

		SetBoxingPlayerConfig( playerid, targetID );

		KillTimer( g_boxingArenaData[ E_CD_TIMER ] );
		g_boxingArenaData[ E_CD_TIMER ] = SetTimerEx( "boxingCountDown", 960, false, "d", 5 );

		SendBoxing( playerid, "Tu combats contre %s, %i round(s). Bonne chance !", ReturnPlayerName( targetID ), g_boxingArenaData[ E_ROUNDS ] );
		SendBoxing( targetID, "Tu combats contre %s, %i round(s). Bonne chance", ReturnPlayerName( playerid ), g_boxingArenaData[ E_ROUNDS ] );

		UpdateArenaScoreLabel( playerid, targetID );
		return true;

	} else {
		return SendClientMessage( playerid, COLOR_RED, "Une erreur est survenue, réessaie." );
	}
}

stock NextRound( playerid, targetID )
{
	UpdateArenaScoreLabel( playerid, targetID );
	SetBoxingPlayerConfig( playerid, targetID );
	KillTimer( g_boxingArenaData[ E_CD_TIMER ] );
	g_boxingArenaData[ E_CD_TIMER ] = SetTimerEx( "boxingCountDown", 960, false, "d", 5 );
	return 1;
}

stock EndMatch( playerid, targetID ) {

	new winnerid = g_boxingPlayerData[ targetID ] [ E_SCORE ] > g_boxingPlayerData[ playerid ] [ E_SCORE ] ? targetID : playerid;
	new loserid = winnerid == playerid ? targetID : playerid;

	if ( g_boxingArenaData[ E_BET ] <= 0 ) {
		SendBoxingGlobal( "%s hat einen Boxkampf gewonnen gegen %s gewonnen mit folgender Punkteanzahl %i!", ReturnPlayerName( winnerid ), ReturnPlayerName( loserid ), g_boxingPlayerData[ winnerid ] [ E_SCORE ] );
	} else {
		new winning_prize = floatround( float( g_boxingArenaData[ E_BET ] ) * 1.9 ); // We take 5% of the total pot
		GivePlayerMoneyEx( winnerid, winning_prize );
		SendBoxingGlobal( "%s hat einen Boxkampf gegen %s gewonnen und gewinnt %s mit folgender Punktezahl %i!", ReturnPlayerName( winnerid ), ReturnPlayerName( loserid ), cash_format( g_boxingArenaData[ E_BET ] ), g_boxingPlayerData[ winnerid ] [ E_SCORE ] );
	}

	boxing_RestorePlayer( playerid );
	boxing_RestorePlayer( targetID );

	SetPlayerPos( playerid, 2658.3181, 1607.2100, 1507.1793 );
	SetPlayerPos( targetID, 2652.0947, 1607.2100, 1507.1793 );

	ResetBoxingArenaVariables();
	ResetBoxingPlayerVariables( playerid, targetID );
	UpdateDynamic3DTextLabelText( arenaLabel, COLOR_GREY, "Boxing Arena\n{FFFFFF}/boxing fight" );
	return 1;
}

stock boxing_RestorePlayer( playerid )
{
	// user reported 0xff health, maybe spawn protection
	if ( g_boxingPlayerData[ playerid ] [ E_PRIOR_HEALTH ] > 100.0 ) g_boxingPlayerData[ playerid ] [ E_PRIOR_HEALTH ] = 100.0;
	if ( g_boxingPlayerData[ playerid ] [ E_PRIOR_ARMOUR ] > 100.0 ) g_boxingPlayerData[ playerid ] [ E_PRIOR_ARMOUR ] = 100.0;

	// set prior health
	SetPlayerHealth( playerid, g_boxingPlayerData[ playerid ] [ E_PRIOR_HEALTH ] );
	SetPlayerArmour( playerid, g_boxingPlayerData[ playerid ] [ E_PRIOR_ARMOUR ] );
	SetPlayerSkin( playerid, g_boxingPlayerData[ playerid ] [ E_PRIOR_SKIN ] );
	ResetPlayerWeapons( playerid );

	for ( new iSlot = 0; iSlot != 12; iSlot++ ) {
	    GivePlayerWeapon( playerid, WEAPON:g_boxingPlayerData[ playerid ] [ E_PRIOR_WEP ] [ iSlot ], g_boxingPlayerData[ playerid ] [ E_PRIOR_WEP_AMMO ] [ iSlot ] );
	}
}

stock boxing_ForfeitMatch( playerid, targetID ) {
	if ( ! g_boxingPlayerData[ playerid ] [ E_FIGHTING ] ) return 0;

	if ( g_boxingArenaData[ E_BET ] == 0 ) {
		SendBoxingGlobal( "%s a gagné un combat de boxe contre %s.", ReturnPlayerName( targetID ), ReturnPlayerName( playerid ) );
	} else if ( g_boxingArenaData[ E_BET ] > 0 ) {
		GivePlayerMoneyEx( targetID, g_boxingArenaData[ E_BET ] );
		SendBoxingGlobal( "%s hat einen Boxkampf gegen %s gewonnen und gewinnt %s.", ReturnPlayerName( targetID ), ReturnPlayerName( playerid ), cash_format( g_boxingArenaData[ E_BET ] ) );
	}

	boxing_RestorePlayer( playerid );
	SetPlayerPos( playerid, 2658.3181, 1607.2100, 1507.1793 );

	if ( 0 <= targetID < MAX_PLAYERS ) {
		boxing_RestorePlayer( targetID );
		SetPlayerPos( targetID, 2652.0947, 1607.2100, 1507.1793 );
	}

	ResetBoxingArenaVariables();
	ResetBoxingPlayerVariables( playerid, targetID );
	UpdateDynamic3DTextLabelText( arenaLabel, COLOR_GREY, "Boxing Arena\n{FFFFFF}/boxing fight" );
	return 1;
}

stock SetBoxingPlayerConfig( playerid, targetID ) {

	SetPlayerPos( playerid, 2657.4133, 1615.7841, 1507.0977 );
	SetPlayerPos( targetID, 2653.1357, 1611.4575, 1507.0977 );

	SetPlayerFacingAngle( playerid, 136 );
	SetPlayerFacingAngle( targetID, 315 );

	SetCameraBehindPlayer( playerid );
	SetCameraBehindPlayer( targetID );

	SetPlayerHealth( playerid, 100.0 );
	SetPlayerHealth( targetID, 100.0 );

	SetPlayerArmour( playerid, 100.0 );
	SetPlayerArmour( targetID, 100.0 );

	ResetPlayerWeapons( playerid );
	ResetPlayerWeapons( targetID );

	TogglePlayerControllable( playerid, false );
	TogglePlayerControllable( targetID, false );
	return true;

}

forward boxingCountDown( time );
public boxingCountDown( time ) {

	if ( !time ) {
		foreach( new playerid : Player ) {
			if ( g_boxingPlayerData[ playerid ] [ E_FIGHTING ] == true ) {
				GameTextForPlayer( playerid, "~r~COMBAT !", 2000, 3 );
				PlayerPlaySound( playerid, 1057, 0.0, 0.0, 0.0 );
				TogglePlayerControllable( playerid, true );
			}
		}
		g_boxingArenaData[ E_CD_TIMER ] = -1;

	} else {
		foreach( new playerid : Player ) {
			if ( g_boxingPlayerData[ playerid ] [ E_FIGHTING ] == true ) {
                new szNormalString[16];
				format( szNormalString, sizeof( szNormalString ), "~y~%d", time );
				GameTextForPlayer( playerid, szNormalString, 2000, 3 );
				PlayerPlaySound( playerid, 1056, 0.0, 0.0, 0.0 );
			}
		}
		g_boxingArenaData[ E_CD_TIMER ] = SetTimerEx( "boxingCountDown", 960, false, "d", time - 1 );
	}
	return 1;
}

stock UpdateArenaScoreLabel( playerid, opponent ) {
    new szNormalString[128];
	format( szNormalString, sizeof( szNormalString ), "%s [ %i ] - [ %i ] %s", ReturnPlayerName( playerid ), g_boxingPlayerData[ playerid ] [ E_SCORE ], g_boxingPlayerData[ opponent ] [ E_SCORE ], ReturnPlayerName( opponent ) );
	return UpdateDynamic3DTextLabelText( arenaLabel, COLOR_YELLOW, szNormalString );
}

stock ResetBoxingPlayerVariables( playerid, targetID ) {

	g_boxingPlayerData[ playerid ] [ E_INVITED ] = false;
	g_boxingPlayerData[ playerid ] [ E_OPPONENT ] = -1;
	g_boxingPlayerData[ playerid ] [ E_IS_HOST ] = false;
	g_boxingPlayerData[ playerid ] [ E_FIGHTING ] = false;
	g_boxingPlayerData[ playerid ] [ E_SCORE ] = 0;
	TogglePlayerControllable( playerid, true );

	if ( 0 <= targetID < MAX_PLAYERS )
	{
		g_boxingPlayerData[ targetID ] [ E_INVITED ] = false;
		g_boxingPlayerData[ targetID ] [ E_OPPONENT ] = -1;
		g_boxingPlayerData[ targetID ] [ E_IS_HOST ] = false;
		g_boxingPlayerData[ targetID ] [ E_FIGHTING ] = false;
		g_boxingPlayerData[ targetID ] [ E_SCORE ] = 0;
		TogglePlayerControllable( targetID, true );
	}
	return 1;
}

stock ResetBoxingArenaVariables() {
	g_boxingArenaData[ E_OCCUPIED ] = false;
	g_boxingArenaData[ E_CURRENT_ROUNDS ] = 0;
	g_boxingArenaData[ E_ROUNDS ] = 0;
	g_boxingArenaData[ E_BET ] = 0;
	return 1;

}

/* Hooks */
Boxer_OnPlayerGiveDamage( playerid, damagedid)
{
    #pragma unused playerid
	if ( g_boxingPlayerData[ damagedid ] [ E_FIGHTING ] == true ) {

		new Float:currentArmour;

		GetPlayerArmour( damagedid, currentArmour );

		if ( currentArmour <= 0.0 ) {

			new opponent = g_boxingPlayerData[ damagedid ] [ E_OPPONENT ];

			g_boxingPlayerData[ opponent ] [ E_SCORE ] ++;
			g_boxingArenaData[ E_CURRENT_ROUNDS ] ++;

			if ( g_boxingArenaData[ E_CURRENT_ROUNDS ] == g_boxingArenaData[ E_ROUNDS ] ) {
				return EndMatch( damagedid, opponent );
			}

			SendBoxing( damagedid, "Tu as perdu ce round, le round suivant commence." );
			SendBoxing( opponent, "Tu as gagné ce round, le round suivant commence." );

			SendBoxing( damagedid, "Runden %i - [ %s: %i ] - [ %s: %i ]", g_boxingArenaData[ E_ROUNDS ], ReturnPlayerName( damagedid ), g_boxingPlayerData[ damagedid ] [ E_SCORE ], ReturnPlayerName( opponent ), g_boxingPlayerData[ opponent ] [ E_SCORE ]  );
			SendBoxing( opponent, "Runden %i - [ %s: %i ] - [ %s: %i ]", g_boxingArenaData[ E_ROUNDS ], ReturnPlayerName( damagedid ), g_boxingPlayerData[ damagedid ] [ E_SCORE ], ReturnPlayerName( opponent ), g_boxingPlayerData[ opponent ] [ E_SCORE ]  );

			NextRound( damagedid, opponent );
		}
	}
	return 1;

}