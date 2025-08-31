Nodes:define("Invincibility", "PeriodicAction", {
    period = 0.1,

    props = {
        time = 1
    },

    onCreate = function(self)
        self.parent.props.invincible = true
    end,

    onAct = function(actor, self, deltaTime)
        actor.visible = not actor.visible

        if actor.visible and (self.lifeTime >= self.props.time) then
            self:complete()
        end
    end,

    onComplete = function(actor, self)
        self.parent.props.invincible = false
    end
})