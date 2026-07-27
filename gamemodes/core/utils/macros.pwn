#define HOLDING(%0)                         ((newkeys & (%0)) == (%0))
#define PRESSED(%0)                         (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0)                        (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define RandomEx(%1,%2)				        (random(%2-%1)+%1)
#define fRandomEx(%1,%2)			        (floatrandomEx(%2-%1)+%1)

#if !defined KEY_AIM
    #define KEY_AIM                             (128)
#endif

#define SendUsage(%0,%1)                    (SendClientMessage(%0,-1,"{FFAF00}[UTILISE]{FFFFFF} " # %1))
#define SendError(%0,%1) 			        (SendClientMessage(%0,-1,"{F81414}[ERROR]{FFFFFF} " # %1))
#define SendServerMessage(%0,%1)            (SendClientMessage(%0,-1,"{C0C0C0}[SERVER]{FFFFFF} " # %1))

#define cash_format(%0) \
    (number_format(%0, .prefix = '$'))

#define sprintf(%1)                         (format(g_szSprintfBuffer, sizeof(g_szSprintfBuffer), %1), g_szSprintfBuffer)

stock g_szSprintfBuffer[ 1024 ];

#define INFO_STRING "* Utilise : {00CC00}"
#define NoRights "Tu ne possèdes pas les droits nécessaires."
#define ERROR_ADMIN					"[{F70D0D}ERREUR{FFFFFF}] {EE600F}Tu ne possèdes pas les permissions nécessaires pour cette commande !"

//Schnell Defines - redv-reallife.de Reloaded
#define NichtBerechtigt SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Tu n'es {CD262F}pas{FFFFFF} autorisé à faire ça.");
#define KeinPerso SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Tu as besoin d'une carte d'identité.");
#define AdminDienst SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Tu n'es {CD262F}pas{FFFFFF} en service admin.");
#define NichtOnline SendClientMessage(playerid,COLOR_RED,"{FFFFFF}Ce joueur n'est {CD262F}pas{FFFFFF} en ligne.");
#define KeineFunktion ShowPlayerDialog(playerid,9992,DIALOG_STYLE_MSGBOX,"{007DFF}"SERV_NAME"{FFFFFF} - Erreur 404","Cette fonctionnalité n'est pas encore terminée.\nElle sera disponible dans une future mise à jour.","Continuer","");
#define NichtNahe SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Ce joueur n'est {CD262F}pas{FFFFFF} assez proche.");
#define IstBot SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Cet ID appartient à un {CD262F}bot{FFFFFF}.");
#define KeinRang SendClientMessage(playerid,COLOR_RED,"[Info]: {FFFFFF}Tu ne peux {CD262F}pas{FFFFFF} utiliser cette commande avec ton grade.");
#define abs(%1) (((%1) < 0) ? (-(%1)) : ((%1)))
#define Holding(%0) ((newkeys & (%0)) == (%0))