Nodes:define("Circus", "Scene", {
    onPreload = function(self)
        self.load:image("tiles", "tilemaps/tiles.png")
        self.load:tilemap("test", "tilemaps/test.tmx")
    end,

    onCreate = function(self)
        local player = self:createChild("Player", {
            y = 28
        })

        local tilemap = self:createChild("Tilemap", {
            texture = "tiles",
            tilemap = "test",
            origin = 0.5
        })
        local floor = tilemap.children["floor"]

        player.collider.target = floor

        local leftBound = self:createChild("FillRect", {
            width = 1,
            height = tilemap.heightInPixels,
            x = tilemap.x - tilemap.widthInPixels*tilemap.origin.x - 1,
            y = tilemap.y
        })

        local rightBound = self:createChild("FillRect", {
            width = 1,
            height = tilemap.heightInPixels,
            x = tilemap.x + tilemap.widthInPixels*(1 -tilemap.origin.x) + 1,
            y = tilemap.y
        })

        player.collider:addCollisionTarget(leftBound)
        player.collider:addCollisionTarget(rightBound)
        
        self.camera:startFollow(player, 0.95)
        self.camera.bounds = tilemap.rect
    end
})