Nodes:load("ui/Borders")

Nodes:load("sprites/Morti")

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

        self.load:image("spinsaw", "sprites/spinsaw.png")
        self.load:spritesheet("spring", "sprites/spring.png", 16, 16)

        self.load:spritesheet("tiles", "tilemaps/tiles.png", 16, 16)
        self.load:tilemap("test", "tilemaps/test.tmx")

        self.load:image("circus_bg", "bg/circus_bg.png")
    end,
    
    onCreate = function(self)
        self:createChild("Circus")
    end,

    onUpdate = function(self, deltaTime)

    end
})