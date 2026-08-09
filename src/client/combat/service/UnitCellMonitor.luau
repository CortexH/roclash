local module = {}

local RunService = game:GetService("RunService")

local unitViewRegistry = require(script.Parent.Parent.state.registry.UnitViewRegistry)
local unitStateCache = require(script.Parent.Parent.state.cache.UnitStateCache)
local gameState = require(script.Parent.Parent.state.GameState)
local mapUtils = require(script.Parent.Parent.utils.MapUtils)

-- unitId -> callback(cell)
local monitoredUnits = {}

-- Retorna a célula atual da unit.
-- Se a unit está em movimento, usa a posição interpolada; caso contrário, a célula estática.
-- Retorna nil se a unit não existe mais ou está morta.
function module.getCurrentCell(unitId : string) : {x : number, y : number}?
	local state = unitStateCache.get(unitId)
	if not state then return nil end
	if state.status and state.status.isDead then return nil end

	local view = unitViewRegistry.get(unitId)
	if view and view.visual and view.visual.currentMovement then
		local ct = gameState.getCurrentTime()
		local movement = view.visual.currentMovement
		if not movement:isFinished(ct) then
			local pos = movement:getPosition(ct)
			if pos then
				return mapUtils.getCellByPosition({x = pos.X, y = pos.Z})
			end
		end
	end

	if state.placed and state.placed.cell then
		return state.placed.cell
	end

	return nil
end

-- Registra um callback que é chamado quando a unit troca de célula.
function module.monitor(unitId : string, callback)
	monitoredUnits[unitId] = callback
end

-- Remove o monitoramento da unit.
function module.unmonitor(unitId : string)
	monitoredUnits[unitId] = nil
end

local lastCells = {}

RunService.Heartbeat:Connect(function()
	for unitId, callback in pairs(monitoredUnits) do
		local cell = module.getCurrentCell(unitId)

		-- Unit não existe mais (morreu/foi removida): notifica o consumidor
		-- com nil para que ele possa encerrar a interação, e remove o monitoramento.
		if not cell then
			module.unmonitor(unitId)
			lastCells[unitId] = nil
			callback(nil)
			continue
		end

		local last = lastCells[unitId]

		if not last or cell.x ~= last.x or cell.y ~= last.y then
			lastCells[unitId] = cell
			callback(cell)
		end
	end
end)

return module