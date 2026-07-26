#define MAX_SERVER_TITLES       (12)

enum {
    TITLE_GLADIATOR,
    TITLE_RICHMAN,
    TITLE_FACTION,
    TITLE_LOTTO,
    TITLE_GOODGUY,
    TITLE_JAILBROTHER,
    TITLE_PSYCHO,
    TITLE_KNIFER,
    TITLE_CRIMINAL,
    TITLE_KNIFEMAN,
    TITLE_LEVELJUNKIE,
    TITLE_TEAMMEMBER,
}
enum E_SERVER_TITLES {
    tName[32],
    tDescription[64],
    tAmount,
}

new ServerTitles[MAX_SERVER_TITLES][E_SERVER_TITLES] = {
    {"Gladiateur", "10 000 meurtres", 10000},
    {"Millionnaire", "Posséder 1.000.000 $", 1000000},
    {"Membre de faction", "Deviens membre d'une faction.", 1},
    {"Chanceux", "Gagne au loto", 1},
    {"Chic type", "Reçois ce titre d'un membre du staff", 1},
    {"Taulard", "50x emprisonné", 50},
    {"Psychopathe", "2 000 meurtres", 2000},
    {"Éventreur", "1 000 meurtres", 1000},
    {"Grand criminel", "300 crimes", 300},
    {"Faucheur", "5 000 meurtres", 5000},
    {"Accro", "Tu es niveau 25.", 25},
    {"Membre du staff", "Tu fais partie de l'équipe "SERV_NAME".", 1}
};

new PlayerTitle[MAX_PLAYERS][MAX_SERVER_TITLES][2];
