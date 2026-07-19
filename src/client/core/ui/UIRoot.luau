local module = {}

local root = nil

function module.init()
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "UIRoot"

    local screens = Instance.new("Frame")
    screens.Name = "Screens"
    screens.Size = UDim2.fromScale(1, 1)
    screens.BackgroundTransparency = 1

    local modals = Instance.new("Frame")
    modals.Name = "Modals"
    modals.Size = UDim2.fromScale(1, 1)
    modals.BackgroundTransparency = 1

    local notifications = Instance.new("Frame")
    notifications.Name = "Notifications"
    notifications.Size = UDim2.fromScale(1, 1)
    notifications.BackgroundTransparency = 1

    screens.Parent = gui
    modals.Parent = gui
    notifications.Parent = gui

    gui.Parent = game:GetService("Players").LocalPlayer.PlayerGui

    root = gui
end

function module.getScreens()
    return root.Screens
end

function module.getNewScreen(name)
    local screen = Instance.new("Frame")
    screen.Name = name
    screen.Parent = root.screens
    return screen
end

function module.getModals()
    return root.modals
end

function module.getNotifications()
    return root.notifications
end

function module.addScreen(screen)
    screen.Parent = root.screens
end


return module