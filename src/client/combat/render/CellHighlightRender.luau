local module = {}

local mapUtils = require(script.Parent.Parent.utils.MapUtils)
local mapConsts = require(script.Parent.Parent.consts.MapConsts)

-- Configurações 100% modificáveis.
-- Ajuste aqui cor, tamanho, transparências e offsets conforme o jogo evoluir.
module.config = {
	-- Tamanho da célula (mesmo das células do mapa, lido do MapConsts do cliente).
	cellSize = mapConsts.consts.cellSize or 4,
	-- Cor da part e do highlight (azul por padrão).
	color = Color3.fromRGB(59, 130, 246),
	-- Transparência do preenchimento do Highlight (0 = opaco, 1 = invisível).
	fillTransparency = 0.5,
	-- Transparência do contorno do Highlight.
	outlineTransparency = 0,
	-- Transparência da part em si.
	partTransparency = 0.5,
	-- Altura (espessura) da part.
	height = 0.1,
	-- Deslocamento vertical acima do chão para evitar z-fighting.
	yOffset = 0.05,
	-- Material da part.
	material = Enum.Material.SmoothPlastic,
}

local currentPart = nil
local currentHighlight = nil

-- Cria a part 4x4 (tamanho da célula) com um Highlight azul.
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

-- Posiciona a part no centro da célula informada e a coloca no mapa.
function module.showAtCell(cell : {x : number, y : number})
	if not currentPart then
		currentPart, currentHighlight = createCellPart()
	end

	local pos = mapUtils.getPositionByCell(cell)
	currentPart.Position = Vector3.new(
		pos.X,
		mapUtils.getMapBaseElevation() + module.config.yOffset,
		pos.Y
	)
	currentPart.Parent = workspace
end

-- Remove a part do mapa.
function module.hide()
	if currentPart then
		currentPart:Destroy()
		currentPart = nil
		currentHighlight = nil
	end
end

return module
