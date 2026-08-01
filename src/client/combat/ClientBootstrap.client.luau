local allModules = script.Parent:GetDescendants()

for _, v in allModules do
	if v:IsA("ModuleScript") then
		local suc, err = pcall(function()
			require(v)
		end)

		if not suc then
			warn("MODULO FALHOU AO CARREGAR :: " .. v.Name .. ". ERR: " .. err)
		end

	end
end