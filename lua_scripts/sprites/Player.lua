Nodes:define("Player", "Sprite", {
    texture = "player",

    props = {
        jumping = 0
    },

    onPreload = function(self)
        self.animations:add({
            key = "idle",
            texture = "player",
            startFrame = 1,
            endFrame = 4,
            frameRate = 6,
            loop = true
        })
        self.animations:add({
            key = "run",
            texture = "player",
            startFrame = 5,
            endFrame = 12,
            frameRate = 15,
            loop = true
        })
        self.animations:add({
            key = "jumping",
            texture = "player",
            startFrame = 13,
            endFrame = 15,
            frameRate = 12,
            loop = false
        })
        self.animations:add({
            key = "falling",
            texture = "player",
            startFrame = 16,
            endFrame = 18,
            frameRate = 12,
            loop = false
        })
        self.animations:add({
            key = "dead",
            texture = "player",
            frame = 19
        })
    end,

    onCreate = function(self)
        self.animation = "idle"
        
        -- Controls:scheme(key) gets an existing scheme, or creates a new one.
        local leftControl = Controls:scheme("left")
        leftControl.keys = { Key.A, Key.Left }

        local rightControl = Controls:scheme("right")
        rightControl.keys = { Key.D, Key.Right }

        local upControl = Controls:scheme("up")
        upControl.keys = { Key.W, Key.Up, Key.Space }
    end,

    collider = {
        shape = Rectangle.new(-10, -18, 20, 34),
        acceleration = { 0, 800 },
        damping = { 0.995, 0 }
    },

    onUpdate = function(self)
        if not self.props.dead then
            local anim = nil
            
            if self.collider:hasCollided(Direction.Down) then
                anim = "idle"
                self.collider.damping.x = 0.995
                self.props.jumping = 0
                if Controls:isDown("up") then
                    self.collider.velocity.y = -300
                    self.props.jumping = 1
                    anim = "jumping"
                end
            elseif self.props.jumping ~= 2 then
                self.props.jumping = 1
            end

            local control = 0 -- for controlling left/right movement. Prevent moving if left and right are both pressed.

            if Controls:isDown("left") then
                control = control - 120
            end
            if Controls:isDown("right") then
                control = control + 120
            end

            if control ~= 0 then
                if control < 0 then
                    self.scale.x = -1
                end
                if control > 0 then
                    self.scale.x = 1
                end
                if self.props.jumping == 0 then
                    anim = "run"
                end
            end

            if self.props.jumping == 1 then
                if self.collider.velocity.y > 0 and self.props.jumping == 1 then
                    self.props.jumping = 2
                    anim = "falling"
                end
            end

            if control ~= 0 then
                self.collider.velocity.x = control
            end

            if anim then
                self.animation = anim
            end
        else
            self.rotation = self.rotation + self.collider.velocity.x * 0.005
        end
    end,

    die = function(self, config)
        self.props.dead = true
        self.animation = "dead"
        self.collider.targets = nil

        self:bringToFront()

        self.collider.velocity.y = -300
        self.collider.damping.x = 0

        if config then
            if config.epicenter then
                self.collider.velocity.x = (self.x - config.epicenter.x) * 1.5
            end
        end

        self.scene.camera:stopFollow()
    end
})