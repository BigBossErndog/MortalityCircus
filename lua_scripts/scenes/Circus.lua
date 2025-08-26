Nodes:load("sprites/Player")

Nodes:load("obstacles/Spike")

Nodes:define("Circus", "Scene", {
    onPreload = function(self)
        self.load:spritesheet("tiles", "tilemaps/tiles.png", 16, 16)
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

        local obstacles = tilemap.objects.obstacles
        
        for i = 1, #obstacles do
            local obstacle = obstacles[i]
            
            if obstacle.id == 10 then
                player.x = tilemap.left + (obstacle.tileX + 0.5) * 16
                player.y = tilemap.top + (obstacle.tileY + 0.5) * 16 - 8.1
            elseif obstacle.id == 4 then
                local spike = self:createChild("Spike", {
                    player = player,
                    tilemap = tilemap,
                    tileX = obstacle.tileX,
                    tileY = obstacle.tileY
                })
            end
        end
        
        self.camera:startFollow(player, 0.95)
        self.camera.bounds = tilemap.rect
    end
})