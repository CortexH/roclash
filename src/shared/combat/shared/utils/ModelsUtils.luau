local module = {}

local structuresFolder = script.Parent.Parent.models.structures
local npcsFolder = script.Parent.Parent.models.npcs
local projectilesFolder = script.Parent.Parent.models.projectiles

function structureType()
	local model = Instance.new("Model")
	model.Name = "Structure"

	local folder = Instance.new("Folder")
	folder.Name = "Folder"
	folder.Parent = model

	local shootPart = Instance.new("Model")
	shootPart.Name = "ShootPart"
	shootPart.Parent = model

	local muzzlePart = Instance.new("Part")
	muzzlePart.Name = "Muzzle"
	muzzlePart.Parent = shootPart

	local muzzleAttachment = Instance.new("Attachment")
	muzzleAttachment.Name = "muzzle"
	muzzleAttachment.Parent = muzzlePart

	local configuration = Instance.new("Configuration")
	configuration.Name = "Configuration"
	configuration.Parent = model

	local typeValue = Instance.new("NumberValue")
	typeValue.Name = "type"
	typeValue.Parent = configuration

	local idValue = Instance.new("StringValue")
	idValue.Name = "uniqueId"
	idValue.Parent = configuration

	return model
end

function module.getStructureModelById(id : number) : typeof(structureType())
	
	for _, v in structuresFolder:GetChildren() do
		if v.Configuration.type.Value == id then return v:Clone() end
	end

	warn("ESTRUTURA COM ID " .. id .. " NÃO ENCONTRADA")
	return nil
end

function module.getNpcModelById(id : number) : Model
	for _, v in npcsFolder.rig:GetChildren() do
		if v.Configuration.type.Value == id then return v:Clone() end
	end
	
	warn("NPC COM ID " .. id .. " NÃO ENCONTRADO")
	return nil
end

function module.getNpcEquipmentModelById() : (Model, Model)
	
end

function module.getProjectileModelById(id)
	for _, v in projectilesFolder:GetChildren() do
		if v.Configuration.type.Value == id then return v:Clone() end
	end

	warn("PROJÉTIL COM ID " .. id .. " NÃO ENCONTRADO")
	return nil
end

return module
