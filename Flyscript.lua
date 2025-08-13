-- Variables
local player = game.Players.LocalPlayer
local flying = false
local speedLevel = 1 -- سرعة الطيران
local upPressed, downPressed = false, false

local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

-- Buttons
local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.Text = "Fly"
flyButton.TextScaled = true
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.TextColor3 = Color3.new(1,1,1)

local plusButton = Instance.new("TextButton", frame)
plusButton.Size = UDim2.new(0.5, -15, 0, 40)
plusButton.Position = UDim2.new(0, 10, 0, 60)
plusButton.Text = "+"
plusButton.TextScaled = true
plusButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
plusButton.TextColor3 = Color3.new(1,1,1)

local minusButton = Instance.new("TextButton", frame)
minusButton.Size = UDim2.new(0.5, -15, 0, 40)
minusButton.Position = UDim2.new(0.5, 5, 0, 60)
minusButton.Text = "-"
minusButton.TextScaled = true
minusButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
minusButton.TextColor3 = Color3.new(1,1,1)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 105)
speedLabel.Text = "Speed: "..speedLevel
speedLabel.TextScaled = true
speedLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedLabel.TextColor3 = Color3.new(1,1,1)

local upButton = Instance.new("TextButton", frame)
upButton.Size = UDim2.new(0.5, -15, 0, 40)
upButton.Position = UDim2.new(0, 10, 0, 140)
upButton.Text = "Up"
upButton.TextScaled = true
upButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
upButton.TextColor3 = Color3.new(1,1,1)

local downButton = Instance.new("TextButton", frame)
downButton.Size = UDim2.new(0.5, -15, 0, 40)
downButton.Position = UDim2.new(0.5, 5, 0, 140)
downButton.Text = "Down"
downButton.TextScaled = true
downButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
downButton.TextColor3 = Color3.new(1,1,1)

-- Toggle Fly function
local function toggleFly()
    flying = not flying
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")

    if flying then
        humanoid.PlatformStand = true

        -- No Clip
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        -- BodyVelocity للطيران
        local bodyVelocity = Instance.new("BodyVelocity", hrp)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0,0,0)

        -- تحديث الحركة كل فريم
        local conn
        conn = game:GetService("RunService").RenderStepped:Connect(function()
            if flying then
                local moveDir = humanoid.MoveDirection
                local camera = workspace.CurrentCamera

                -- حساب الاتجاه بناءً على الكاميرا
                local cameraCFrame = camera.CFrame
                local forwardVector = cameraCFrame.LookVector * Vector3.new(1, 0, 1) -- الاتجاه للأمام
                local rightVector = cameraCFrame.RightVector

                local direction = Vector3.new(0,0,0)

                if moveDir.Z > 0 then -- للأمام
                    direction = direction + forwardVector
                elseif moveDir.Z < 0 then -- للخلف
                    direction = direction - forwardVector
                end
                
                if moveDir.X > 0 then -- لليمين
                    direction = direction + rightVector
                elseif moveDir.X < 0 then -- لليسار
                    direction = direction - rightVector
                end

                -- Up/Down التحكم بالارتفاع
                if upPressed then direction = direction + Vector3.new(0,1,0) end
                if downPressed then direction = direction - Vector3.new(0,1,0) end
                
                bodyVelocity.Velocity = direction.Unit * (speedLevel * 10)
            else
                conn:Disconnect()
                bodyVelocity:Destroy()
                humanoid.PlatformStand = false
                -- إعادة CanCollide
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end)
    else
        -- إذا لم يكن هناك BodyVelocity، فلا تفعل شيئًا
        if hrp:FindFirstChild("BodyVelocity") then
            hrp.BodyVelocity:Destroy()
        end
        humanoid.PlatformStand = false
        -- إعادة CanCollide عند إيقاف الطيران
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Buttons
flyButton.MouseButton1Click:Connect(toggleFly)

plusButton.MouseButton1Click:Connect(function()
    speedLevel = speedLevel + 1
    speedLabel.Text = "Speed: "..speedLevel
end)

minusButton.MouseButton1Click:Connect(function()
    if speedLevel > 1 then
        speedLevel = speedLevel - 1
        speedLabel.Text = "Speed: "..speedLevel
    end
end)

upButton.MouseButton1Down:Connect(function() upPressed = true end)
upButton.MouseButton1Up:Connect(function() upPressed = false end)
downButton.MouseButton1Down:Connect(function() downPressed = true end)
downButton.MouseButton1Up:Connect(function() downPressed = false end)
