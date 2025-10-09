Nodes:load("sprites/CameraTarget.lua")
Nodes:load("actions/Invincibility.lua")

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
        self.animations:add({
            key = "hurting",
            texture = "player",
            frame = 20,
        })
    end,

    onConfigure = function(self, config)
        if config.tilemap then
            self.get.tilemap = config.tilemap
        end
        if config.healthBar then
            self.get.healthBar = config.healthBar
        end
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

        local downControl = Controls:scheme("down")
        downControl.keys = { Key.S, Key.Down }
    end,

    collider = {
        shape = Rectangle.new(-10, -18, 20, 34),
        acceleration = { 0, 800 },
        damping = { 0.998, 0 }
    },

    onUpdate = function(self, deltaTime)
        if not self.get.dead then
            if not self.get.hurting then
                local anim = nil
                
                if not self.get.bounced then
                    if self.collider:hasCollided(Direction.Down) then
                        anim = "idle"
                        self.collider.damping.x = 0.998
                        self.get.jumping = 0
                        if self.func:allowControls() then
                            if Controls:isDown("up") then
                                self.collider.velocity.y = -300
                                self.get.jumping = 1
                                anim = "jumping"
                                self.audio:play("sfx/jump")
                            end
                        end
                    else
                        if GameData.doubleJump and Controls:justPressed("up") and self.get.jumping < 3 then
                            self.get.jumping = 3
                            self.collider.velocity.y = -300
                            anim = "jumping"
                            self.audio:play("sfx/jump")
                        elseif self.get.jumping == 0 then
                            self.get.jumping = 1
                        end
                    end
                else
                    self.get.bounced = false
                    if self.collider:hasCollided(Direction.Down) then
                        self.collider.damping.x = 0.998
                    end
                end

                local control = 0 -- for controlling left/right movement. Prevent moving if left and right are both pressed.

                if self.func:allowControls() then
                    if Controls:isDown("left") then
                        control = control - 120
                    end
                    if Controls:isDown("right") then
                        control = control + 120
                    end
                end

                if control ~= 0 then
                    if control < 0 then
                        self.scale.x = -1
                    end
                    if control > 0 then
                        self.scale.x = 1
                    end
                    if self.get.jumping == 0 then
                        anim = "run"
                    end
                end

                if self.get.jumping == 1 or self.get.jumping == 3 then
                    if self.collider.velocity.y > 0 and self.get.jumping == 1 then
                        self.get.jumping = (self.get.jumping == 1) and 2 or 4
                        anim = "falling"
                    end
                end
                
                if control ~= 0 then
                    self.collider.velocity.x = control
                end

                if anim then
                    self.animation = anim
                end
            end

            if (self.y > self.get.tilemap.bottom) and (not self.scene.get.timer.finished)  then
                self.func:die({
                    epicenter = {
                        x = self.x - self.collider.velocity.x * 0.02,
                        y = self.y + 32
                    }
                })
            end
        else
            self.rotation = self.rotation + self.collider.velocity.x * 0.002
        end
    end,

    hurt = function(self, config)
        if (not self.get.invincible) and (not self.get.dead) then
            if not self.get.healthBar.func:hurt() then
                if (not self.get.hurting) and config then
                    if config.epicenter then
                        self.collider.velocity.x = (self.x - config.epicenter.x) * 4
                        self.collider.velocity.y = (self.y - config.epicenter.y) * 4
                        self.get.hurting = true
                        self.animation = "hurting"
                        self.collider.damping.x = 0
                        self:wait(0.4):next(function()
                            self.get.hurting = false
                        end)
                    end
                end
                self.audio:play("sfx/hurt")
                self.scene.get.mentalMeter.func:changeValue(-10)
                local txt = self.scene.get.moneyNotif.func:show("-10")
                txt.color = "#a8ffff"
                self:createChild("Invincibility")
            else
                self.func:die(config)
            end
        end
    end,
    
    allowControls = function(self, set)
        if set ~= nil then
            self.get.controlsAllowed = set
        end
        if self.get.hurting then
           return false
        end
        if self.scene.get.timer.get.finished then
            return false
        end
        if not self.get.controlsAllowed then
            return false
        end
        return true
    end,

    die = function(self, config)
        if self.get.dead then
            return
        end
        self.get.dead = true
        self.animation = "dead"
        self.collider.targets = nil

        self:bringToFront()

        self.collider.velocity.y = -300
        self.collider.damping.x = 0

        if config then
            if config.epicenter then
                self.collider.velocity.x = (self.x - config.epicenter.x) * 5
            end
        end

        self.get.healthBar.func:killAll()

        self.scene.camera:stopFollow()

        self.scene.get.timer.func:stop()

        self.audio:stop("music")
        self.audio:play("sfx/lose")

        self:wait(1, function()
            self.scene:createChild("FillTransition", {
                next = {
                    node = "GameOver",
                    props = GameOvers.dead
                },
                fadeIn = 1,
                fadeOut = 2,
                interim = 1
            })
        end)
    end
})