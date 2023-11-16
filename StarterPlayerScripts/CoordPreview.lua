--[[SERVICES]]--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
--[[FOLDERS]]--
--[[MODULES]]--
--[[VARIABLES + EVENT CONNECTIONS]]--
--Client Variables
local Client = Players.LocalPlayer
local Character = Client.Character or Client.CharacterAdded:Wait()
repeat
	task.wait()
until Character.PrimaryPart ~= nil
local CharacterPrimaryPart = Character.PrimaryPart
--GUI Variables
local PlayerGUI = Client.PlayerGui
local ScreenGUI = Instance.new("ScreenGui")
ScreenGUI.Parent = PlayerGUI
local Frame = Instance.new("Frame")
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.8, 0)
Frame.Size = UDim2.new(0, 500, 0, 100)
Frame.BackgroundTransparency = 1
Frame.Parent = ScreenGUI
local TextLabel = Instance.new("TextLabel")
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.FontFace = Font.fromName("ComicNeueAngular")
TextLabel.TextScaled = true
TextLabel.BackgroundTransparency = 1
TextLabel.Parent = Frame
--[[SERVER VARIABLES]]--
local ChunkLength: number = workspace:GetAttribute("ChunkLength")
--[[FUNTIONS]]--
local function CalculateNumber(Number: number)
	if Number < 0 then
		return math.floor(Number)
	else
		return math.ceil(Number)
	end
end

local function UpdateText(DeltaTime: number)
	local XPosition: number = CalculateNumber(CharacterPrimaryPart.Position.X / ChunkLength)
	local ZPosition: number = CalculateNumber(CharacterPrimaryPart.Position.Z / ChunkLength)
	TextLabel.Text = "Chunk Coord: (" .. XPosition .. ", " .. ZPosition .. ")"
end
--[[SCRIPT]]--
RunService.Heartbeat:Connect(UpdateText)
