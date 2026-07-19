local module = {}

local httpService = game:GetService("HttpService")

function module.generateData(soldiersQuantity : number)
	
	local data : attackerData = {}
	data.soldiers = {
		["byList"] = {},
		["byId"] = {}
	}
	
	for i = 1, soldiersQuantity do
		
		local soldier = {
			["uniqueId"] = httpService:GenerateGUID(false),
			["maxHealth"] = 300,
			["damageType"] = 1,
			["aggroRange"] = 20 * 4,
			["attackDamage"] = 100,
			["attackSpeed"] = 30,
			["attackRange"] = 6,
			["sword"] = 1,
			["equipment"] = 1,
			["walkSpeed"] = 3
		}
		
		data.soldiers["byId"][soldier.uniqueId] = soldier
		table.insert(data.soldiers["byList"], soldier)
		
	end
	
	return data
	
end


export type attackerData = {
	soldiers : soldier
}

export type soldier = {
	["uniqueId"] : number,
	["maxHealth"] : number,
	["damageType"] : number,
	["aggroRange"] : number,
	["attackDamage"] : number,
	["attackSpeed"] : number,
	["attackRange"]: number,
	["sword"] : number,
	["equipment"] : number,
	["walkSpeed"] : number
}

return module
