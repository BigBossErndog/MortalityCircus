Nodes:define("MoneyNotif", "NodePool", {
    onConfigure = function(self, config)
        if config.player then
            self.props.player = config.player
        end
    end,

    onCreate = function(self)
        for i = 1, 12 do
            self:createChild("Text", {
                font = "defaultFont",
                color = Colors.Yellow
            })
        end
    end,
    
    show = function(self, displayText)
        local txt = self:grab()

        txt.pos = { self.props.player.x, self.props.player.y - 16 }
        txt.text = displayText
        txt.color = Colors.Yellow
        txt.alpha = 1

        txt.tween:to({
            y = txt.pos.y - 8,
            duration = 0.5,
            ease = Ease.SineOut,
            onComplete = function()
                txt.tween:to({
                    alpha = 0,
                    duration = 0.5,
                    onComplete = function()
                        txt:deactivate()
                    end
                })
            end
        })

        return txt
    end
})