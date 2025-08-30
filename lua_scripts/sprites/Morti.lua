Nodes:define("Morti", "Sprite", {
    texture = "morti",

    onPreload = function(self)
        self.animations:add({
            texture = "morti",
            key = "smile",
            frame = 1
        })

        self.animations:add({
            texture = "morti",
            key = "talk",
            frames = { 1, 2 },
            loop = true,
            frameRate = 6
        })

        self.animations:add({
            texture = "morti",
            key = "laugh",
            frames = { 3, 4 },
            frameRate = 12,
            loop = true
        })
    end
})