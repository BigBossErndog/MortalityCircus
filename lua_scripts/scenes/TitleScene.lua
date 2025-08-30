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
            self:createChild("Sprite", {
                texture = "mortality_logo",
                y = -32,
                alpha = 0,
                onCreate = function(self)
                    self.tween:to({
                        alpha = 1,
                        duration = 1,
                        onComplete = function()
                            clickStart.active = true
                        end
                    })
                end
            })
        end)
    end
})