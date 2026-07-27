forward OnPasswordChecked(playerid, bool:success);
public OnPasswordChecked(playerid, bool:success)
{
	if(success)
	{
		SetPVarInt(playerid,"LoggedIn",1);
		KillTimer(CamFahrten[playerid]);
		LoadAccount(playerid);
	}
	else
	{
		new logingstring[340];
		format(logingstring,sizeof(logingstring),"{FFFFFF}Bienvenue de retour sur "SERV_NAME" {007DFF}%s{FFFFFF}.\nNous avons trouvé ton compte dans notre base de données. Merci de te connecter en saisissant\nle mot de passe choisi lors de ton inscription. Pour toute question, contacte notre équipe.\n\n{FE0000}Le mot de passe et le nom de compte ne correspondent pas.",SpielerInfo[playerid][sName]);
		ShowPlayerDialog(playerid,DIALOG_LOGIN,DIALOG_STYLE_PASSWORD,"{007DFF}"SERV_NAME"{FFFFFF} - Connexion",logingstring,"Continuer","");
	}
	return 1;	
}