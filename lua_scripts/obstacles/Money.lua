Nodes:define("Money", "Sprite", {
    texture = "tiles",
    frame = 6,

    props = {
        value = 10 
    },

    onConfigure = function(self, config)
        if config.player then
            self.props.player = config.player
        end
        if config.tilemap then
            self.props.tilemap = config.tilemap
        end

        if config.tileX then
            self.x = self.props.tilemap.left + (config.tileX + 0.5) * 16
        end
        if config.tileY then
            self.y = self.props.tilemap.top + (config.tileY + 0.5) * 16
        end

        if config.value then
            self.props.value = config.value
        end
    end,

    onCreate = function(self)
        self.props.startY = self.y
        self.props.timeOffset = math.random() * math.pi * 2

        self:createChild("Collider", {
            shape = Rectangle.new(-3, -3, 6, 6)
        })
    end,

    onUpdate = function(self)
        local player = self.props.player

        self.y = self.props.startY + math.sin(self.lifeTime * 2 + self.props.timeOffset) * 2

        if not player.props.dead then
            if self.collider:overlaps(player.collider) then
                self.scene.props.results.moneyCollected = self.scene.props.results.moneyCollected + self.props.value
                self:destroy()
                self.scene.props.moneyNotif.func:show("$" .. self.props.value)
            end
        end
    end
})