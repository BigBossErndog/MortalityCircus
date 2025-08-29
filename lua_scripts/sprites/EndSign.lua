Nodes:define("EndSign", "Sprite", {
    texture = "endSign",
    fixedToCamera = true,

    onConfigure = function(self, config)
        if config.onComplete then
            self.func.onComplete = config.onComplete
        end
    end,

    onCreate = function(self)
        self.x = self.world.left - self.width/2
        self.y = 32

        self.scene.props.results.heartsLeft = self.scene.props.healthBar.props.health
        
        self:bringToFront()

        self.tween:to({
            pos = 0,
            duration = 0.5,
            ease = Ease.SineOut,
            onComplete = function()
                self:wait(1, function()
                    self.tween:to({
                        x = self.world.right + self.width/2, y = -32,
                        duration = 0.5,
                        ease = Ease.SineIn,
                        onComplete = function()
                            if self.func.onComplete then
                                self.func.onComplete()
                            end
                        end
                    })
                end)
            end
        })
    end
})

Nodes:define("StartSign", "EndSign", {
    texture = "startSign",
})