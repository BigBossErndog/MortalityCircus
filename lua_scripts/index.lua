Nodes:load("ui/Borders")

Nodes:load("sprites/Morti")

Nodes:load("scenes/GameOver")
Nodes:load("scenes/ANewDay")
Nodes:load("scenes/IntroScene")
Nodes:load("scenes/TitleScene")

GameData = {
    new = function(self)
        self.day = 0
        self.health = 3
        self.mentalHealth = 100
        self.money = 0
        self.day = 0
        self.bonusTime = 0
        self.currentMap = nil
        self.doubleJump = false
        self.rentAmount = 1000
        self.rentDay = 7
    end
}

Creator:createWorld({
    window = {
        width = 1280,
        height = 720,
        virtualWidth = 320,
        virtualHeight = 180,

        backgroundColor = Colors.Black,

        screenMode = ScreenMode.Windowed,
        
        title = "Mortality Circus"
    },

    onPreload = function(self)
        self.load:font("defaultFont", "fonts/PixelMplus10-Regular.ttf", 10)

        self.load:spritesheet("player", "sprites/player.png", 48, 48)
        self.load:spritesheet("morti", "sprites/morti.png", 112, 160)

        self.load:image("spinsaw", "sprites/spinsaw.png")
        self.load:spritesheet("spring", "sprites/spring.png", 16, 16)

        self.load:image("endPost", "sprites/endPost.png")

        self.load:spritesheet("tiles", "tilemaps/tiles.png", 16, 16)
        self.load:tilemap("test", "tilemaps/test.tmx")

        self.load:tilemap("circus_map1", "tilemaps/circus_map1.tmx")
        self.load:tilemap("circus_map2", "tilemaps/circus_map2.tmx")

        self.load:image("circus_bg", "bg/circus_bg.png")
        self.load:image("newDay_bg", "bg/newDay_bg.png")
        self.load:image("night_bg", "bg/night_bg.png")
        self.load:image("shop_bg", "bg/shop_bg.png")

        self.load:spritesheet("shop_items", "sprites/shop_items.png", 48, 48)

        self.load:image("timeBoard", "sprites/timeBoard.png")
        self.load:image("endSign", "sprites/endSign.png")
        self.load:image("startSign", "sprites/startSign.png")

        self.load:spritesheet("dayIcons", "sprites/dayIcons.png", 32, 32)
        self.load:image("boardButton", "sprites/boardButton.png")

        self.load:image("gameOver_dead", "gameOver/gameOver_dead.png")
        self.load:image("gameOver_kickedOut", "gameOver/gameOver_kickedOut.png")
        self.load:image("gameOver_ranAway", "gameOver/gameOver_ranAway.png")

        self.load:image("mortality_logo", "sprites/mortality_logo.png")
    end,
    
    onCreate = function(self)
        GameData:new()
        math.randomseed(os.time())

        self:createChild("IntroScene")
    end,

    onUpdate = function(self, deltaTime)

    end
})