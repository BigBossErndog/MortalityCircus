Nodes:define("Heart", "Sprite", {
    texture = "tiles",
    frame = 8,
    tint = Colors.Red,

    onConfigure = function(self, config)
        if config.player then
            self.get.player = config.player
        end
        if config.tilemap then
            self.get.tilemap = config.tilemap
        end

        if config.tileX then
            self.x  = self.get.tilemap.left + (config.tileX + 0.5) * 16
        end
        if config.tileY then
            self.y  = self.get.tilemap.top + (config.tileY + 0.5) * 16
        end
    end,

    onCreate = function(self)
        self.get.timeOffset = math.random() * math.pi * 2
        self.get.startY = self.y

        self:createChild("Collider", {
            shape = Vector2.new(0, 0)
        })
    end,

    onUpdate = function(self)
        local player = self.get.player

        self.y = self.get.startY + math.sin((self.lifeTime + self.get.timeOffset) * 2)*2 - 2

        if not player.get.dead then
            if self.collider:overlaps(player.collider) then
                if player.get.healthBar.get:addHeart() then
                    self.audio:play("sfx/heart")
                    self:destroy()
                end
            end
        end
    end
})