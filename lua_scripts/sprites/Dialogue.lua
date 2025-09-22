Nodes:define("Dialogue", "Group", {
    visible = false,

    onConfigure = function(self, config)
        if config.talkSound then
            self.get.talkSound = config.talkSound
        end
    end,

    onCreate = function(self)
        self.get.backer = self:createChild("FillRect", {
            width = self.scene.camera.width,
            height = 24,
            color = Colors.Black
        })

        self.get.text = self:createChild("Text", {
            y = -1,
            font = "defaultFont",
            text = "Hello!",
            wrapMode = WrapMode.ByWord,
            wrapWidth = self.scene.camera.width - 64,
            alignment = Align.Center
        })

        self.get.text:setManipulator("evil", function(index, lifeTime, char)
            return {
                color = Colors.Red,
                offsetX = (math.random() * 2 - 1)*0.5,
                offsetY = (math.random() * 2 - 1)*0.5
            }
        end)

        self.get.progressIcon = self:createChild("Sprite", {
            texture = "tiles",
            frame = 19,
            active = false,
            origin = 1,
            props = {
                count = 0
            },
            onUpdate = function(icon, deltaTime)
                icon.x = self.get.backer.x + self.get.backer.width/2 - 4
                icon.y = self.get.backer.y + self.get.backer.height/2 - 2
                icon.get.count = icon.get.count + deltaTime
                icon.z = (math.sin(icon.get.count * 20) - 1)
            end
        })
    end,

    say = function(self, txt, onFinish)
        self.visible = true
        self.get.text.text = txt
        self.get.backer.height = self.get.text.height + 4

        self.get.text.progress = 0
        self.get.text:autoProgress({
            rate = 16,
            onComplete = function()
                if onFinish then
                    onFinish()
                end
            end,
            onCharacter = function()
                if self.get.talkSound then
                    self.audio:play(self.get.talkSound)
                end
            end,
            skipCondition = function()
                return Keyboard:justPressed(Key.Space) or self.input.mouse.left.justPressed
            end
        })
    end,

    waitInput = function(self, sm)
        if sm:once() then
            self.get.progressIcon.active = true
        end

        if sm:event() then
            if self.input.mouse.left.justPressed or Keyboard:justPressed(Key.Space) then
                sm:nextEvent()
                self.get.progressIcon.active = false
                self.audio:play("sfx/select")
            end
        end
    end
})