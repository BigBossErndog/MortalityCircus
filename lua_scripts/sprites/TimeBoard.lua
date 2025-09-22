Nodes:define("TimeBoard", "Sprite", {
    texture = "timeBoard",
    origin = { 0.5, 0 },
    fixedToCamera = true,
    
    props = {
        time = 60,
        counter = 0
    },

    onConfigure = function(self, config)
        if config.time then
            self.get.time = config.time
        end
    end,

    onCreate = function(self)
        self.get.number = self:createChild("Text", {
            font = "defaultFont",
            x = 1,
            y = self.height / 2 - 2,
            color = "#888888"
        })

        self.y = self.world.top - self.height
        
        self.tween:to({
            y = self.world.top,
            duration = 1,
            ease = Ease.SineOut
        })

        self.get.counter = self.get.time
        self.get.number.text = string.format("%.2f", self.get.counter)
    end,

    stop = function(self)
        self.get.stopped = true
    end,

    start = function(self)
        self.get.isCounting = true
        self.get.number.color = Colors.White
    end,
    
    onUpdate = function(self, deltaTime)
        if self.get.isCounting and not self.get.stopped then
            self.get.counter = self.get.counter - deltaTime

            if self.get.counter <= 0 then
                self.get.counter = 0
                self.get.finished = true
                self.func:stop()

                self.scene.props.results.notFinish = true

                self:wait(1, function()
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

                    self.tween:to({
                        y = self.world.top - self.height,
                        duration = 1,
                        ease = Ease.SineIn
                    })
                end)
            end

            self.get.number.text = string.format("%.2f", self.get.counter)
        end
    end
})