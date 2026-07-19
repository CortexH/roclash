local module = {}

module.woodenSword = {
	["swordType"] = 1,
	["name"] = "Wooden sword",
	["targetConfig"] = {
		["impactShape"] = "POINT",
		["deliveryType"] = "MELEE",
		["targetMode"] = "SINGLE",
		["maxTargets"] = 1
	},
	["attackWindup"] = 0.3,
	["attackSpeed"] = .3,
	["attackEndlag"] = 0.3,
	["impactSize"] = 0.1,
	["hitsConfig"] = {
		["quantity"] = 1,
		["timeBetweenHit"] = 0
	},
	["damageType"] = "SWORD"
}

return module
