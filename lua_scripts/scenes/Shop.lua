ShopData = {
    painkillers = {
        name = "Pain Killers",
        desc = "Gain an extra heart.",
        cost = 250,
        icon = 1
    },
    antidepressants = {
        name = "Antidepressants",
        desc = "Gain 15 mental health.",
        cost = 200,
        icon = 2
    },
    caffeine = {
        name = "Caffeine Pills",
        desc = "Gain 10 seconds on timer on your next show.",
        cost = 150,
        icon = 3
    },
    newKicks = {
        name = "New Kicks",
        desc = "Unlocks double jump.",
        cost = 1000,
        icon = 4
    },
    exit = {
        name = "Exit",
        icon = 5
    }
}

Nodes:define("MoneyText", "Text", {
    font = "defaultFont",
    origin = 0,
    color = Colors.Yellow,

    props = {
        displayValue = 0
    },

    onCreate = function(self)
        self.func:showValue(GameData.money)
    end,

    showValue = function(self, value)
        self.text = "$ " .. math.round(value)
        self.props.displayValue = value
    end,

    changeValue = function(self, value)
        GameData.money = GameData.money + value
        self.tween:to({
            props = {
                displayValue = GameData.money
            },
            duration = math.abs(value) * 0.001,
            onProgress = function()
                self.func:showValue(self.props.displayValue)
            end
        })
    end
})


Nodes:define("Shop", "Scene", {

    props = {
        numItems = 0,
        startX = -96
    },

    onCreate = function(self)
        self:createChild("Sprite", {
            texture = "shop_bg"
        })

        local healthBar = self:createChild("HealthBar", {
            depth = 100,
            health = GameData.health,
            x = self.camera.left + 16,
            y = self.camera.top + 16
        })
        self.props.healthBar = healthBar

        self.props.mentalMeter = self:createChild("MentalMeter", {
            depth = 100
        })

        self.props.moneyText = self:createChild("MoneyText", {
            depth = 100,
            x = self.camera.left + 10,
            y = self.camera.top + 25
        })

        self.props.itemDesc = self:createChild("Text", {
            font = "defaultFont",
            visible = false,
            y = -36,
            alignment = Align.Center,
            wrapMode = WrapMode.ByWord,
            wrapWidth = self.scene.camera.width - 64,
            show = function(self, txt)
                self.text = txt
                self.visible = true
                self.props.shown = true
            end,
            onUpdate = function(self)
                if self.props.shown then
                    self.visible = true
                    self.props.shown = false
                else
                    self.visible = false
                end
            end
        })

        self.props.notif = self:createChild("Text", {
            font = "defaultFont",
            text = "Not Enough Money",
            color = Colors.Red,
            alpha = 0,
            depth = 100,
            y = self.camera.bottom - 24,
            props = {
                showTime = 0
            },
            show = function(self)
                self.props.showTime = 1
                self.alpha = 1
                self.color = Colors.Red
                self.text = "Not Enough Money"
            end,
            onUpdate = function(self,deltaTime)
                if self.props.showTime > 0 then
                    self.props.showTime = self.props.showTime - deltaTime
                elseif self.alpha > 0 then
                    self.alpha = self.alpha - deltaTime*2
                    if self.alpha < 0 then
                        self.alpha = 0
                    end
                end
            end
        })

        self.func:createItem("painkillers", function()
            if GameData.health >= 5 then
                self.props.notif.func:show()
                self.props.notif.text = "Max Health Reached"
            elseif self.func:purchase(ShopData.painkillers.cost) then
                self.props.healthBar.func:addHeart()
                GameData.health = self.props.healthBar.props.health
            end
        end)
        self.func:createItem("antidepressants", function()
            if GameData.mentalHealth < 100 then
                if self.func:purchase(ShopData.antidepressants.cost) then
                    self.props.mentalMeter.func:changeValue(15)
                end
            else
                self.props.notif.func:show()
                self.props.notif.text = "Max Mental Health Reached"
                self.props.notif.color = "#a8ffff"
            end
        end)
        self.func:createItem("caffeine", function()
            if self.func:purchase(ShopData.caffeine.cost) then
                GameData.bonusTime = GameData.bonusTime + 10
            end
        end)
        if not GameData.doubleJump then
            self.func:createItem("newKicks", function(button)
                if self.func:purchase(ShopData.newKicks.cost) then
                    GameData.doubleJump = true
                    button.props.lbl:deactivate()
                    button:deactivate()
                end
            end)
        end
        
        local exit = self.func:createItem("exit", function()
            self:wait(0.5, function()
                self:createChild("FillTransition", {
                    next = {
                        node = "ANewDay"
                    },
                    fadeIn = 1,
                    fadeOut = 2,
                    interim = 1
                })
            end)
        end)
        exit.pos = { self.world.right - 24, self.world.bottom - 24 }
    end,

    purchase = function(self, value)
        if GameData.money >= value then
            self.props.moneyText.func:changeValue(-value)
            return true
        else
            self.props.notif.func:show()
            return false
        end
    end,

    createItem = function(self, key, onPress)
        local item = self:createChild("Sprite", {
            texture = "shop_items",
            frame = ShopData[key].icon,
            onPress = onPress,
            x = self.props.startX + self.props.numItems * 64,
            input = {
                active = true,
                cursor = Cursor.Pointer,
                whilePointerHover = function()
                    if key == "exit" then
                        self.props.itemDesc.func:show("Exit")
                    else
                        self.props.itemDesc.func:show(
                            ShopData[key].name .. ": " .. ShopData[key].desc
                        )
                    end
                end,
                onPointerDown = function(self)
                    if self.props.selected then
                        return
                    end
                    if self.func.onPress then
                        self.func:onPress()
                    end
                    self.scale = 1
                    self.props.selected = true
                    self.tween:to({
                        scale = 0.8,
                        duration = 0.15,
                        ease = Ease.BackIn,
                        yoyo = true,
                        onComplete = function()
                            self.props.selected = false
                        end
                    })
                end
            }
        })
        self.props.numItems = self.props.numItems + 1

        if ShopData[key].cost then
            local lbl = self:createChild("Text", {
                font = "defaultFont",
                text = "$ " .. ShopData[key].cost,
                x = item.x,
                y = item.y + item.height/2 + 6
            })
            item.props.lbl = lbl
        end

        return item
    end
})