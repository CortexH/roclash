local module = {}

module.firstTurretConsts = {
	["structureType"] = 2,
	["attackerStructure"] = true,
	["occupies"] = "ONLY_CENTER",
	["targetConfig"] = {
		["impactShape"] = "RADIUS",
		["deliveryType"] = "PROJECTILE",
		["targetMode"] = "SINGLE",
		["targetingBehavior"] = "NONE",
		["maxTargets"] = 1
	},
	["attackWindup"] = 0.4,
	["projectileSpeed"] = 50,
	["attackEndlag"] = 0.3,
	["impactSize"] = 4,
	["hitsConfig"] = {
		["quantity"] = 1,
		["timeBetweenHit"] = 0
	},
	["damageType"] = "PROJECTILE"
}

-- WALLS

module.firstWallConsts = {
	["structureType"] = 1,
	["attackerStructure"] = false,
	["occupies"] = "BORDER",
}

return module
