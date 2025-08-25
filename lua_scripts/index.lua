Nodes:load("ui/Borders")

Nodes:load("sprites/Morti")
Nodes:load("sprites/Player")

Nodes:load("scenes/Circus")

Creator:createWorld({
    window = {
        width = 1280,
        height = 720,
        virtualWidth = 320,
        virtualHeight = 180,
        
        backgroundColor = "#294d6a",

        screenMode = ScreenMode.Windowed,
        
        title = "Mortality Circus"
    },

    onPreload = function(self)
        self.load:font("defaultFont", "fonts/PixelMplus10-Regular.ttf", 10)

        self.load:spritesheet("player", "sprites/player.png", 48, 48)
        self.load:spritesheet("morti", "sprites/morti.png", 112, 160)
    end,
    
    onCreate = function(self)
        -- self:createChild("Borders", {
        --     depth = 100
        -- })
        -- self:createChild("Morti", {
        --     y = 16
        -- })
        self:createChild("Circus")
    end,

    onUpdate = function(self, deltaTime)

    end
})