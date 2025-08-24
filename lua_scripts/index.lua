-- Welcome to your new world

Creator:createWorld({
    window = {
        width = 1280,
        height = 800,
        virtualWidth = 320,
        virtualHeight = 180,

        backgroundColor = "#294d6a",

        screenMode = ScreenMode.Windowed,
        
        title = "Mortality Circus"
    },

    onPreload = function(self)
        self.load:font("defaultFont", "fonts/PixelMplus10-Regular.ttf", 10)
    end,
    
    onCreate = function(self)
        self:createChild("Text", {
            font = "defaultFont",
            text = "Hello World!"
        })
    end,

    onUpdate = function(self, deltaTime)

    end
})