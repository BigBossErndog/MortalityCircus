Nodes:define("Spinsaw", "Sprite", {
    texture = "spinsaw",

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
        if config.targetX then
            self.props.targetX = self.props.tilemap.left + (config.targetX + 0.5) * 16
        end
        if config.targetY then
            self.props.targetY = self.props.tilemap.top + (config.targetY + 1) * 16
        end
        if config.startX then
            self.props.startX = self.props.tilemap.left + (config.startX + 0.5) * 16
        end
        if config.startY then
            self.props.startY = self.props.tilemap.top + (config.startY + 1) * 16
        end
        if config.travelTime then
            self.props.travelTime = config.travelTime
        end
    end,

    onCreate = function(self)
        if not self.props.targetX then
            self.props.targetX = self.x
        end
        if not self.props.targetY then
            self.props.targetY = self.y
        end
        if not self.props.startX then
            self.props.startX = self.x
        end
        if not self.props.startY then
            self.props.startY = self.y
        end
        if not self.props.travelTime then
            self.props.travelTime = 2
        end

        self:createChild("Collider", {
            shape = Circle.new(0, 0, 10)
        })

        self.func:moveToTarget()
    end,

    moveToTarget = function(self)
        self.tween:to({
            x = self.props.targetX,
            y = self.props.targetY,
            duration = self.props.travelTime,
            ease = Ease.SineInOut,
            onProgress = function()
                -- print(self)
            end,
            onComplete = function()
                self.func:moveToStart()
            end
        })
    end,
    moveToStart = function(self)
        self.tween:to({
            x = self.props.startX,
            y = self.props.startY,
            duration = self.props.travelTime,
            ease = Ease.SineInOut,
            onComplete = function()
                self.func:moveToTarget()
            end
        })
    end,

    onUpdate = function(self)
        self.rotation = self.rotation + 0.5
        self.tint = Colors.White
        if self.props.player and not self.props.player.props.dead then
            if self.collider:overlaps(self.props.player.collider) then
                self.props.player.func:die({
                    epicenter = self.pos
                })
            end
        end
    end
})