-- Variables
local player = game.Players.LocalPlayer
local flying = false
local speedLevel = 1
local bodyGyro, bodyVelocity
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

-- Fly button
local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.Text = "Fly"
flyButton.TextScaled = true
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.TextColor3 = Color3.new(1,1,1)

-- Speed +/- buttons
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
speedLabel.Text = "Speed: 1"
speedLabel.TextScaled = true
speedLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedLabel.TextColor3 = Color3.new(1,1,1)

-- Up/Down buttons
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

-- Toggle Fly
local function toggleFly()
    flying = not flying
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")

    if flying then
        humanoid.PlatformStand = true

        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.P = 9e4
        bodyGyro.maxTorque = Vector3.new(9e9,9e9,9e9)
        bodyGyro.cframe = hrp.CFrame

        bodyVelocity = Instance.new("BodyVelocity", hrp)
        bodyVelocity.maxForce = Vector3.new(0,9e9,0) -- فقط Y
        bodyVelocity.velocity = Vector3.new(0,0,0)

        -- RenderStepped loop
        local conn
        conn = game:GetService("RunService").RenderStepped:Connect(function()
            if flying then
                local velY = 0
                if upPressed then velY = speedLevel*10 end
                if downPressed then velY = -speedLevel*10 end
                bodyVelocity.velocity = Vector3.new(0, velY, 0)
                bodyGyro.cframe = hrp.CFrame
            else
                conn:Disconnect()
            end
        end)
    else
        humanoid.PlatformStand = false
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end

-- Fix + / - to increase/decrease 1 فقط
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

-- Up / Down buttons
upButton.MouseButton1Down:Connect(function() upPressed = true end)
upButton.MouseButton1Up:Connect(function() upPressed = false end)
downButton.MouseButton1Down:Connect(function() downPressed = true end)
downButton.MouseButton1Up:Connect(function() downPressed = false end)

-- Fly button
flyButton.MouseButton1Click:Connect(toggleFly)
