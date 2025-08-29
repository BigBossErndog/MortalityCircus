Nodes:define("HealthBar", "Group", {
    fixedToCamera = true,

    props = {
        health = 3,
        hearts = {}
    },
    
    onCreate = function(self)
        local setHealth = self.props.health
        for i = 1, setHealth do
            self:wait(0.2 * i, function()
                self.func:addHeart(i)
            end)
        end
    end,

    addHeart = function(self, setHealth)
        if setHealth then
            self.props.health = setHealth
        else
            if self.props.health < 5 then
                self.props.health = self.props.health + 1
            else
                return false
            end
        end
        
        local heart = self:createChild("Sprite", {
            texture = "tiles",
            frame = 8,
            x = (self.props.health - 1) * 16
        })
        self.props.hearts[self.props.health] = heart

        heart.tween:to({
            tint = Colors.Red,
            duration = 0.5
        })

        return true
    end,

    hurt = function(self)
        if self.props.health <= 0 then
            return true
        end

        local heart = self.props.hearts[self.props.health]
        heart.tween:to({
            y = heart.y + 8,
            alpha = 0,
            duration = 0.5,
            ease = Ease.ElasticIn,
            onComplete = function()
                heart:destroy()
            end
        })


        self.props.health = self.props.health - 1

        return self.props.health <= 0
    end,

    killAll = function(self)
        while self.props.health > 0 do
            self.func:hurt()
        end
    end
})