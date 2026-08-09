local module = {}

-- Múltiplos appliers de hover podem ouvir o mesmo evento UnitHoverClient,
-- cada um filtrando pela signature de quem originou o hover.
local attackHover = require(script.Parent.ApplyUnitAttackHover)
local selectHover = require(script.Parent.ApplyUnitSelectHover)

module.applies = {
	["UnitHoverClient"] = function(event)
		attackHover.apply(event)
		selectHover.apply(event)
	end
}

return module
