Nodes:define("EndPost", "Sprite",  {
    id = "endPost",
    texture = "endPost",
    origin = { 0.5, 1 },

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
        self:createChild("Collider", {
            shape = Rectangle.new(-1, -16, 2, 16)
        })

        self.scene.camera:focusOn(self)
        
        local cameraTarget = self.scene.get.cameraTarget
        local player = self.get.player
        self:wait(1, function()
            self.audio:play("music/alma-espanola")
            self.scene.camera.tween:to({
                scroll = player.pos,
                duration = 5,
                ease = Ease.SineInOut,
                onComplete = function()
                    self.scene:createChild("StartSign", {
                        onComplete = function()
                            local loss = -15 - math.floor(GameData.day / 7)*5
                            self.scene.get.mentalMeter.get:changeValue(loss)
                            local txt = self.scene.get.moneyNotif.get:show(tostring(loss))
                            txt.color = "#a8ffff"

                            cameraTarget.get:startFollow()
                            self.scene.get.timer.get:start()
                            player.get.controlsAllowed = true
                        end
                    })
                end
            })
        end)
    end,

    onUpdate = function(self)
        local player = self.get.player
        
        if (not player.get.dead) and (not self.scene.get.timer.get.finished) then
            if self.collider:overlaps(player.collider) and player.collider:hasCollided(Direction.Down) then
                local timer = self.scene.get.timer
                timer.get:stop()
                timer.get.finished = true

                self.scene.get.results.finished = true

                self.scene:createChild("EndSign", {
                    onComplete = function()
                        self.scene:createChild("FillTransition", {
                            fadeIn = 1,
                            fadeOut = 2,
                            interim = 1,
                            next = {
                                node = "CircusResults",
                                props = self.scene.get.results
                            }
                        })
                    end
                })
            end
        end
    end
})