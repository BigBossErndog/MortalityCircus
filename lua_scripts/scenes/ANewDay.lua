Nodes:load("scenes/Circus")
Nodes:load("scenes/Shop")

Nodes:load("scenes/FamilyTime")

MapData = {
    maps = { "circus_map1", "circus_map2", "circus_map3" },
    names = {
        ["circus_map0"] = "On-The-Job Training",
        ["circus_map1"] = "Livin' Da High Life",
        ["circus_map2"] = "Hop Bunny Hop",
        ["circus_map3"] = "Descent Into Madness"
    },
    days = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" }
}

Nodes:define("BoardButton", "Sprite", {
    texture = "boardButton",
    scale = 0,

    props = {
        icon = 0,
        selected = false
    },

    input = {
        active = true,
        cursor = Cursor.Pointer,
        onPointerDown = function(self)
            self.audio:play("sfx/select")
            
            self.input:deactivate()
            self.get.txt.visible = false
            self.get.selected = true

            if self.func.onPress then
                self.func:onPress()
            end

            self.tween:to({
                scale = 0.8,
                duration = 0.15,
                ease = Ease.BackIn,
                yoyo = true
            })
        end
    },

    cropTop = 2,
    cropBottom = 2,
    cropLeft = 2,
    cropRight = 2,

    onConfigure = function(self, config)
        if config.icon then
            self.get.icon = config.icon
        end
        if config.text then
            self.get.text = config.text
        end
    end,

    onCreate = function(self)
        self.get.icon = self:createChild("Sprite", {
            texture = "dayIcons",
            frame = self.get.icon
        })
        self.tween:to({
            scale = 1,
            duration = 0.3,
            ease = Ease.BackOut
        })

        self.get.txt = self:createChild("Text", {
            y = -32,
            font = "defaultFont",
            text = self.get.text
        })
    end,

    onUpdate = function(self)
        self.get.txt.visible = self.input.hovered
    end
})

Nodes:define("DayBoard", "Sprite", {
    texture = "timeBoard",
    origin = { 0.5, 0 },
    fixedToCamera = true,

    onCreate = function(self)
        self.get.txt = self:createChild("Text", {
            font = "defaultFont",
            x = 1,
            y = self.height / 2 - 2,
            text = MapData.days[((GameData.day - 1) % 7) + 1] .. "\n" .. GameData.day,
            alignment = Align.Center
        })

        self.y = self.world.top - self.height
        
        self.tween:to({
            y = self.world.top,
            duration = 1,
            ease = Ease.SineOut
        })
    end
})

