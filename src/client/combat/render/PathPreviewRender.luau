local module = {}

local mapUtils = require(script.Parent.Parent.utils.MapUtils)
local mapConsts = require(script.Parent.Parent.consts.MapConsts)

-- Configurações 100% modificáveis.
module.config = {
	cellSize = mapConsts.consts.cellSize or 4,
	color = Color3.fromRGB(34, 197, 94),
	fillTransparency = 0.5,
	outlineTransparency = 0,
	partTransparency = 0.5,
	height = 0.1,
	yOffset = 0.05,
	material = Enum.Material.SmoothPlastic,
}

local currentParts: {[Part]: Highlight} = {}

local function createCellPart()
	local part = Instance.new("Part")
	part.Size = Vector3.new(module.config.cellSize, module.config.height, module.config.cellSize)
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = module.config.partTransparency
	part.Color = module.config.color
	part.Material = module.config.material

	local highlight = Instance.new("Highlight")
	highlight.FillTransparency = module.config.fillTransparency
	highlight.OutlineTransparency = module.config.outlineTransparency
	highlight.FillColor = module.config.color
	highlight.OutlineColor = module.config.color
	highlight.Parent = part

	return part, highlight
end

local function showAtCell(cell : {x : number, y : number})
	local part, highlight = createCellPart()
	local pos = mapUtils.getPositionByCell(cell)
	part.Position = Vector3.new(
		pos.X,
		mapUtils.getMapBaseElevation() + module.config.yOffset,
		pos.Y
	)
	part.Parent = workspace
	currentParts[part] = highlight
end

-- Gera todas as células entre fromCell e toCell (segmentos ortogonais do A*).
local function cellsBetween(fromCell : {x : number, y : number}, toCell : {x : number, y : number})
	local cells = {}

	local dx = toCell.x - fromCell.x
	local dy = toCell.y - fromCell.y
	local steps = math.max(math.abs(dx), math.abs(dy))

	local stepX = dx ~= 0 and (dx > 0 and 1 or -1) or 0
	local stepY = dy ~= 0 and (dy > 0 and 1 or -1) or 0

	for i = 0, steps do
		table.insert(cells, {x = fromCell.x + stepX * i, y = fromCell.y + stepY * i})
	end

	return cells
end

-- Renderiza todas as células do caminho retornado pelo backend.
-- `path` é a lista de segmentos {fromCell, toCell, blocker}.
function module.showPath(path)
	module.hide()

	if not path then return end

	local seen = {}

	for _, segment in ipairs(path) do
		for _, cell in ipairs(cellsBetween(segment.fromCell, segment.toCell)) do
			local key = cell.x .. "," .. cell.y
			if not seen[key] then
				seen[key] = true
				showAtCell(cell)
			end
		end
	end
end

-- Remove todas as parts do preview.
function module.hide()
	for part, highlight in pairs(currentParts) do
		part:Destroy()
	end
	currentParts = {}
end

return module
