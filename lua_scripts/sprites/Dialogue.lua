Nodes:define("Dialogue", "Group", {
    visible = false,

    onCreate = function(self)
        self.props.backer = self:createChild("FillRect", {
            width = self.scene.camera.width,
            height = 24,
            color = Colors.Black
        })

        self.props.text = self:createChild("Text", {
            y = -1,
            font = "defaultFont",
            text = "Hello!",
            wrapMode = WrapMode.ByWord,
            wrapWidth = self.scene.camera.width - 64,
            alignment = Align.Center
        })

        self.props.progressIcon = self:createChild("Sprite", {
            texture = "tiles",
            frame = 19,
            active = false,
            origin = 1,
            props = {
                count = 0
            },
            onUpdate = function(icon, deltaTime)
                icon.x = self.props.backer.x + self.props.backer.width/2 - 4
                icon.y = self.props.backer.y + self.props.backer.height/2 - 2
                icon.props.count = icon.props.count + deltaTime
                icon.z = (math.sin(icon.props.count * 20) - 1)
            end
        })
    end,

    say = function(self, txt, onFinish)
        self.visible = true
        self.props.text.text = txt
        self.props.backer.height = self.props.text.height + 4

        self.props.text.progress = 0
        self.props.text:autoProgress({
            rate = 16,
            onComplete = function()
                if onFinish then
                    onFinish()
                end
            end,
            skipCondition = function()
                return Keyboard:justPressed(Key.Space) or self.input.mouse.left.justPressed
            end
        })
    end,

    waitInput = function(self, sm)
        if sm:once() then
            self.props.progressIcon.active = true
        end

        if sm:event() then
            if self.input.mouse.left.justPressed or Keyboard:isDown(Key.Space) then
                sm:nextEvent()
                self.props.progressIcon.active = false
            end
        end
    end
})