Nodes:define("ResultItem", "Group", {
    onConfigure = function(self, config)
        if config.name then
            self.get.name = config.name
        end
        if config.value then
            self.get.value = config.value
        end
        if config.color then
            self.get.color = config.color
        end
    end,
    
    onCreate = function(self)
        local txt
        
        txt = self:createChild("Text", {
            origin = { 0, 0.5 },
            x = -64,
            font = "defaultFont",
            text = self.get.name
        })
        if self.get.color then
            txt.color = self.get.color
        end
        self.get.nameTxt = txt

        txt = self:createChild("Text", {
            origin = { 1, 0.5 },
            x = 64,
            font = "defaultFont",
            text = "$ " .. self.get.value
        })
        if self.get.color then
            txt.color = self.get.color
        end
        self.get.valueTxt = txt
    end
})

Nodes:define("CircusResults", "Scene", {
    props = {
        total = 0,
        resultCount = 0,

        moneyCollected = 0,
        notFinish = false
    },

    createResult = function(self, name, val, color)
        local result = self:createChild("ResultItem", {
            visible = false,

            name = name,
            value = val,
            color = color
        })
        result.y = -64 + self.get.resultCount * 20

        self.get.total = self.get.total + val

        result:wait(2.5 + 1 * self.get.resultCount, function()
            self.audio:play("sfx/slam")
            result.visible = true
        end)

        self.get.resultCount = self.get.resultCount + 1
    end,

    onCreate = function(self)
        self:createChild("Sprite", {
            texture = "night_bg"
        })

        if GameData.currentMap == "circus_map0" then
            GameData.tutorialCompleted = true
        end

        self.func:createResult("Money Collected", self.get.moneyCollected)
        
        if self.get.heartsLeft > 0 then
            self.func:createResult("Hearts Left", self.get.heartsLeft * 25)
        end

        if self.get.finished then
            self.func:createResult("Finished", 50, Colors.Green)
        end

        if self.get.notFinish then
            self.func:createResult("Didn't Finish", -200, Colors.Red)
        end

        if self.get.total < 0 then
            self.get.total = 0
        end

        local totalResult = self:createChild("ResultItem", {
            visible = false,

            color = Colors.Yellow,

            name = "Total",
            value = self.get.total
        })

        totalResult.y = -64 + self.get.resultCount * 20 + 8

        totalResult:wait(2.5 + 1 * self.get.resultCount, function()
            self.audio:play("sfx/slam")
            totalResult.visible = true
        end)

        local oldValue = GameData.money

        GameData.money = GameData.money + self.get.total
        
        local newValue = GameData.money

        local bankAccount = self:createChild("ResultItem", {
            visible = false,

            color = Colors.Yellow,

            name = "Bank Account",
            value = oldValue
        })
        bankAccount.y = -64 + (self.get.resultCount + 1) * 20 + 8

        bankAccount:wait(2.5 + 1 * self.get.resultCount + 1, function()
            self.audio:play("sfx/slam")
            bankAccount.visible = true
            self:wait(1, function()
                bankAccount.tween:to({
                    props = {
                        value = newValue
                    },
                    duration = newValue * 0.0025,
                    onProgress = function()
                        self.audio:play("sfx/coin_single")
                        bankAccount.get.valueTxt.text = "$ " .. math.floor(bankAccount.get.value)
                    end,
                    onComplete = function()
                        self:wait(2, function()
                            if GameData.mentalHealth > 0 then
                                self:createChild("FillTransition", {
                                    next = {
                                        node = "ANewDay"
                                    },
                                    fadeIn = 2,
                                    fadeOut = 1,
                                    interim = 1
                                })
                            else
                                self:createChild("FillTransition", {
                                    next = {
                                        node = "GameOver",
                                        props = GameOvers.ranAway
                                    },
                                    fadeIn = 1.5,
                                    fadeOut = 1,
                                    interim = 1
                                })
                            end
                        end)
                    end
                })
            end)
        end)
    end
})