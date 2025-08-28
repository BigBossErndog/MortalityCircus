Nodes:define("Heart", "Sprite", {
    texture = "tiles",
    frame = 8,
    tint = Colors.Red,

    onConfigure = function(self, config)
        if config.player then
            self.props.player = config.player
        end
        if config.tilemap then
            self.props.tilemap = config.tilemap
        end

        if config.tileX then
            self.x  = self.props.tilemap.left + (config.tileX + 0.5) * 16
        end
        if config.tileY then
            self.y  = self.props.tilemap.top + (config.tileY + 0.5) * 16
        end
    end,

    onCreate = function(self)
        self.props.timeOffset = math.random() * math.pi * 2
        self.props.startY = self.y

        self:createChild("Collider", {
            shape = Vector2.new(0, 0)
        })
    end,

    onUpdate = function(self)
        local player = self.props.player

        self.y = self.props.startY + math.sin((self.lifeTime + self.props.timeOffset) * 2)*2 - 2

        if not player.props.dead then
            if self.collider:overlaps(player.collider) then
                if player.props.healthBar.func:addHeart() then
                    self:destroy()
                end
            end
        end
    end
})