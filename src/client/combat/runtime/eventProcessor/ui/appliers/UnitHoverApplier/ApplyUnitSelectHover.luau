local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local eventType = require(root.events.unitHover.UnitHoverEvent)
local signatures = require(root.consts.SelectSignatures)
local unitViewRegistry = require(root.state.registry.UnitViewRegistry)

-- Cor do highlight de hover de seleção normal.
local HOVER_COLOR = Color3.fromRGB(0, 255, 0)
local HOVER_OUTLINE_COLOR = Color3.fromRGB(0, 200, 0)

local highlightedModels: {[Model]: Highlight} = {}

-- Consome o hover de SELEÇÃO e aplica/remove o highlight na unit.
-- Ignora hovers que não vieram do modo de seleção normal.
function module.apply(event: eventType.UnitHoverEvent)
	if event.data.signature ~= signatures.UNIT_SELECT then return end

	local view = unitViewRegistry.get(event.data.unitId)
	if not view or not view.model then return end
	local model = view.model

	if event.data.hovering then
		if not highlightedModels[model] then
			local highlight = Instance.new("Highlight")
			highlight.FillTransparency = 0.7
			highlight.OutlineTransparency = 0
			highlight.FillColor = HOVER_COLOR
			highlight.OutlineColor = HOVER_OUTLINE_COLOR
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
