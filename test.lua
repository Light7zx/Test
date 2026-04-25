-- SIMPLE UI + REMOTE SPY + MINIMIZE & CLOSE

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SpyUI"

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(0.5, -225, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- TOP BAR
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(20,20,20)

-- TITLE
local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "Remote Spy UI"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- MINIMIZE BUTTON
local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0, 30, 1, 0)
minBtn.Position = UDim2.new(1, -60, 0, 0)
minBtn.Text = "-"

-- CONTENT FRAME
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -30)
content.Position = UDim2.new(0, 0, 0, 30)
content.BackgroundTransparency = 1

-- TAB BUTTONS
local tab1Btn = Instance.new("TextButton", content)
tab1Btn.Size = UDim2.new(0, 225, 0, 30)
tab1Btn.Position = UDim2.new(0, 0, 0, 0)
tab1Btn.Text = "Log"

local tab2Btn = Instance.new("TextButton", content)
tab2Btn.Size = UDim2.new(0, 225, 0, 30)
tab2Btn.Position = UDim2.new(0, 225, 0, 0)
tab2Btn.Text = "Tab 2"

-- TAB FRAMES
local tab1 = Instance.new("Frame", content)
tab1.Size = UDim2.new(1, 0, 1, -30)
tab1.Position = UDim2.new(0, 0, 0, 30)
tab1.BackgroundColor3 = Color3.fromRGB(40,40,40)

local tab2 = Instance.new("Frame", content)
tab2.Size = tab1.Size
tab2.Position = tab1.Position
tab2.BackgroundColor3 = Color3.fromRGB(40,40,40)
tab2.Visible = false

-- SCROLL LOG
local scrolling = Instance.new("ScrollingFrame", tab1)
scrolling.Size = UDim2.new(1, -10, 1, -40)
scrolling.Position = UDim2.new(0, 5, 0, 5)
scrolling.CanvasSize = UDim2.new(0,0,0,0)
scrolling.BackgroundColor3 = Color3.fromRGB(25,25,25)

local layout = Instance.new("UIListLayout", scrolling)

-- CLEAR BUTTON
local clearBtn = Instance.new("TextButton", tab1)
clearBtn.Size = UDim2.new(1, -10, 0, 30)
clearBtn.Position = UDim2.new(0, 5, 1, -35)
clearBtn.Text = "Clear Log"

clearBtn.MouseButton1Click:Connect(function()
    for _,v in pairs(scrolling:GetChildren()) do
        if v:IsA("TextLabel") then
            v:Destroy()
        end
    end
end)

-- ADD LOG
local function addLog(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -5, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = scrolling

    scrolling.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 10)
end

-- TAB SWITCH
tab1Btn.MouseButton1Click:Connect(function()
    tab1.Visible = true
    tab2.Visible = false
end)

tab2Btn.MouseButton1Click:Connect(function()
    tab1.Visible = false
    tab2.Visible = true
end)

-- MINIMIZE LOGIC
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        content.Visible = false
        main.Size = UDim2.new(0, 450, 0, 30)
    else
        content.Visible = true
        main.Size = UDim2.new(0, 450, 0, 300)
    end
end)

-- REMOTE SPY
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" then
        local argStr = ""
        for i,v in pairs(args) do
            argStr = argStr .. tostring(v) .. ", "
        end

        addLog("[FireServer] " .. self.Name .. " -> " .. argStr)
    end

    return old(self, ...)
end)
