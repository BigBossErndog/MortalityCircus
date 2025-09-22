Nodes:define("CameraTarget", "Node", {
    onConfigure = function(self, config)
        if config.player then
            self.get.player = config.player
        end
    end,

    onCreate = function(self)
        self.func:updatePosition()
    end,

    startFollow = function(self)
        self.scene.camera:focusOn(self)
        self.scene.camera:startFollow(self, 0.99)
    end,
    
    updatePosition = function(self)
        if Controls:isDown("down") and self.get.player.collider:hasCollided(Direction.Down) then
            self.x = self.get.player.x
            self.y = self.get.player.y + 48
        else
            self.x = self.get.player.x
            self.y = self.get.player.y
        end
    end,

    onUpdate = function(self)
        self.func:updatePosition()
    end
})