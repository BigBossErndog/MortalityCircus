GameOvers = {
    dead = {
        image = "gameOver_dead",
        title = "A Huge Loss",
        desc = "You died while on the job, leaving your beloved family behind."
    },
    gameOver_kickedOut = {
        image = "gameOver_kickedOut",
        title = "Onto The Streets",
        desc = "Unable to make rent, you and your family were made to."
    },
    gameOver_ranAway = {
        image = "gameOver_ranAway",
        title = "Life Abandoned",
        desc = "Unable to take the pressure, you fled"
    }
}

Nodes:define("GameOver", "Scene", {
    props = {
        image = "",
        title = "",
        desc = ""
    },

    onCreate = function(self)
        self:createChild("Sprite", {
            texture = self.props.image
        })

        local titleTxt = self:createChild("Text", {
            text = self.props.title,
            font = "defaultFont",
            y = 38,
            progress = 0
        })

        local descTxt = self:createChild("Text", {
            text = self.props.desc,
            font = "defaultFont",
            y = titleTxt.y + 22,
            wrapMode = WrapMode.ByWord,
            wrapWidth = self.camera.width - 96,
            alignment = Align.Center,
            progress = 0
        })
        self:wait(2, function()
            titleTxt:autoProgress({
                rate = 10,
                onComplete = function()
                    self:wait(0.5, function()
                        descTxt:autoProgress({
                            rate = 10,
                            onComplete = function()
                                self:wait(2, function()
                                    self:createChild("FillTransition", {
                                        fadeIn = 2,
                                        fadeOut = 1,
                                        interim = 1,
                                        next = "Circus"
                                    })
                                end)
                            end
                        })
                    end)
                end
            })
        end)
    end,
    
    onUpdate = function(self, deltaTime)
        
    end
})

