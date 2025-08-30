Nodes:define("Dialogue", "Group", {
    visible = false,

    onCreate = function(self)
        self.props.backer = self:createChild("FillRect", {
            width = self.scene.camera.width,
            height = 24,
            color = Colors.Black
        })

        self.y = self.scene.camera.bottom - 48

        self.props.text = self:createChild("Text", {
            y = -1,
            font = "defaultFont",
            text = "Hello!",
            wrapMode = WrapMode.ByWord,
            wrapWidth = self.scene.camera.width - 64,
            alignment = Align.Center
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
    end
})