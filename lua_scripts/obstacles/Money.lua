Nodes:define("Money", "Sprite", {
    texture = "tiles",
    frame = 6,

    props = {
        value = 10 
    },

    onConfigure = function(self, config)
        if config.player then
            self.get.player = config.player
        end
        if config.tilemap then
            self.get.tilemap = config.tilemap
        end

        if config.tileX then
            self.x = self.get.tilemap.left + (config.tileX + 0.5) * 16
        end
        if config.tileY then
            self.y = self.get.tilemap.top + (config.tileY + 0.5) * 16
        end

        if config.value then
            self.get.value = config.value
        end
    end,

    onCreate = function(self)
        self.get.startY = self.y
        self.get.timeOffset = math.random() * math.pi * 2

        self:createChild("Collider", {
            shape = Rectangle.new(-3, -3, 6, 6)
        })
    end,

    onUpdate = function(self)
        local player = self.get.player

        self.y = self.get.startY + math.sin(self.lifeTime * 2 + self.get.timeOffset) * 2

        if not player.get.dead then
            if self.collider:overlaps(player.collider) then
                self.scene.get.results.moneyCollected = self.scene.get.results.moneyCollected + self.get.value
                self.scene.get.moneyNotif.func:show("$" .. self.get.value)
                self.audio:play("sfx/coin")
                self:destroy()
            end
        end
    end
})