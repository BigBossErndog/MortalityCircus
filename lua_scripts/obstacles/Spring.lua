Nodes:define("Spring", "Sprite", {
    texture = "spring",
    origin = { 0.5, 1 },

    props = {
        state = 1
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
            self.y = self.props.tilemap.top + (config.tileY + 1) * 16
        end
    end,

    onCreate = function(self)
        self.props.pad = self:createChild("Sprite", {
            texture = "spring",
            frame = 2,
            origin = { 0.5, 0 },
            y = -4
        })
        self:createChild("Collider", {
            shape = Rectangle.new(-8, -4, 16, 4)
        })
    end,

    onUpdate = function(self)
        local player = self.props.player

        self.cropTop = self.props.pad.y + 16 + 1
        if self.props.state == 1 and not player.props.dead then
            if self.collider:overlaps(player.collider) then
                self.props.state = 2

                if self.props.player.y > self.y - 16.1 then
                    self.props.player.y = self.y - 16.1
                end

                player.collider.velocity.y = -450
                player.props.jumping = 1
                player.props.bounced = true
                player.animation = "jumping"

                self.props.pad.tween:to({
                    y = -16,
                    duration = 0.4,
                    ease = Ease.ElasticOut,
                    onComplete = function()
                        self:wait(2, function()
                            self.props.pad.tween:to({
                                y = -5,
                                duration = 2,
                                ease = Ease.SineInOut,
                                onComplete = function()
                                    self.props.state = 1
                                end
                            })
                        end)
                    end
                })
            end
        end
    end
})