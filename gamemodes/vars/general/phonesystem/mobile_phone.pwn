enum E_HANDYINFO
{
	Handyname[64],
	Float:HandyVerbrauch
}

new HandyInfo[][E_HANDYINFO] =
{
	{"Aucun",0.0},
	{"Téléphone à clapet",0.7},
	{"Sell-Phone",0.6},
	{"TPhone",0.3},
	{SERV_NAME"-Phone",0.2}
};

new PlayerText:HandyInfodraw[MAX_PLAYERS],
	PlayerText:HandyCalldraw[MAX_PLAYERS],

	AkkuTimer[MAX_PLAYERS];