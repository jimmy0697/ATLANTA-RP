// core/mysql/mysql_wrapper.pwn
// Toutes les fonctions wrapper MySQL regroupees dans UN SEUL fichier.
// Raison : avec -Z+, le compilateur pawn-lang genere des include guards
// bases sur un nom de fichier tronque a ~26 caracteres en ignorant le dossier.
// Les anciens fichiers separes (core/mysql/functions/mysql_*.pwn) partageaient
// tous le prefixe "mysql/functions/mysql_" (22 caracteres) : au-dela de 26
// caracteres, plusieurs d'entre eux produisaient le MEME symbole de garde,
// ce qui faisait sauter silencieusement certains fichiers a la compilation
// (erreurs "undefined symbol" / "not implemented" sans warning associe).

// --- mysql_CreateTables.pwn ---
stock mysql_CreateTables() {

    mysql_tquery_file(sqlHandle, "mysql/"MYSQL_TABLE_DATA, "onCreateTablesExecuted");
    return 1;
}

forward onCreateTablesExecuted();
public onCreateTablesExecuted() {
    printf("onCreateTablesExecuted() executed. Tables creating!");
    return 1;
}

// --- mysql_Delete.pwn ---
stock mysql_Delete(const Table[], const Where[], const Is[])
{
    new query[128];
    mysql_format(sqlHandle, query, sizeof(query), "DELETE FROM `%s` WHERE `%s` = '%s'", Table, Where, Is);
	mysql_tquery(sqlHandle, query);
	return 1;
}

// --- mysql_GetFloat.pwn ---
public Float:mysql_GetFloat(const Table[], const Field[], const Where[], const Is[])
{
    new query[128], Float:sqlfloat;
    mysql_format(sqlHandle, query, sizeof(query), "SELECT `%s` FROM `%s` WHERE `%s` = '%s'", Field, Table, Where, Is);
    new Cache:Result = mysql_query(sqlHandle, query);
	cache_get_value_name_float(0, Field, sqlfloat);
	cache_delete(Result);
    return sqlfloat;
}

// --- mysql_GetInt.pwn ---
stock mysql_GetInt(const Table[], const Field[], const Where[], const Is[])
{
	new query[128], Get;
	mysql_format(sqlHandle, query, sizeof(query), "SELECT %s FROM %s WHERE %s = '%s'", Field, Table, Where, Is);
	new Cache:Result = mysql_query(sqlHandle, query);
	cache_get_value_name_int(0, Field, Get);
	cache_delete(Result);
	return Get;
}

// --- mysql_GetIntEx.pwn ---
stock mysql_GetIntEx(const query[])
{
	new Get[128];
	new Cache:Result = mysql_query(sqlHandle, query);
	cache_get_value_index(0, 0, Get);
	cache_delete(Result);
	return strval(Get);
}

// --- mysql_GetString.pwn ---
stock mysql_GetString(const Table[], const Field[], const Where[], const Is[])
{
	new query[128], Get[128];
	mysql_format(sqlHandle, query, sizeof(query), "SELECT `%s` FROM `%s` WHERE `%s` = '%s'", Field, Table, Where, Is);
	new Cache:Result = mysql_query(sqlHandle, query);
	cache_get_value_name(0, Field, Get);
	cache_delete(Result);
	return Get;
}

// --- mysql_SetFloat.pwn ---
stock mysql_SetFloat(Table[], const Field[], Float:To, const Where[], const Where2[])
{
    new query[128];
    mysql_format(sqlHandle, query, sizeof(query), "UPDATE `%s` SET `%s` = '%f' WHERE `%s` = '%s'", Table, Field, To, Where, Where2);
    mysql_tquery(sqlHandle, query);
    return true;
}

// --- mysql_SetInt.pwn ---
stock mysql_SetInt(const Table[], const Field[], const To, const Where[], const Where2[])
{
    new query[128];
    mysql_format(sqlHandle, query, sizeof(query), "UPDATE `%s` SET `%s` = '%d' WHERE `%s` = '%s'", Table, Field, To, Where, Where2);
    mysql_tquery(sqlHandle, query);
    return 1;
}

// --- mysql_SetString.pwn ---
stock mysql_SetString(const Table[], const Field[], const To[], const Where[], const Where2[])
{
    new query[128];
    mysql_format(sqlHandle, query, sizeof(query), "UPDATE `%s` SET `%s` = '%s' WHERE `%s` = '%s'", Table, Field, To, Where, Where2);
    mysql_tquery(sqlHandle, query);
    return true;
}

// --- mysql_ReturnBetaKey.pwn ---
stock mysql_ReturnBetaKey(const Name[])
{
    new query[130], Get[130];
    mysql_format(sqlHandle, query, sizeof(query), "SELECT `Key` FROM `beta` WHERE `Name` = '%s'", Name);
    new Cache:Result = mysql_query(sqlHandle, query);
	cache_get_value_name(0, "Key", Get);
	cache_delete(Result);
    return Get;
}

// --- mysql_CheckBeta.pwn ---
stock mysql_CheckBeta(playerid)
{
    new Name[MAX_PLAYER_NAME];
  	GetPlayerName(playerid, Name, MAX_PLAYER_NAME);
    if(strcmp(mysql_GetString("beta", "Aktiviert", "Name", Name), "regist") == 0)
	{
	    return false;
	}
	return true;
}

