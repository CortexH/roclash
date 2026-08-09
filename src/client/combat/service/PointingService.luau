local module = {}

module.__index = module

local unitView = require(game.ReplicatedStorage.Shared.combat.shared.dataTypes.UnitView)

local viewRegistry = require(script.Parent.Parent.state.registry.UnitViewRegistry)
local mapUtils = require(script.Parent.Parent.utils.MapUtils)
local mouse = game.Players.LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

export type PointingService = typeof(module.new("", {}, ""))

export type pointModes = "CELL" | "UNIT"
export type pointData = {
    hoveringUnitId : string,
    hoveringUnitView : unitView.unitView,
    onClick : (unitView.unitView, string) -> ()
}
export type lambdaConfigs = {
    onClick : ((unitView.unitView, string) -> ()) | (({x:number, y:number}) -> ()),
    onHoverStart : ((unitView.unitView, string) -> ()) | (() -> ()),
    onHoverEnd : ((unitView.unitView, string) -> ()) | (() -> ()),
}

function module.new(mode : pointModes, configs : lambdaConfigs, interactionId : string)
    local self = setmetatable({}, module)

    self.currentMode = mode
    self.id = interactionId

    self.unitData = {
        hoveringUnitId = nil,
        hoveringUnitView = nil,
        onClick = configs.onClick,
        onHoverStart = configs.onHoverStart,
        onHoverEnd = configs.onHoverEnd
    }

    self.cellData = {
        hoveringCell = nil,
        onClick = configs.onClick,
        onHoverStart = configs.onHoverStart,
        onHoverEnd = configs.onHoverEnd
    }

    return self
end

function module:start(configs : lambdaConfigs)
    if self.currentMode == "UNIT" then
        self:_startUnitMode()
    elseif self.currentMode == "CELL" then
        self:_startCellMode()
    end
end

function module:getId()
    return self.id
end

function module:_startUnitMode()
    self:_stopConnections()

    self._moveConnection = mouse.Move:Connect(function()
        local target = mouse.Target

        local newUnitId = nil
        local newUnitView = nil

        if target then
			newUnitView = viewRegistry.getByInstance(target)
            if newUnitView then
				newUnitId = newUnitView.unitId
            end
        end

        if newUnitId == self.unitData.hoveringUnitId then
            return
        end

        if self.unitData.hoveringUnitView then
            self.unitData.onHoverEnd(
                self.unitData.hoveringUnitView,
                self.unitData.hoveringUnitId
            )
        end

        self.unitData.hoveringUnitId = newUnitId
        self.unitData.hoveringUnitView = newUnitView

        if newUnitView then
            self.unitData.onHoverStart(
                newUnitView,
                newUnitId
            )
        end
    end)

    self._clickConnection = mouse.Button1Down:Connect(function()
        if not self.unitData.hoveringUnitView then
            return
        end

        self.unitData.onClick(
            self.unitData.hoveringUnitView,
            self.unitData.hoveringUnitId
        )
    end)
end

local function sameCell(a, b)
    if a == nil or b == nil then return a == b end
    return a.x == b.x and a.y == b.y
end

function module:_startCellMode()
    self:_stopConnections()

    self._moveConnection = mouse.Move:Connect(function()
        local x, y = mouse.Hit.X, mouse.Hit.Z
        local cell = mapUtils.getCellByPosition({x = x, y = y})

        if sameCell(cell, self.cellData.hoveringCell) then
            return
        end

        if self.cellData.hoveringCell then
            self.cellData.onHoverEnd(self.cellData.hoveringCell)
        end

        self.cellData.hoveringCell = cell

        if cell then
            self.cellData.onHoverStart(cell)
        end
    end)

    self._clickConnection = mouse.Button1Down:Connect(function()
        if not self.cellData.hoveringCell then
            return
        end

        self.cellData.onClick(self.cellData.hoveringCell)
    end)
end

function module:_stopConnections()
    if self._moveConnection then
        self._moveConnection:Disconnect()
        self._moveConnection = nil
    end

    if self._clickConnection then
        self._clickConnection:Disconnect()
        self._clickConnection = nil
    end
end

function module:stop()
    self:_stopConnections()

    if self.currentMode == "UNIT" then
        if self.unitData.hoveringUnitView then
            self.unitData.onHoverEnd(
                self.unitData.hoveringUnitView,
                self.unitData.hoveringUnitId
            )
        end

        self.unitData.hoveringUnitId = nil
        self.unitData.hoveringUnitView = nil
    elseif self.currentMode == "CELL" then
        if self.cellData.hoveringCell then
            self.cellData.onHoverEnd(self.cellData.hoveringCell)
        end

        self.cellData.hoveringCell = nil
    end
end

return module