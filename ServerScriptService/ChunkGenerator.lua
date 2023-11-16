--[[SERVICES]]--
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
--[[FOLDERS]]--
--[[MODULES]]--
local ChunkClass = require(script.Chunk)
--[[VARIABLES + EVENT CONNECTIONS]]--
--Chunk Information
local RenderDistance = 8 --Chunks in each direction
local ChunkLength = 64 --Length of each side in studs
--Asset Information
local BlockLength = 4 -- Length of Block in studs (Must be a divisor of Chunk Size)
--Script Variables
local ChunkList = {}
--[[
	Chunk Template
	[Vector3]	= {
		Biome: string = "",
		Blocks = {}
		Model: Model = Instance.new("Model")
	}
]]
--
--[[FUNTIONS]]--
--Render Chunks as a birds eye view
local function RenderChunks()
	local StartPosition: Vector2 = Vector2.new(-(RenderDistance * ChunkLength) / 2, -(RenderDistance * ChunkLength) / 2)
	local OriginalYPosition: number = StartPosition.Y

	for Row = 1, RenderDistance, 1 do
		for Column = 1, RenderDistance, 1 do
			--Create Chunk Position
			local ChunkPosition: Vector2 = StartPosition
			local Chunk = ChunkClass.new(ChunkPosition, ChunkLength, 1 * BlockLength, BlockLength)
			Chunk:RenderChunk()
			table.insert(ChunkList, Chunk)
			--Update Chunk Y Position for the next Chunk
			StartPosition += Vector2.new(0, ChunkLength)
		end
		--Reset Y Position for the next Row
		StartPosition = Vector2.new(StartPosition.X, OriginalYPosition)
		--Update the X Position for the next Row
		StartPosition += Vector2.new(ChunkLength, 0)
	end
end
--[[SCRIPT]]--
workspace.Baseplate:Destroy()
workspace:SetAttribute("ChunkLength", ChunkLength)
RenderChunks()
