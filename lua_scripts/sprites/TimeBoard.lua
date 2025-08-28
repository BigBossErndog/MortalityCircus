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
            y = self.height / 2 - 2
        })

        self.y = self.scene.camera.top - self.height
        
        self.tween:to({
            y = self.scene.camera.top,
            duration = 1,
            ease = Ease.SineOut,
            onComplete = function()
                self.props.isCounting = true
            end
        })

        self.props.counter = self.props.time
        self.props.number.text = string.format("%.2f", self.props.counter)
    end,

    stop = function(self)
        self.props.stopped = true
    end,
    
    onUpdate = function(self, deltaTime)
        if self.props.isCounting and not self.props.stopped then
            self.props.counter = self.props.counter - deltaTime

            if self.props.counter <= 0 then
                self.props.counter = 0
                self.props.finished = true
                self.func:stop()
            end

            self.props.number.text = string.format("%.2f", self.props.counter)
        end
    end
})