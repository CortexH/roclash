local module = {}

module.applies = {
    ["UnitSelectQuerySuccess"] = require(script.Parent.ApplyUnitSelectQuerySuccess).handle
}

return module
