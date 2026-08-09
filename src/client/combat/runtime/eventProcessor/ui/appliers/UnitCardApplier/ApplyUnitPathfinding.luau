local module = {}

local eventTypes = require(game.ReplicatedStorage.Shared.combat.shared.eventTypes.queryResponse.SelectQueryResponse)
local root = script.Parent.Parent.Parent.Parent.Parent.Parent

local pathPreview = require(root.render.PathPreviewRender)

-- Signature fixa do consumidor do preview de movimento.
local MOVE_PREVIEW_SIGNATURE = "UNIT_MOVE_PREVIEW"

function module.apply(event: eventTypes.UnitPathfindingQuerySuccessResponse)
	if event.signature ~= MOVE_PREVIEW_SIGNATURE then return end

	pathPreview.showPath(event.data.path)
end

function module.applyFailure(event: eventTypes.UnitPathfindingQueryFailureResponse)
	if event.signature ~= MOVE_PREVIEW_SIGNATURE then return end

	pathPreview.hide()
end

return module
