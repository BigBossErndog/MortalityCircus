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

        self.load:tilemap("circus_map0", "tilemaps/circus_map0.tmx")
        self.load:tilemap("circus_map1", "tilemaps/circus_map1.tmx")
        self.load:tilemap("circus_map2", "tilemaps/circus_map2.tmx")
        self.load:tilemap("circus_map3", "tilemaps/circus_map3.tmx")

        self.load:image("circus_bg", "bg/circus_bg.png")
        self.load:image("newDay_bg", "bg/newDay_bg.png")
        self.load:image("night_bg", "bg/night_bg.png")
        self.load:image("shop_bg", "bg/shop_bg.png")
        self.load:image("familyTime_bg", "bg/familyTime_bg.png")

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
        self.load:audio("alma-espanola", "audio/alma-espanola-366582.mp3")
        self.load:audio("cort", "audio/cort_circocomica1_dm-290837.mp3")
        self.load:audio("jump", "audio/jump.wav")
        self.load:audio("spring_sound", "audio/spring.wav")
        self.load:audio("coin", "audio/coin.wav")
        self.load:audio("lose", "audio/lose.wav")
        self.load:audio("heart", "audio/heart.wav")
        self.load:audio("hurt", "audio/hurt.wav")
        self.load:audio("select", "audio/select.wav")
        self.load:audio("talk", "audio/talk.wav")
        self.load:audio("slam", "audio/slam.wav")
        self.load:audio("drop", "audio/drop.wav")
    end,
    
    onCreate = function(self)
        GameData:new()
        math.randomseed(os.time())

        local music = self.audio:createChild("AudioGroup", {
            id = "music",
            masterVolume = 0.6
        })
        music:createChild("Audio", {
            audio = "alma-espanola",
            loop = true
        })
        music:createChild("Audio", {
            audio = "cort",
            loop = true
        })

        local sfx = self.audio:createChild("AudioGroup", {
            id = "sfx",
            masterVolume = 0.8
        })
        sfx:createChild("Audio", {
            audio = "jump"
        })
        sfx:createChild("Audio", {
            id = "spring",
            audio = "spring_sound"
        })
        sfx:createChild("AudioPool", {
            audio = "coin",
            poolSize = 4
        })
        sfx:createChild("Audio", {
            audio = "coin",
            id = "coin_single"
        })
        sfx:createChild("Audio", {
            audio = "lose"
        })
        sfx:createChild("Audio", {
            audio = "heart"
        })
        sfx:createChild("Audio", {
            audio = "hurt"
        })
        sfx:createChild("Audio", {
            id = "select",
            audio = "select"
        })
        sfx:createChild("AudioPool", {
            audio = "talk",
            poolSize = 16
        })
        sfx:createChild("Audio", {
            audio = "slam"
        })
        sfx:createChild("AudioPool", {
            audio = "drop",
            poolSize = 8
        })

        self:createChild("IntroScene")
    end,

    onUpdate = function(self)
        
    end
})
