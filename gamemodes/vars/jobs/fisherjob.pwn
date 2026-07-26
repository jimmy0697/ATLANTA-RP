#define MAX_FISHING_TRAPS   (5)
#define MAX_FISH_TYPES      (9)

enum E_FISHING_TRAPS {
    Float:fTrapX,
    Float:fTrapY,
    Float:fTrapZ,
    fTrapTimestamp,
    fTrapFishes[MAX_FISH_TYPES],
    fTrapPlayerUse,
};

new fishingTrap[MAX_FISHING_TRAPS][E_FISHING_TRAPS],
    fishingInv[MAX_PLAYERS][MAX_FISH_TYPES];

#define MAX_FISHING_JOB_SKILL_LEVEL 6

new Float:fishingSkillDistance[MAX_FISHING_JOB_SKILL_LEVEL] = {
    350.0,
    300.0,
    250.0,
    200.0,
    150.0,
    100.0
};

new const fishingSkillInv[MAX_FISHING_JOB_SKILL_LEVEL] = {
    500,
    1000,
    1500,
    2000,
    2500,
    3000
};

new const fishingSkillExp[MAX_FISHING_JOB_SKILL_LEVEL] = {
    50,
    100,
    150,
    200,
    350,
    500
};

enum E_FISHING_TYPES {
    fishingTypeName[16],
    Float:fishingTypePercent,
    fishingTypeOccur,
    fishingTypeMoney
}

new const fishingTypes[MAX_FISH_TYPES][E_FISHING_TYPES] = {
    {"Hareng", 80.0, 25, 2},
    {"Maquereau", 70.0, 25, 3},
    {"Saumon", 60.0, 20, 4},
    {"Truite", 50.0, 20, 5},
    {"Sébaste", 40.0, 15, 6},
    {"Carpe", 35.0, 12, 8},
    {"Baudroie", 20.0, 10, 9},
    {"Tortue", 8.0, 5, 10},
    {"Calmar géant", 4.0, 3, 12}
};