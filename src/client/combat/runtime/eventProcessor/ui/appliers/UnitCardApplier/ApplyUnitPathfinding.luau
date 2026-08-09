local module = {}

local eventTypes = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.queryResponse.SelectQueryResponse)
local root = script.Parent.Parent.Parent.Parent.Parent.Parent

local pathPreview = require(root.render.PathPreviewRender)
local pathfindingCache = require(root.state.cache.PathfindingCache)

-- Signatures fixas dos consumidores do preview de caminho.
local MOVE_PREVIEW_SIGNATURE = "UNIT_MOVE_PREVIEW"
local ATTACK_PREVIEW_SIGNATURE = "UNIT_ATTACK_PREVIEW"

function module.apply(event: eventTypes.UnitPathfindingQuerySuccessResponse)
	if event.signature ~= MOVE_PREVIEW_SIGNATURE and event.signature ~= ATTACK_PREVIEW_SIGNATURE then return end

	-- Registra o path no cache (chave = unitId) para consulta futura.
	pathfindingCache.register(event.data.unitId, {
		start = event.data.start,
		goal = event.data.goal,
		path = event.data.path,
		blockers = event.data.blockers
	})

	pathPreview.showPath(event.data.path)
end

function module.applyFailure(event: eventTypes.UnitPathfindingQueryFailureResponse)
	if event.signature ~= MOVE_PREVIEW_SIGNATURE and event.signature ~= ATTACK_PREVIEW_SIGNATURE then return end

	pathfindingCache.unregister(event.data.unitId)
	pathPreview.hide()
end

return module
