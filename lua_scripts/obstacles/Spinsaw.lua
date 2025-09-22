Nodes:define("Spinsaw", "Sprite", {
    texture = "spinsaw",

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
        if config.targetX then
            self.get.targetX = self.get.tilemap.left + (config.targetX + 0.5) * 16
        end
        if config.targetY then
            self.get.targetY = self.get.tilemap.top + (config.targetY + 1) * 16
        end
        if config.startX then
            self.get.startX = self.get.tilemap.left + (config.startX + 0.5) * 16
        end
        if config.startY then
            self.get.startY = self.get.tilemap.top + (config.startY + 1) * 16
        end
        if config.travelTime then
            self.get.travelTime = config.travelTime
        end
    end,

    onCreate = function(self)
        if not self.get.targetX then
            self.get.targetX = self.x
        end
        if not self.get.targetY then
            self.get.targetY = self.y
        end
        if not self.get.startX then
            self.get.startX = self.x
        end
        if not self.get.startY then
            self.get.startY = self.y
        end
        if not self.get.travelTime then
            self.get.travelTime = 2
        end

        self:createChild("Collider", {
            shape = Circle.new(0, 0, 8)
        })

        self.tween:to({
            x = self.get.targetX,
            y = self.get.targetY,
            duration = self.get.travelTime,
            ease = Ease.SineInOut,
            yoyo = true,
            repeats = -1,
            onComplete = function()
                self.func:moveToStart()
            end
        })
    end,

    onUpdate = function(self)
        self.rotation = self.rotation + 0.5
        self.tint = Colors.White
        if self.get.player and (not self.get.player.props.dead) and (not self.scene.props.timer.props.finished) then
            if self.collider:overlaps(self.get.player.collider) then
                self.get.player.func:hurt({
                    epicenter = self.pos
                })
            end
        end
    end
})