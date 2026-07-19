local apiFolder = game.ReplicatedStorage.Shared.combat.shared.API

local module = {
    commands = {
        CommandSender = apiFolder.commands:FindFirstChild("CommandSender") :: RemoteEvent
    },
    data = {
        ping = apiFolder.data:FindFirstChild("ping") :: RemoteEvent,

        toFront = {
            loadData = apiFolder.data.toFront:FindFirstChild("loadData") :: RemoteEvent,
            packetsEvent = apiFolder.data.toFront:FindFirstChild("packetsEvent") :: RemoteEvent,
        },
    },

    runtime = {
        StartBattle = apiFolder.runtime:FindFirstChild("StartBattle") :: RemoteEvent,
    },

    start = {
        loadBattle = apiFolder.start:FindFirstChild("loadBattle") :: RemoteEvent,
    }

}

return module
