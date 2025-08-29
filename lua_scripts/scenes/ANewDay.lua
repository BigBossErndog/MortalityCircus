Nodes:define("BoardButton", "Sprite", {
    texture = "boardButton",
    scale = 0,

    props = {
        icon = 0
    },

    input = {
        active = true,
        cursor = Cursor.Pointer,
        onPointerDown = function(self)
            self.input:deactivate()
            self.props.txt.visible = false

            self.tween:to({
                scale = 0,
                duration = 0.3,
                ease = Ease.BackIn,
                onComplete = function()
                    if self.func.onPress then
                        self.func:onPress()
                    end
                end
            })
        end
    },

    cropTop = 2,
    cropBottom = 2,
    cropLeft = 2,
    cropRight = 2,

    onConfigure = function(self, config)
        if config.icon then
            self.props.icon = config.icon
        end
        if config.text then
            self.props.text = config.text
        end
    end,

    onCreate = function(self)
        self.props.icon = self:createChild("Sprite", {
            texture = "dayIcons",
            frame = self.props.icon
        })
        self.tween:to({
            scale = 1,
            duration = 0.3,
            ease = Ease.BackOut
        })

        self.props.txt = self:createChild("Text", {
            y = -32,
            font = "defaultFont",
            text = self.props.text
        })
    end,

    onUpdate = function(self)
        self.props.txt.visible = self.input.hovered
    end
})

Nodes:define("ANewDay", "Scene", {
    onCreate = function(self)
        self.props.maps = { "circus_map1", "circus_map2" }

        local allowedMaps = {}
        for i, v in ipairs(self.props.maps) do
            if v ~= GameData.currentMap then
                table.insert(allowedMaps, v)
            end
        end

        GameData.currentMap = allowedMaps[math.random(#allowedMaps)]

        self:createChild("Sprite", {
            texture = "newDay_bg"
        })

        local txt = self:createChild("Text", {
            font = "defaultFont",
            text = "It's a new day... What will you do?",
            y = self.world.top + 32,
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
                end
            })
        end)
    end,

    hideButtons = function(self)
        for k, v in pairs(self.props.buttons) do
            v.input:deactivate()
        end
    end,

    createButtons = function(self)
        self.props.buttons = {}

        local button
        
        button = self:createChild("BoardButton", {
            x = -64,
            icon = 1,
            text = "Go To Work",
            onPress = function()
                self.func:hideButtons()
                self.scene:createChild("FillTransition", {
                    next = {
                        node = "Circus",
                        tilemap = GameData.currentMap
                    },
                    fadeIn = 2,
                    fadeOut = 2,
                    interim = 1
                })
            end
        })
        table.insert(self.props.buttons, button)

        self:wait(0.25, function()
            button = self:createChild("BoardButton", {
                icon = 2,
                text = "Go Shopping",
                onPress = function()
                    self.func:hideButtons()
                end
            })
            table.insert(self.props.buttons, button)
        end)

        self:wait(0.5, function()
            button = self:createChild("BoardButton", {
                x = 64,
                icon = 3,
                text = "Family Time",
                onPress = function()
                    self.func:hideButtons()
                end
            })
            table.insert(self.props.buttons, button)
        end)
    end
})