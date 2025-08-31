Nodes:define("TitleScene", "Scene", {
    onCreate = function(self)
        self:createChild("Sprite", {
            texture = "newDay_bg"
        })
        local clickStart = self:createChild("Text", {
            font = "defaultFont",
            text = "Click to Start",
            y = self.world.bottom - 24,
            alignment = Align.Center,
            props = {
                flickerCounter = 0
            },
            onUpdate = function(starter, deltaTime)
                starter.props.flickerCounter = starter.props.flickerCounter + deltaTime
                if starter.props.flickerCounter >= 0.5 then
                    starter.visible = not starter.visible
                    starter.props.flickerCounter = 0
                end
                if self.input.mouse.left.justPressed or Keyboard:justPressed(Key.Space) then
                    GameData:new()
                    self.audio:play("sfx/select")
                    self.parent:createChild("ANewDay")
                    self:bringToFront()
                    self.tween:to({
                        alpha = 0,
                        duration = 1,
                        onComplete = function()
                            self:destroy()
                        end
                    })
                    starter.active = false
                end
            end,
            active = false
        })

        self:wait(1, function()
            self.audio:play("music/cort")
            self:createChild("Sprite", {
                texture = "mortality_logo",
                y = -40,
                alpha = 0,
                onCreate = function(self)
                    self.tween:to({
                        alpha = 1,
                        duration = 1,
                        onComplete = function()
                            local rect = self:createChild("FillRect", {
                                width = self.scene.camera.width + 16,
                                color = Colors.Black,
                                alpha = 0,
                                y = 64
                            })
                            self:createChild("Text", {
                                font = "defaultFont",
                                text = "Made by Ernest Placido in 7 days for the Brackeys Game Jam 2025.2.",
                                y = 64,
                                color = "#a8dfff",
                                wrapMode = WrapMode.ByWord,
                                wrapWidth = self.scene.camera.width - 96,
                                alignment = Align.Center,
                                alpha = 0,
                                onCreate = function(txt)
                                    rect.height = txt.height + 4
                                end
                            }).tween:to({
                                alpha = 1,
                                duration = 1,
                                onProgress = function(txt)
                                    rect.alpha = txt.alpha
                                end,
                                onComplete = function()
                                    clickStart.active = true
                                end
                            })
                        end
                    })
                end
            })
        end)
    end
})