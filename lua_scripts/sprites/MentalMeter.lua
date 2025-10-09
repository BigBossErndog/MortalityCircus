Nodes:define("MentalMeter", "Sprite", {
    texture = "tiles",
    frame = 18,
    fixedToCamera = true,

    props = {
        displayValue = 0
    },

    onCreate = function(self)
        self.x = self.world.right - 16
        self.y = self.world.top + 16

        self.get.num = self:createChild("Text", {
            x = -12,
            origin = { 1, 0.5 },
            font = "defaultFont",
            color = "#a8dfff"
        })
        self.func:showValue(GameData.mentalHealth)
    end,

    showValue = function(self, value, pastMax)
        if value <= 0 then
            value = 0
            self.get.num.color = Colors.Red
        else
            self.get.num.color = "#a8dfff"
        end
        self.get.displayValue = value
        self.get.num.text = tostring(math.ceil(value))
    end,

    changeValue = function(self, value, pastMax)
        if GameData.mentalHealth + value < 0 then
            value = -GameData.mentalHealth
        end

        if (GameData.mentalHealth + value) > 100 and not pastMax then
            if GameData.mentalHealth >= 100 then
                value = 0
            else
                value = 100 - GameData.mentalHealth
            end
        end

        GameData.mentalHealth = GameData.mentalHealth + value
        
        self.tween:to({
            props = {
                displayValue = GameData.mentalHealth
            },
            duration = math.abs(value) * 0.01,
            onProgress = function()
                self.func:showValue(self.get.displayValue)
            end
        })
    end
})