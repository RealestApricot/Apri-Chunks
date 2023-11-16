--[[SERVICES]]--
--[[FOLDERS]]--
--[[MODULES]]--
--[[VARIABLES + EVENT CONNECTIONS]]--
--[[FUNCTIONS]]--
--[[SCRIPT]]--
local Block = {}
Block.__index = Block

function Block.new(
	ChunkPosition: Vector3,
	BlockPosition: Vector3,
	BlockLength: number,
	BiomeColor: Color3,
	ChunkModel: Model
)
	local NewBlock = setmetatable({}, Block)

	NewBlock.ChunkPosition = ChunkPosition
	NewBlock.BlockPosition = BlockPosition
	NewBlock.BlockLength = BlockLength
	NewBlock.BlockColor = BiomeColor
	NewBlock.ChunkModel = ChunkModel

	return NewBlock
end

function Block:RenderBlock()
	--Create Block at Position
	self.Part = Instance.new("Part")
	self.Part.Name = self.BlockPosition.X .. ", " .. self.BlockPosition.Y .. ", " .. self.BlockPosition.Z
	self.Part.Anchored = true
	self.Part.CanCollide = true
	self.Part.Size = Vector3.new(1, 1, 1) * self.BlockLength
	self.Part.Position = self.BlockPosition
	self.Part.Material = Enum.Material.SmoothPlastic
	self.Part.Color = self.BlockColor
	self.Part:SetAttribute("Chunk", self.ChunkPosition)
	self.Part:SetAttribute("ChunkPosition", Vector2.new(self.ChunkPosition.X, self.ChunkPosition.Y))
	self.Part.Parent = self.ChunkModel
end

return Block
