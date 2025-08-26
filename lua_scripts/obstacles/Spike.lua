Nodes:define("Spike", "Sprite", {
    texture = "tiles",
    frame = 5,
    origin = 0,

    onConfigure = function(self, config)
        if config.player then
            self.props.player = config.player
        end

        if config.tileX then
            self.x = config.tilemap.left + config.tileX * 16
        end
        if config.tileY then
            self.y = config.tilemap.top + config.tileY * 16
        end
    end,
    
    onCreate = function(self)
        self:createChild("Collider", {
            shape = Triangle.new(
                Vector2.new(4, 16),
                Vector2.new(8, 4),
                Vector2.new(12, 16)
            )
        })
    end,

    onUpdate = function(self)
        if self.collider:overlaps(self.props.player.collider) then
            self.tint = "red"
        else
            self.tint = "white"
        end
    end
})