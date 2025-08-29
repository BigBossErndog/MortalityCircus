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
            self.props.time = config.time
        end
    end,

    onCreate = function(self)
        self.props.number = self:createChild("Text", {
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

        self.props.counter = self.props.time
        self.props.number.text = string.format("%.2f", self.props.counter)
    end,

    stop = function(self)
        self.props.stopped = true
    end,

    start = function(self)
        self.props.isCounting = true
        self.props.number.color = Colors.White
    end,
    
    onUpdate = function(self, deltaTime)
        if self.props.isCounting and not self.props.stopped then
            self.props.counter = self.props.counter - deltaTime

            if self.props.counter <= 0 then
                self.props.counter = 0
                self.props.finished = true
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

            self.props.number.text = string.format("%.2f", self.props.counter)
        end
    end
})