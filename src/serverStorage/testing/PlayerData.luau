local module = {}

module.data = {
	snapshotUniqueId = "f595193e-0703-413c-9dd3-c9c0c8f42f61",
	builds = {
		{1,300,0,0,0,{0, 0},0}, 
		{1,300,0,0,0,{0, 24},1},
		{1,300,0,0,0,{49, 0},2},
		{2,50,100,120,70,{4, 4},0, 1},
		{2,50,100,120,30,{15, 24},0, 1},
		{1,300,0,0,0,{4, 4},0},
		{1,300,0,0,0,{4, 4},1},
		{1,300,0,0,0,{4, 4},2},
		{1,300,0,0,0,{4, 4},3}
	},
	npcs = {
		--{100, 15, 30, .4, 1, 10, 1, {20,15}, 0, 1, 1, 1},
		--{100, 15, 30, .4, 1, 10, 1, {4,9}, 0, 1, 1, 1},
		--{100, 15, 30, .4, 1, 10, 1, {6,7}, 0, 1, 1, 1},
		--{100, 15, 30, .4, 1, 10, 1, {6,9}, 0, 1, 1, 1}
	},
	hero = {},
	castleData = {
		castleTowers = {
			
		},
		life = 100,
		hero = false
	},
	snapshotMapId = 1
}

module.types = {}

module.types.buildData = {
	1, -- build type
	1, -- health points
	1, -- damage per hit
	1, -- attack speed
	1, -- attack range
	{0, 0}, -- cell
	0, -- facing
	1, -- targeting mode
	1 -- targeting behavior mode
}

module.types.npcData = {
	100, -- life
	15, -- attack damage
	30, -- attack speed (funciona semelhante ao attack speed da torre)
	1, -- range
	1, -- damage type, define o tipo do dano causado (por enquanto, 1 como fixo)
	10, -- aggro range, define distância de detecção do inimigo
	1, -- behavior mode, define o comportamento do NPC (inicialmente 1)
	{1,1}, -- celula onde está posicionado em 'x' e 'y'
	0, -- facing
	1, -- número da espada do npc (a ser alterado)
	1, -- número do equipamento do npc (a ser alterado)
	1 -- walk speed (em cells/sec)
}

-- print(require(game.ServerStorage.services.combatService.ActiveBattles).getActiveBattle("504127684"))

return module
