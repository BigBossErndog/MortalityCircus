GameOvers = {
    dead = {
        image = "gameOver_dead",
        title = "A Huge Loss",
        desc = "You died while on the job, leaving your beloved family behind."
    }
}

Nodes:define("GameOver", "Scene", {
    props = {
        image = "",
        title = "",
        desc = ""
    },

    onCreate = function(self)
        self:createChild("Sprite", {
            texture = self.props.image
        })
    end,
    
    onUpdate = function(self, deltaTime)
        
    end
})

