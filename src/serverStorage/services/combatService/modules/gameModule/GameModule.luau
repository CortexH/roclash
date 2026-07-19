local module = {}

function runBootstrap()
	local frontController = script.Parent.infrastructure.adapter.inbound.frontController

    require(frontController.adapter.GameDataAPI)
    require(frontController.adapter.PingAPI)

	local controllers = script.Parent.infrastructure.adapter.inbound.controller

    require(controllers.GameContentEventHandler)
end

runBootstrap()

return module