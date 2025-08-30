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

        self.props.num = self:createChild("Text", {
            x = -12,
            origin = { 1, 0.5 },
            font = "defaultFont",
            color = "#a8dfff"
        })
        self.func:showValue(GameData.mentalHealth)
    end,

    showValue = function(self, value)
        if value <= 0 then
            value = 0
            self.props.num.color = Colors.Red
        else
            self.props.num.color = "#a8dfff"
            if value > 100 then
                value = 100
            end
        end
        self.props.displayValue = value
        self.props.num.text = tostring(math.ceil(value))
    end,

    changeValue = function(self, value)
        GameData.mentalHealth = GameData.mentalHealth + value
        if GameData.mentalHealth < 0 then
            GameData.mentalHealth = 0
        end
        if GameData.mentalHealth > 100 then
            GameData.mentalHealth = 100
        end
        
        self.tween:to({
            props = {
                displayValue = GameData.mentalHealth
            },
            duration = math.abs(value) * 0.01,
            onProgress = function()
                self.func:showValue(self.props.displayValue)
            end
        })
    end
})