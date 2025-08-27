Nodes:load("sprites/Player")

Nodes:load("obstacles/Spike")
Nodes:load("obstacles/Spinsaw")
Nodes:load("obstacles/Spring")
Nodes:load("obstacles/FallingBlock")

Nodes:define("Circus", "Scene", {
    onCreate = function(self)
        self.props.bg = self:createChild("Sprite", {
            fixedToCamera = true,
            texture = "circus_bg",
            depth = -100,
            onUpdate = function(self)
                self.x = -self.scene.camera.scroll.x * 0.1
                self.y = -self.scene.camera.scroll.y * 0.1
            end
        })

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
            elseif obstacle.id == 11 then
                local spinsaw = self:createChild("Spinsaw", {
                    player = player,
                    tilemap = tilemap,
                    tileX = obstacle.tileX,
                    tileY = obstacle.tileY,
                    targetX = obstacle.targetX,
                    targetY = obstacle.targetY,
                    startX = obstacle.startX,
                    startY = obstacle.startY,
                    depth = -1
                })
            elseif obstacle.id == 12 then
                local spring = self:createChild("Spring", {
                    player = player,
                    tilemap = tilemap,
                    tileX = obstacle.tileX,
                    tileY = obstacle.tileY,
                    depth = -1
                })
            elseif obstacle.id == 13 then
                local fallingBlock = self:createChild("FallingBlock", {
                    player = player,
                    tilemap = tilemap,
                    tileX = obstacle.tileX,
                    tileY = obstacle.tileY
                })
            end
        end

        self:createChild("CameraTarget", {
            player = player
        })
        self.camera.bounds = tilemap.rect
    end
})