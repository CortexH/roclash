local module = {}

local pl = game:GetService("Players").LocalPlayer
local interactionState = require(script.Parent.Parent.state.InteractionState)

local viewRegistry = require(script.Parent.Parent.state.UnitViewRegistry)

local conns = {}

function module.beginSelect()
	local mouse = pl:GetMouse()
	
	local moveConn = mouse.Move:Connect(function()
		local item = mouse.Target
		local unitId = getIdFromUnit(item, mouse)
		interactionState.clientState.selection.currentHoveredUnit = unitId
	end)
	
	local clickConn = mouse.Button1Down:Connect(function()
		if interactionState.clientState.selection.currentHoveredUnit then
			if interactionState.clientState.selection.currentSelectedUnit ~= nil then
				module.onUnitDeselected()
			end
			interactionState.clientState.selection.currentSelectedUnit = interactionState.clientState.selection.currentHoveredUnit
			module.onUnitSelected()
		end
	end)
	
	table.insert(conns, moveConn)
	table.insert(conns, clickConn)
	
end

function module.stopSelect()
	for _, v in conns do
		v:Disconnect()
		v = nil
	end
end

function module.onUnitSelected()
	local mouse = pl:GetMouse()
	local unitId = interactionState.clientState.selection.currentSelectedUnit
	
	local view = viewRegistry.get(unitId)
	
	local highlight = Instance.new("Highlight")
	
	highlight.Adornee = view.model
	highlight.FillTransparency = 0.8
	highlight.FillColor = Color3.fromRGB(85, 255, 255)
	highlight.Parent = view.model
	
	highlight.Name = "SELECTED_UNIT_HIGHLIGHT"
	
end

function module.onUnitDeselected()
	local mouse = pl:GetMouse()
	local unitId = interactionState.clientState.selection.currentSelectedUnit
	
	local view = viewRegistry.get(unitId)
	
	local highlight = view.model:FindFirstChild("SELECTED_UNIT_HIGHLIGHT")
	
	if highlight then
		highlight:Destroy()
	end
end

function module.onUnitClicked()
	local mouse = pl:GetMouse()
	local unitId = interactionState.clientState.selection.currentSelectedUnit
	local unit = viewRegistry.get(unitId)
end

function getIdFromUnit(item, mouse)
	local item = mouse.Target
	if not item
		or not item.Parent.Parent:FindFirstChild("Configuration")
		or not item.Parent.Parent.Configuration:FindFirstChild("uniqueId")
	then
		return nil
	else
		return item.Parent.Parent.Configuration.uniqueId.Value
	end
end

return module
