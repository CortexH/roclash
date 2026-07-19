local module = {}

export type getWorldEntityInRadiusRequest = {
	["center"] : Vector3,
	["radius"] : number,
	["entitiesPositions"] : {
		[string] : Vector3
	}
}


function module.getWorldEntityInRadius(item : getWorldEntityInRadiusRequest) : {string}
    
	local entities = {}
	
	for i, v in pairs(item) do
		local distance = (v - item.center).Magnitude
		if distance <= item.radius then
			table.insert(entities, i)
		end
	end
end

function module.getWorldEntityById()
	
end

return module
