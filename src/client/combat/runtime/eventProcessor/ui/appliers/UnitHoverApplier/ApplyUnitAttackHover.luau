local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local eventType = require(root.events.unitHover.UnitHoverEvent)
local signatures = require(root.consts.SelectSignatures)
local unitViewRegistry = require(root.state.registry.UnitViewRegistry)
local unitDefinitionCache = require(root.state.cache.UnitDefinitionCache)

local lp = game:GetService("Players").LocalPlayer

-- Cor do highlight de hover de ataque: vermelho para inimiga, cinza para amiga.
local HOVER_ENEMY_COLOR = Color3.fromRGB(255, 0, 0)
local HOVER_ALLY_COLOR = Color3.fromRGB(128, 128, 128)

local highlightedModels: {[Model]: Highlight} = {}

-- Consome o hover de ATAQUE e aplica/remove o highlight na unit.
-- Ignora hovers que não vieram do modo de ataque.
function module.apply(event: eventType.UnitHoverEvent)
	if event.data.signature ~= signatures.UNIT_ATTACK_SELECT then return end

	local view = unitViewRegistry.get(event.data.unitId)
	if not view or not view.model then return end
	local model = view.model

	if event.data.hovering then
		if not highlightedModels[model] then
			local def = unitDefinitionCache.get(event.data.unitId)
			local isAlly = def and def.unitOwner == tostring(lp.UserId)
			local color = isAlly and HOVER_ALLY_COLOR or HOVER_ENEMY_COLOR

			local highlight = Instance.new("Highlight")
			highlight.FillTransparency = 0.7
			highlight.OutlineTransparency = 0
			highlight.FillColor = color
			highlight.OutlineColor = color
			highlight.Parent = model
			highlightedModels[model] = highlight
		end
	else
		if highlightedModels[model] then
			highlightedModels[model]:Destroy()
			highlightedModels[model] = nil
		end
	end
end

return module
