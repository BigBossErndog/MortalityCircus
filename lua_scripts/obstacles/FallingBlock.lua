Nodes:define("FallingBlock", "Sprite", {
    texture = "tiles",
    frame = 14,
    origin = 0,

    props = {
        falling = false
    },

    onConfigure = function(self, config)
        if config.player then
            self.props.player = config.player
        end
        if config.tilemap then
            self.props.tilemap = config.tilemap
        end
        if config.tileX then
            self.x = self.props.tilemap.left + config.tileX * 16
        end
        if config.tileY then
            self.y = self.props.tilemap.top + config.tileY * 16
        end
    end,

    onCreate = function(self)
        self.props.startX = self.x
        self.props.startY = self.y

        self:createChild("Collider")
        if self.props.player then
            self.props.player.collider:addCollisionTarget(self)
        end
    end,

    onUpdate = function(self)
        if (not self.props.falling) and (not self.props.player.props.dead) then
            self.y = self.props.startY - 1
            if self.collider:overlaps(self.props.player.collider) then
                self.func:fall()
            end
            self.y = self.props.startY
        end
    end,

    fall = function(self)
        self.props.falling = true
        self:wait(0.25):next(function()
            self:bringToFront()
            self.collider.acceleration.y = 800
        end)
    end
})