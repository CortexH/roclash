local apiFolder = game.ReplicatedStorage.Shared.combat.shared.API

local function getOrCreateRemote(folder, remoteName)
    local remote = folder:FindFirstChild(remoteName)

    if remote then
        return remote
    end

    remote = Instance.new("RemoteEvent")
    remote.Name = remoteName
    remote.Parent = folder

    return remote
end

local module = {}
local loaded = false

function module.loadRemotes()
    if loaded then
        return module
    end

    module.commands = {
        commandSender = getOrCreateRemote(
            apiFolder.commands,
            "CommandSender"
        ),
    }

    module.data = {
        ping = getOrCreateRemote(
            apiFolder.data,
            "ping"
        ),

        toFront = {
            loadData = getOrCreateRemote(
                apiFolder.data.toFront,
                "loadData"
            ),

            packetsEvent = getOrCreateRemote(
                apiFolder.data.toFront,
                "packetsEvent"
            ),
        },
    }

    module.runtime = {
        StartBattle = getOrCreateRemote(
            apiFolder.runtime,
            "StartBattle"
        ),
    }

    module.start = {
        loadBattle = getOrCreateRemote(
            apiFolder.start,
            "loadBattle"
        ),
    }

    loaded = true
    return module
end

module.loadRemotes()

return module
