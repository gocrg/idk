-- Custom Notification Library
local NotificationLibrary = {}

-- Create GUI once
local AbyssGUI = Instance.new("ScreenGui")
AbyssGUI.Name = "Abyss"
AbyssGUI.Parent = game:GetService("CoreGui")
AbyssGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Unique notification ID
local NotificationCount = 0

function NotificationLibrary:Notify(TitleText, Desc, Delay)
	Delay = Delay or 10
	NotificationCount += 1
	local ID = NotificationCount

	local Notification = Instance.new("Frame")
	Notification.Name = "Notification_" .. ID
	Notification.Parent = AbyssGUI
	Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Notification.BackgroundTransparency = 0.4
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(1, 5, 0, 75 + ((ID - 1) * 70))
	Notification.Size = UDim2.new(0, 450, 0, 60)

	local Line = Instance.new("Frame")
	Line.Name = "Line"
	Line.Parent = Notification
	Line.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0, 0, 0.938, 0)
	Line.Size = UDim2.new(0, 0, 0, 4)

	local Warning = Instance.new("ImageLabel")
	Warning.Name = "Warning"
	Warning.Parent = Notification
	Warning.BackgroundTransparency = 1.0
	Warning.Position = UDim2.new(0.025, 0, 0.089, 0)
	Warning.Size = UDim2.new(0, 44, 0, 49)
	Warning.Image = "https://preview.redd.it/sleep-isnt-that-important-anyways-v0-r9petm9v4v0d1.png?width=1080&crop=smart&auto=webp&s=4e4a669946d59a7ecdfa7d7d1144965c7cbd784a"
	Warning.ScaleType = Enum.ScaleType.Fit

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 20)
	UICorner.Parent = Warning

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Parent = Notification
	Title.BackgroundTransparency = 1.0
	Title.Position = UDim2.new(0.161, 0, 0.155, 0)
	Title.Size = UDim2.new(0, 275, 0, 15)
	Title.Text = TitleText
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 12.0
	Title.TextStrokeTransparency = 0.5
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local Description = Instance.new("TextLabel")
	Description.Name = "Description"
	Description.Parent = Notification
	Description.BackgroundTransparency = 1.0
	Description.Position = UDim2.new(0.161, 0, 0.483, 0)
	Description.Size = UDim2.new(0, 275, 0, 18)
	Description.Text = Desc
	Description.TextColor3 = Color3.fromRGB(199, 199, 199)
	Description.TextSize = 12.0
	Description.TextStrokeTransparency = 0.5
	Description.TextXAlignment = Enum.TextXAlignment.Left

	Notification:TweenPosition(UDim2.new(1, -460, 0, 75 + ((ID - 1) * 70)), "Out", "Sine", 0.35, true)
	task.wait(0.35)
	Line:TweenSize(UDim2.new(0, 450, 0, 4), "Out", "Linear", Delay, true)

	task.wait(Delay)
	Notification:TweenPosition(UDim2.new(1, 5, 0, 75 + ((ID - 1) * 70)), "Out", "Sine", 0.35, true)
	task.wait(0.35)
	Notification:Destroy()
end

-- Weapon detection logic
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local distanceThreshold = 30
local checkInterval = 1
local notified = {}

-- Scan loop
task.spawn(function()
	while true do
		task.wait(checkInterval)
		local character = LocalPlayer.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then continue end

		local hrp = character.HumanoidRootPart
		for _, tool in ipairs(workspace:WaitForChild("Weapons"):GetChildren()) do
			if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
				local dist = (tool.Handle.Position - hrp.Position).Magnitude
				if dist <= distanceThreshold and not notified[tool] then
					notified[tool] = true
					NotificationLibrary:Notify("Nearby Weapon", tool.Name .. " is " .. math.floor(dist) .. " studs away", 7)
				elseif dist > distanceThreshold then
					notified[tool] = nil
				end
			end
		end
	end
end)

--made by goc 
--discord: prodsaturn