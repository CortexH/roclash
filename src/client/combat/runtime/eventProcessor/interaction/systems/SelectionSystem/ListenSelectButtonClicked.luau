local module = {}

local root = script.Parent.Parent.Parent.Parent.Parent.Parent
local eventType = require(root.events.buttons.SelectInterfaceClientEvent)

function module.listen(event: eventType.SelectUnitButtonClicked)

end

function buttonSelect()

    

end

function buttonDeselect()
end

return module