Nodes:define("Borders", "Group", {
    onCreate = function(self)
        self:createChild("FillRect", {
            color = Colors.Black,
            origin = 0,
            x = self.world.left, y = self.world.top,
            width = self.world.width, height = 32,
        })

        self:createChild("FillRect", {
            color = Colors.Black,
            origin = { 0, 1 },
            x = self.world.left, y = self.world.bottom,
            width = self.world.width, height = 32,
        })
    end
})