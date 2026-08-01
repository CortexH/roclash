local module = {}

module.applies = {
    ["UnitSelectQuery"] = require(script.Parent.ListenUnitSelectQuery).handle
}

module.generates = {
}

return module
