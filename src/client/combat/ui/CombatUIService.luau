local module = {}

local frames = {}

function module.register(name, frame)
    frames[name] = frame
end

function module.unregister(name)
    frames[name] = nil
end

function module.show(name)
    for _, frame in frames do
        frame.Visible = false
    end

    frames[name].Visible = true
end

return module