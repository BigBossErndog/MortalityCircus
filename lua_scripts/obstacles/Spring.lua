Nodes:define("Spring", "Sprite", {
    texture = "spring",
    origin = { 0.5, 1 },

    props = {
        state = 1
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
            self.y = self.get.tilemap.top + (config.tileY + 1) * 16
        end
    end,

    onCreate = function(self)
        self.get.pad = self:createChild("Sprite", {
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
        local player = self.get.player

        self.cropTop = self.get.pad.y + 16 + 1
        if self.get.state == 1 and player.get:allowControls() and not player.get.dead then
            if self.collider:overlaps(player.collider) then
                self.get.state = 2

                self.audio:play("sfx/spring")

                if self.get.player.y > self.y - 16.1 then
                    self.get.player.y = self.y - 16.1
                end

                player.collider.velocity.y = -450
                player.get.jumping = 1
                player.get.bounced = true
                player.animation = "jumping"

                self.get.pad.tween:to({
                    y = -16,
                    duration = 0.4,
                    ease = Ease.ElasticOut,
                    onComplete = function()
                        self:wait(1, function()
                            self.get.pad.tween:to({
                                y = -5,
                                duration = 2,
                                ease = Ease.SineInOut,
                                onComplete = function()
                                    self.get.state = 1
                                end
                            })
                        end)
                    end
                })
            end
        end
    end
})