Nodes:define("ANewDay", "Scene", {
    onCreate = function(self)
        GameData.day = GameData.day + 1

        self:createChild("Sprite", {
            texture = "newDay_bg"
        })

        local healthBar = self:createChild("HealthBar", {
            depth = 100,
            health = GameData.health,
            x = self.camera.left + 16,
            y = self.camera.top + 16
        })
        self.get.healthBar = healthBar

        self.get.mentalMeter = self:createChild("MentalMeter", {
            depth = 100
        })

        if GameData.day == GameData.rentDay then
            self.func:payRent()
        else
            self.func:startDay()
        end
    end,

    payRent = function(self)
        local rentStuff = self:createChild("Group")

        local txt = rentStuff:createChild("Text", {
            font = "defaultFont",
            text = "It's time to pay rent.",
            y = self.world.top + 22,
            progress = 0,
            visible = false
        })
        
        self:wait(1, function()
            txt.visible = true
            txt:autoProgress({
                rate = 24,
                onComplete = function()
                    self:wait(1, function()
                        self.audio:play("sfx/slam")
                        local txt = rentStuff:createChild("Text", {
                            font = "defaultFont",
                            text = "Rent: $ " .. GameData.rentAmount,
                            y = self.world.top + 40
                        })

                        self:wait(1, function()
                            self.audio:play("sfx/slam")
                            local txt = rentStuff:createChild("Text", {
                                props = {
                                    displayValue = GameData.money
                                },
                                font = "defaultFont",
                                text = "Bank Account: $ " .. GameData.money,
                                y = self.world.top + 54,
                                color = Colors.Yellow
                            })

                            self:wait(2, function()
                                if GameData.money >= GameData.rentAmount then
                                    txt.tween:to({
                                        props = {
                                            displayValue = GameData.money - GameData.rentAmount
                                        },
                                        duration = 2,
                                        rate = 24,
                                        onProgress = function(t)
                                            self.audio:play("sfx/coin_single")
                                            t.text = "Bank Account: $ " .. math.floor(t.props.displayValue)
                                        end,
                                        onComplete = function()
                                            GameData.money = GameData.money - GameData.rentAmount
                                            self:wait(1, function()
                                                rentStuff.tween:to({
                                                    alpha = 0,
                                                    duration = 1,
                                                    onComplete = function()
                                                        rentStuff:destroy()
                                                        self:wait(0.5, function()
                                                            GameData.rentDay = GameData.rentDay + 7
                                                            GameData.rentAmount = math.round(GameData.rentAmount * 1.2)
                                                            self.func:startDay()
                                                        end)
                                                    end
                                                })
                                            end)
                                        end
                                    })
                                else
                                    local txt = rentStuff:createChild("Text", {
                                        font = "defaultFont",
                                        text = "Not enough money...",
                                        y = self.world.top + 70,
                                        color = Colors.Red
                                    })
                                    
                                    self:wait(2, function()
                                        self.audio:getChild("music").tween:to({
                                            volume = 0,
                                            duration = 2,
                                            onComplete = function(music)
                                                music:stop()
                                                music.volume = 1
                                            end
                                        })

                                        self:createChild("FillTransition", {
                                            next = {
                                                node = "GameOver",
                                                props = GameOvers.kickedOut
                                            },
                                            fadeIn = 2,
                                            fadeOut = 1,
                                            interim = 1
                                        })
                                    end)
                                end
                            end)

                        end)

                    end)
                end,
                skipCondition = function()
                    return Keyboard:justPressed(Key.Space) or self.input.mouse.left.justPressed
                end
            })
        end)
    end,

    startDay = function(self)
        local allowedMaps = {}

        self.audio:play("music/cort")

        if GameData.tutorialCompleted then
            for i, v in ipairs(MapData.maps) do
                if v ~= GameData.currentMap then
                    table.insert(allowedMaps, v)
                end
            end

            GameData.currentMap = allowedMaps[math.random(#allowedMaps)]
        else
            GameData.currentMap = "circus_map0"
        end

        local txt = self:createChild("Text", {
            font = "defaultFont",
            text = "It's a new day... What will you do?",
            y = self.world.top + 40,
            progress = 0,
            visible = false
        })
        self:wait(1, function()
            txt.visible = true
            txt:autoProgress({
                rate = 24,
                onComplete = function()
                    self:wait(0.5, function()
                        self.func:createButtons()
                    end)
                end,
                skipCondition = function()
                    return Keyboard:justPressed(Key.Space) or self.input.mouse.left.justPressed
                end
            })
        end)

        self:createChild("DayBoard")
    end,

    hideButtons = function(self)
        for k, v in pairs(self.get.buttons) do
            v.input:deactivate()
            if not v.props.selected then
                v.visible = false
            end
        end
    end,

    createButtons = function(self)
        self.get.buttons = {}
        
        local button1 = self:createChild("BoardButton", {
            x = -64,
            y = 4,
            icon = 1,
            text = "Go To Work",
            onPress = function()
                self.func:hideButtons()
                self:wait(0.8, function()
                    self.audio:getChild("music").tween:to({
                        volume = 0,
                        duration = 2,
                        onComplete = function(music)
                            music:stop()
                            music.volume = 1
                        end
                    })
                    self.scene:createChild("FillTransition", {
                        next = {
                            node = "Circus",
                            tilemap = GameData.currentMap
                        },
                        fadeIn = 2,
                        fadeOut = 2,
                        interim = 1
                    })
                end)
            end
        })
        table.insert(self.get.buttons, button1)

        self:createChild("Text", {
            font = "defaultFont",
            y = 56,
            visible = false,
            text = "Today's Show: ${color=\"cyan\"}" .. MapData.names[GameData.currentMap] .. "${end}",
            onUpdate = function(self)
                self.visible = button1.props.txt.visible
            end
        })

        self:wait(0.15, function()
            local button = self:createChild("BoardButton", {
                icon = 2,
                y = 4,
                text = "Go Shopping",
                onPress = function()
                    self.func:hideButtons()

                    self:wait(0.8, function()
                        self.scene:createChild("FillTransition", {
                            next = {
                                node = "Shop"
                            },
                            fadeIn = 1,
                            fadeOut = 1,
                            interim = 1
                        })
                    end)
                end
            })
            table.insert(self.get.buttons, button)

            self:createChild("Text", {
                font = "defaultFont",
                y = 56,
                visible = false,
                text = "Go shopping for useful items. ${color=\"yellow\"}(Bank Account: $ " .. GameData.money .. ")${end}",
                onUpdate = function(self)
                    self.visible = button.props.txt.visible
                end
            })
        end)

        self:wait(0.3, function()
            local button = self:createChild("BoardButton", {
                x = 64,
                y = 4,
                icon = 3,
                text = "Family Time",
                onPress = function()
                    self.func:hideButtons()

                    self:wait(0.8, function()
                        self.scene:createChild("FillTransition", {
                            next = {
                                node = "FamilyTime"
                            },
                            fadeIn = 1,
                            fadeOut = 1,
                            interim = 1
                        })
                    end)
                end
            })
            table.insert(self.get.buttons, button)

            self:createChild("Text", {
                font = "defaultFont",
                y = 56,
                visible = false,
                text = "Regain Mental Health",
                onUpdate = function(self)
                    self.visible = button.props.txt.visible
                end
            })
        end)

        self:wait(0.4, function()
            self:createChild("Text", {
                font = "defaultFont",
                y = self.world.bottom - 12,
                text = "Rent: $ " .. GameData.rentAmount .. " (Due in " .. (GameData.rentDay - GameData.day) .. " days) ${color=\"yellow\"}(Have: $ " .. GameData.money .. ")${end}",
                alignment = Align.Center
            })
        end)
    end
})