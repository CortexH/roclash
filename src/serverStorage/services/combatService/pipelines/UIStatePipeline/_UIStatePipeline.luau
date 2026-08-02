local module = {}

local translate = require(script.Parent.TranslateUIStatePipeline)

-- Eventos que podem alterar o estado atualmente observado de uma unidade.
local relevantEventTypes = {
	["DamageAppliedEvent"] = true,
	["UnitDiedEvent"] = true,
	["TargetChangedEvent"] = true,
	["TargetAcquiredEvent"] = true,
	["TargetLostEvent"] = true,
}

-- Extrai o id da unidade afetada por um evento relevante.
local function extractAffectedUnitId(event)
	local data = event.data
	if not data then return nil end

	if event.eventType == "DamageAppliedEvent" or event.eventType == "UnitDiedEvent" then
		return data.targetId
	end

	if event.eventType == "TargetChangedEvent"
		or event.eventType == "TargetAcquiredEvent"
		or event.eventType == "TargetLostEvent" then
		return data.unitId
	end

	return nil
end

-- A pipeline é somente de leitura em relação ao estado da simulação.
-- Ela consolida, ao final do tick, as alterações relevantes para o estado
-- que o jogador está observando e produz um UI Diff.
function module.process(context, events, currentTime)
	local sessionBC = context["PlayerSessionBC"]
	local unitsBC = context["UnitsBC"]

	local selectedEntities = sessionBC:getSelectedEntities()
	if #selectedEntities == 0 then return {} end

	-- Conjunto de unidades observadas que sofreram alterações no tick.
	local affected = {}
	for _, event in ipairs(events) do
		if not relevantEventTypes[event.eventType] then continue end
		local unitId = extractAffectedUnitId(event)
		if not unitId then continue end
		affected[unitId] = true
	end

	-- Consolida as alterações relevantes em um único diff.
	local diff = {}
	for _, selectedId in ipairs(selectedEntities) do
		if not affected[selectedId] then continue end

		local unit = unitsBC:getActiveUnitById(selectedId)
		if not unit then continue end

		diff[selectedId] = {
			unitId = selectedId,
			stats = {
				health = unit:getHealth(),
				maxHealth = unit:getMaxHealth()
			},
			isDead = unit:isDead()
		}
	end

	if next(diff) == nil then return {} end

	return translate.translateDiff(diff, currentTime)
end

return module
