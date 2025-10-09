Nodes:define("HealthBar", "Group", {
    fixedToCamera = true,

    props = {
        health = 3,
        hearts = {}
    },

    onConfigure = function(self, config)
        if config.health then
            self.get.health = config.health
        end
    end,
    
    onCreate = function(self)
        local setHealth = self.get.health
        for i = 1, setHealth do
            self.func:addHeart(i, setHealth)
        end
    end,

    addHeart = function(self, setHealth)
        if setHealth then
            self.get.health = setHealth
        else
            if self.get.health < 5 then
                self.get.health = self.get.health + 1
            else
                return false
            end
        end
        
        local heart = self:createChild("Sprite", {
            texture = "tiles",
            frame = 8,
            x = (self.get.health - 1) * 16
        })
        self.get.hearts[self.get.health] = heart

        if not setHealth then
            heart.tween:to({
                tint = Colors.Red,
                duration = 0.5
            })
        else
            heart.tint = Colors.Red
        end

        return true
    end,

    recHealth = function(self)
        GameData.health = self.get.health
    end,

    hurt = function(self)
        if self.get.health <= 0 then
            return true
        end

        local heart = self.get.hearts[self.get.health]
        heart.tween:to({
            y = heart.y + 8,
            alpha = 0,
            duration = 0.5,
            ease = Ease.ElasticIn,
            onComplete = function()
                heart:destroy()
            end
        })


        self.get.health = self.get.health - 1

        return self.get.health <= 0
    end,

    killAll = function(self)
        while self.get.health > 0 do
            self.func:hurt()
        end
    end
})