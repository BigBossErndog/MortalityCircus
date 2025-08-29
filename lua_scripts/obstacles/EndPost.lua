Nodes:define("EndPost", "Sprite",  {
    id = "endPost",
    texture = "endPost",
    origin = { 0.5, 1 },

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
        self:createChild("Collider", {
            shape = Rectangle.new(-1, -16, 2, 16)
        })

        self.scene.camera:focusOn(self)
        
        local cameraTarget = self.scene.props.cameraTarget
        local player = self.props.player
        self:wait(1, function()
            self.scene.camera.tween:to({
                scroll = player.pos,
                duration = 5,
                ease = Ease.SineInOut,
                onComplete = function()
                    self.scene:createChild("StartSign", {
                        onComplete = function()
                            cameraTarget.func:startFollow()
                            self.scene.props.timer.func:start()
                            player.props.allowControls = true
                        end
                    })
                end
            })
        end)
    end,

    onUpdate = function(self)
        local player = self.props.player
        
        if (not player.props.dead) and (not self.scene.props.timer.props.finished) then
            if self.collider:overlaps(player.collider) and player.collider:hasCollided(Direction.Down) then
                local timer = self.scene.props.timer
                timer.func:stop()
                timer.props.finished = true

                self.scene.props.results.finished = true

                self.scene:createChild("EndSign", {
                    onComplete = function()
                        self.scene:createChild("FillTransition", {
                            fadeIn = 1,
                            fadeOut = 2,
                            interim = 1,
                            next = {
                                node = "CircusResults",
                                props = self.scene.props.results
                            }
                        })
                    end
                })
            end
        end
    end
})