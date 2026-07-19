local allModules = script.Parent:GetDescendants()

for _, v in allModules do
	if v:IsA("ModuleScript") then
		require(v)
	end
end