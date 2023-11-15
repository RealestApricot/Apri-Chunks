--[[SERVICES]]--
--[[FOLDERS]]--
--[[MODULES]]--
--[[VARIABLES + EVENT CONNECTIONS]]--
--Chunk Information
local ChunksFolder = workspace.Chunks
local RenderDistance = 8 --Chunks in each direction
local ChunkSize = 64 --Length of each side in studs
--Asset Information
local ChunkPieceLength = 4 -- Length of ChunkPiece in studs (Must be a divisor of Chunk Size)
local ChunkPiece = Instance.new("Part")
ChunkPiece.Name = "ChunkPiece"
ChunkPiece.Size = Vector3.new(1, 1, 1) * ChunkPieceLength
ChunkPiece.Anchored = true
ChunkPiece.CanCollide = true
ChunkPiece.Material = Enum.Material.SmoothPlastic
ChunkPiece.BrickColor = BrickColor.new("Grey")
local PiecePerChunk = ChunkSize / ChunkPieceLength
--Script Variables
local ChunkList = {}
--[[
	Chunk Template
	[Vector3]	= {
		Biome: string = "",
		ChunkPieces = {}
		Model: Model = Instance.new("Model")
	}
]]--
--[[FUNTIONS]]--
local function CalculateNumber(Number: number)
	if Number < 0 then
		return math.floor(Number)
	else
		return math.ceil(Number)
	end
end

local function SetUpServer()
	workspace:SetAttribute("ChunkSize", 64)
end

--Fill in chunk based on biome information
local function FillChunk(ChunkPosition: Vector2, ChunkInfo)
	local StartPosition: Vector3 = Vector3.new(ChunkPosition.X, 0, ChunkPosition.Y)
		+ Vector3.new(-(ChunkSize / 2), -(ChunkPieceLength / 2), (-ChunkSize / 2))
	local OriginalZPosition: number = StartPosition.Z

	local RedColor = math.random(0, 255)
	local GreenColor = math.random(0, 255)
	local BlueColor = math.random(0, 255)
	local BiomeColor: Color3 = Color3.fromRGB(RedColor, GreenColor, BlueColor)

	local XPosition: number = CalculateNumber(ChunkPosition.X / ChunkSize)
	local YPosition: number = CalculateNumber(ChunkPosition.Y / ChunkSize)
	local ChunkModel = Instance.new("Model")
	ChunkModel.Name = XPosition .. ", " .. YPosition
	ChunkModel.Parent = ChunksFolder

	ChunkInfo.Model = ChunkModel

	for Row = 1, PiecePerChunk, 1 do
		for Column = 1, PiecePerChunk, 1 do
			--Create Chunk Piece Position
			local ChunkPiecePosition: Vector3 = StartPosition
				+ Vector3.new(ChunkPieceLength / 2, 0, ChunkPieceLength / 2)
			local ChunkPiecePart = ChunkPiece:Clone()
			ChunkPiecePart.Name = Row .. ", " .. Column
			ChunkPiecePart.Position = ChunkPiecePosition
			ChunkPiecePart.Color = BiomeColor
			ChunkPiecePart:SetAttribute("Chunk", ChunkPosition)
			ChunkPiecePart:SetAttribute("ChunkPosition", Vector2.new(Row, Column))
			ChunkPiecePart.Parent = ChunkModel
			--Add Chunk Piece to ChunkPieceList
			table.insert(ChunkInfo.ChunkPieces, ChunkPiecePart)
			--Update Z Position for next ChunkPiece
			StartPosition += Vector3.new(0, 0, ChunkPieceLength)
		end
		--Reset Z Position for the next Row
		StartPosition = Vector3.new(StartPosition.X, StartPosition.Y, OriginalZPosition)
		--Update X Position for next Row
		StartPosition += Vector3.new(ChunkPieceLength, 0, 0)
	end
end

--Create the chunk and add information to chunklist
local function CreateChunk(ChunkPosition: Vector2, Biome)
	Biome = Biome or "Default"
	--Add Chunk to ChunkList
	ChunkList[ChunkPosition] = {
		Biome = Biome,
		ChunkPieces = {},
	}

	FillChunk(ChunkPosition, ChunkList[ChunkPosition])
end

--Render Chunks as a birds eye view
local function RenderChunks()
	local StartPosition: Vector2 = Vector2.new(-(RenderDistance * ChunkSize) / 2, -(RenderDistance * ChunkSize) / 2)
	local OriginalYPosition: number = StartPosition.Y

	for Row = 1, RenderDistance, 1 do
		for Column = 1, RenderDistance, 1 do
			--Create Chunk Position
			local ChunkPosition: Vector2 = StartPosition + Vector2.new(ChunkSize / 2, ChunkSize / 2)
			CreateChunk(ChunkPosition)
			--Update Chunk Y Position for the next Chunk
			StartPosition += Vector2.new(0, ChunkSize)
		end
		--Reset Y Position for the next Row
		StartPosition = Vector2.new(StartPosition.X, OriginalYPosition)
		--Update the X Position for the next Row
		StartPosition += Vector2.new(ChunkSize, 0)
	end
end
--[[SCRIPT]]
--
workspace.Baseplate:Destroy()
SetUpServer()
RenderChunks()
