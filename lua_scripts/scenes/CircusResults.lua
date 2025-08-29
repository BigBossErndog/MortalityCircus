Nodes:define("ResultItem", "Group", {
    onConfigure = function(self, config)
        if config.name then
            self.props.name = config.name
        end
        if config.value then
            self.props.value = config.value
        end
        if config.color then
            self.props.color = config.color
        end
    end,
    
    onCreate = function(self)
        local txt
        
        txt = self:createChild("Text", {
            origin = { 0, 0.5 },
            x = -64,
            font = "defaultFont",
            text = self.props.name
        })
        if self.props.color then
            txt.color = self.props.color
        end
        self.props.nameTxt = txt

        txt = self:createChild("Text", {
            origin = { 1, 0.5 },
            x = 64,
            font = "defaultFont",
            text = "$ " .. self.props.value
        })
        if self.props.color then
            txt.color = self.props.color
        end
        self.props.valueTxt = txt
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
        result.y = -64 + self.props.resultCount * 20

        self.props.total = self.props.total + val

        result:wait(2.5 + 1 * self.props.resultCount, function()
            result.visible = true
        end)

        self.props.resultCount = self.props.resultCount + 1
    end,

    onCreate = function(self)
        self:createChild("Sprite", {
            texture = "night_bg"
        })

        self.func:createResult("Money Collected", self.props.moneyCollected)
        
        if self.props.heartsLeft > 0 then
            self.func:createResult("Hearts Left", self.props.heartsLeft * 25)
        end

        if self.props.finished then
            self.func:createResult("Finished", 50, Colors.Green)
        end

        if self.props.notFinish then
            self.func:createResult("Didn't Finish", -100, Colors.Red)
        end

        if self.props.total < 0 then
            self.props.total = 0
        end

        local totalResult = self:createChild("ResultItem", {
            visible = false,

            color = Colors.Yellow,

            name = "Total",
            value = self.props.total
        })

        totalResult.y = -64 + self.props.resultCount * 20 + 8

        totalResult:wait(2.5 + 1 * self.props.resultCount + 1, function()
            totalResult.visible = true
        end)

        local oldValue = GameData.money

        GameData.money = GameData.money + self.props.total
        
        local newValue = GameData.money

        local bankAccount = self:createChild("ResultItem", {
            visible = false,

            color = Colors.Yellow,

            name = "Bank Account",
            value = oldValue
        })
        bankAccount.y = -64 + (self.props.resultCount + 1) * 20 + 8

        bankAccount:wait(2.5 + 1 * self.props.resultCount + 2, function()
            bankAccount.visible = true
            bankAccount.tween:to({
                props = {
                    value = newValue
                },
                duration = newValue * 0.005,
                onProgress = function()
                    bankAccount.props.valueTxt.text = "$ " .. math.floor(bankAccount.props.value)
                end,
                onComplete = function()
                    self:wait(2, function()
                        self:createChild("FillTransition", {
                            next = {
                                node = "ANewDay"
                            },
                            fadeIn = 2,
                            fadeOut = 1,
                            interim = 1
                        })
                    end)
                end
            })
        end)
    end
})