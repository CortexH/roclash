local module = {}

local dss = game:GetService("DataStoreService")
local constants = require(game.ServerStorage.Server.constants.DatastoreConstants)

local snapshotDataStore = dss:GetDataStore(constants.playerSnapshotsDatastore)

local ports = require(script.Parent.Parent.Parent.Parent.Parent.domain.ports.SnapshotDataPort)

local data = require(game.ServerStorage.Server.testing.PlayerData)

ports.getPlayerSnapshotData = function(playerId : number, snapshotId : number)
	
	return data.data
	
	--local success, data = pcall(function()
	--	return snapshotDataStore:GetAsync(playerId)[snapshotId]
	--end)
		
	--if(not success) then
	--	error("No data found for player: " .. playerId .. " and snapshot: " .. snapshotId)
	--end	
	
	--return data
end


--[[
game:GetService("DataStoreService"):GetDataStore("playerSnapshots"):SetAsync(
	"504127684",
	{
		[1] = {
			builds = {
				{1,1,1,1,1,{0, 50},0}, 
				{1,1,1,1,1,{25, 50},0},
				{2,1,0,0,0,{50, 50},0},
				{1,1,1,1,1,{0, 25},0},
				{2,1,0,0,0,{25, 25},0},
				{2,1,0,0,0,{50, 25},0},
				{1,1,1,1,1,{0, 0},0},
				{2,1,0,0,0,{0, 0},0}
				},
			npcs = {
				
			},
			castleData = {
				castleTowers = {

				},
				life = 100,
				hero = false
			}
		}
	})


game:GetService("DataStoreService"):GetDataStore("playerSnapshots"):GetAsync("504127684")
]]

return module
