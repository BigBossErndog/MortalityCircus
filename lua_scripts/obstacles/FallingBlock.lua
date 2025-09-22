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
            self.get.player = config.player
        end
        if config.tilemap then
            self.get.tilemap = config.tilemap
        end
        if config.tileX then
            self.x = self.get.tilemap.left + config.tileX * 16
        end
        if config.tileY then
            self.y = self.get.tilemap.top + config.tileY * 16
        end
    end,

    onCreate = function(self)
        self.get.startX = self.x
        self.get.startY = self.y

        self:createChild("Collider")
        if self.get.player then
            self.get.player.collider:addCollisionTarget(self)
        end
    end,

    onUpdate = function(self)
        if (not self.get.falling) and (not self.get.player.get.dead) and (not self.scene.get.timer.get.finished) then
            self.y = self.get.startY - 1
            if self.collider:overlaps(self.get.player.collider) then
                self.get:fall()
            else
                self.y = self.get.startY + 1
                if self.collider:overlaps(self.get.player.collider) then
                    self.get.hit = true
                    self.collider.velocity.x = (self.x - self.get.player.x)
                    self.collider.velocity.y = -50 - math.random() * 50
                    self.get:fall()
                end
            end
            self.y = self.get.startY
        end
    end,

    fall = function(self)
        self.get.falling = true
        local waitTime = self.get.hit and 0 or 0.25
        self:wait(0.25):next(function()
            self.collider.acceleration.y = 800
            self.get.player.collider:removeCollisionTarget(self.collider)
            self.audio:play("sfx/drop")
            
            local waiter = self:wait(3, function()
                self.collider.acceleration.y = 0
                self.collider.velocity = 0
                self.pos = { self.get.startX, self.get.startY + 4}
                
                self.get.hit = false
                self.rotation = 0

                self.alpha = 0
                self.tween:to({
                    alpha = 1,
                    duration = 0.5,
                    y = self.get.startY,
                    onComplete = function()
                        self:createChild("Action", {
                            onAct = function(actor, action)
                                if not self.collider:overlaps(self.get.player.collider) then
                                    self.get.player.collider:addCollisionTarget(self.collider)
                                    self.get.falling = false
                                    action:complete()
                                end
                            end
                        })
                    end
                })
            end)

            waiter.get.onUpdate = function()
                if self.get.hit then
                    self.rotation = self.rotation + self.collider.velocity.x
                end
            end
        end)
    end
})