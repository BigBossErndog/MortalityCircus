Nodes:define("FallingBlock", "Sprite", {
    texture = "tiles",
    frame = 14,
    origin = 0,

    props = {
        falling = false,
        hit = false
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
        if (not self.props.falling) and (not self.props.player.props.dead) and (not self.scene.props.timer.props.finished) then
            self.y = self.props.startY - 1
            if self.collider:overlaps(self.props.player.collider) then
                self.func:fall()
            else
                self.y = self.props.startY + 1
                if self.collider:overlaps(self.props.player.collider) then
                    self.props.hit = true
                    self.collider.velocity.x = (self.x - self.props.player.x)
                    self.collider.velocity.y = -50 - math.random() * 50
                    self.func:fall()
                end
            end
            self.y = self.props.startY
        end
    end,

    fall = function(self)
        self.props.falling = true
        local waitTime = self.props.hit and 0 or 0.25
        self:wait(0.25):next(function()
            self:bringToFront()
            self.collider.acceleration.y = 800
            self.props.player.collider:removeCollisionTarget(self.collider)

            local waiter = self:wait(5, function()
                self.collider.acceleration.y = 0
                self.collider.velocity = 0
                self.pos = { self.props.startX, self.props.startY + 4}
                
                self.props.hit = false
                self.rotation = 0

                self.alpha = 0
                self.tween:to({
                    alpha = 1,
                    duration = 0.5,
                    y = self.props.startY,
                    onComplete = function()
                        self:createChild("Action", {
                            onAct = function(actor, action)
                                if not self.collider:overlaps(self.props.player.collider) then
                                    self.props.player.collider:addCollisionTarget(self.collider)
                                    self.props.falling = false
                                    action:complete()
                                end
                            end
                        })
                    end
                })
            end)

            waiter.func.onUpdate = function()
                if self.props.hit then
                    self.rotation = self.rotation + self.collider.velocity.x
                end
            end
        end)
    end
})