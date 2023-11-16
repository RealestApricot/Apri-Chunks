--[[SERVICES]]--
--[[FOLDERS]]--
--[[MODULES]]--
local BlockClass = require(script.Block)
--[[VARIABLES + EVENT CONNECTIONS]]--
--[[FUNCTIONS]]--
--[[SCRIPT]]--
local Chunk = {}
Chunk.__index = Chunk

function Chunk.new(ChunkPosition: Vector2, ChunkLength: number, ChunkDepth: number, BlockLength: number)
	local self = setmetatable({}, Chunk)

	self.ChunkPosition = ChunkPosition --Vector2
	self.ChunkLength = ChunkLength --number
	self.ChunkDepth = ChunkDepth --number
	self.BlockLength = BlockLength --number
	self.BlockList = {}

	return self
end

function Chunk:RenderChunk()
	local Offset: Vector3 = Vector3.new(-self.ChunkPosition / 2, -self.BlockLength / 2, -self.ChunkPosition / 2)
	local StartPosition: Vector3 = Vector3.new(self.ChunkPosition.X, 0, self.ChunkPosition.Y) + Offset
	local OriginalYPosition: number = StartPosition.Y
	local OriginalZPosition: number = StartPosition.Z

	self.Model = Instance.new("Model")
	self.Model.Name = self.ChunkPosition.X .. ", " .. self.ChunkPosition.Y
	self.Model:SetAttribute("ChunkPosition", self.ChunkPosition)
	self.Model.Parent = workspace.Chunks

	local BiomeColor: Color3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))

	for Row = 1, (self.ChunkLength / self.BlockLength), 1 do
		for Column = 1, (self.ChunkLength / self.BlockLength), 1 do
			for Layer = 1, (self.ChunkDepth / self.BlockLength), 1 do
				--Create Block and add to Block List
				local Block =
					BlockClass.new(self.ChunkPosition, StartPosition, self.BlockLength, BiomeColor, self.Model)
				Block:RenderBlock()

				table.insert(self.BlockList, Block)
				--Update Y Position for next Block
				StartPosition += Vector3.new(0, -self.BlockLength, 0)
			end
			--Reset Y Position for the next Column
			StartPosition = Vector3.new(StartPosition.X, OriginalYPosition, StartPosition.Z)
			--Update Z Position for next Column
			StartPosition += Vector3.new(0, 0, self.BlockLength)
		end
		--Reset Z Position for the next Row
		StartPosition = Vector3.new(StartPosition.X, StartPosition.Y, OriginalZPosition)
		--Update X Position for next Row
		StartPosition += Vector3.new(self.BlockLength, 0, 0)
	end
end

return Chunk
