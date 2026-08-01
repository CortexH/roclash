local module = {}

export type ViewportProps = {
    name: string?,
    size: UDim2?,
    borderColor: Color3?,
    worldModel: Instance?
}

local DEFAULT_BORDER_COLOR = Color3.fromRGB(59, 130, 246)

function module.create(props: ViewportProps)
    
    local viewport = Instance.new("ViewportFrame")
    viewport.Name = props.name or "ColoredViewport"
    viewport.Size = props.size or UDim2.fromOffset(200, 200)
    viewport.BackgroundTransparency = 1
    viewport.BorderSizePixel = 0

    -- Borda arredondada
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = viewport

    -- Borda colorida
    local border = Instance.new("UIStroke")
    border.Color = props.borderColor or DEFAULT_BORDER_COLOR
    border.Thickness = 1
    border.Transparency = 0
    border.Parent = viewport

    -- Cria a câmera
    local camera = Instance.new("Camera")
    camera.Parent = viewport
    viewport.CurrentCamera = camera

    -- Adiciona o modelo
    if props.worldModel then
        local model = props.worldModel
        model.Parent = viewport

        if model:IsA("Model") then
            -- Centro e tamanho do modelo
            local bboxCFrame, bboxSize = model:GetBoundingBox()

            -- Move o modelo para que o centro fique na origem,
            -- removendo qualquer rotação.
            local offset = bboxCFrame:ToObjectSpace(model:GetPivot())
            
            local rotation = CFrame.Angles(0, math.rad(90), 0)

            model:PivotTo(
                CFrame.new() * rotation * bboxCFrame:Inverse() * model:GetPivot()
            )

            -- Distância da câmera baseada no tamanho do modelo
            local distance = math.max(bboxSize.X, bboxSize.Y, bboxSize.Z) * 1.8

            camera.CFrame = CFrame.lookAt(
                Vector3.new(0, 0, distance),
                Vector3.zero
            )

        elseif model:IsA("BasePart") then
            model.CFrame = CFrame.new()

            local distance = math.max(model.Size.X, model.Size.Y, model.Size.Z) * 1.8

            camera.CFrame = CFrame.lookAt(
                Vector3.new(0, 0, distance),
                Vector3.zero
            )
        end
    end

    return viewport
end

function module.setBorderColor(viewport: ViewportFrame, color: Color3)
    local border = viewport:FindFirstChildOfClass("UIStroke")
    if border then
        border.Color = color
    end
end

function module.setWorldModel(viewport: ViewportFrame, worldModel: Instance)
    -- Limpa modelos anteriores
    for _, child in ipairs(viewport:GetChildren()) do
        if not child:IsA("UIStroke") and not child:IsA("UICorner") then
            child:Destroy()
        end
    end
    
    worldModel.Parent = viewport
end

return module