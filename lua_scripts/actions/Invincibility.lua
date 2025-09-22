Nodes:define("Invincibility", "RepeatAction", {
    interim = 0.1,

    props = {
        time = 1
    },

    onCreate = function(self)
        self.parent.get.invincible = true
    end,

    onAct = function(actor, self, deltaTime)
        actor.visible = not actor.visible

        if actor.visible and (self.lifeTime >= self.get.time) then
            self:complete()
        end
    end,

    onComplete = function(actor, self)
        self.parent.get.invincible = false
    end
})