Nodes:load("sprites/Dialogue")

Nodes:define("IntroScene", "Scene", {
    onCreate = function(self)
        self.get.sm = self:createChild("StateMachine")

        self.get.morti = self:createChild("Morti")

        self.get.overlay = self:createChild("FillRect", {
            color = Colors.Black
        })
        self.get.overlay.rect = self.camera.rect
        self.get.overlay.tween:to({
            alpha = 0,
            duration = 2
        })

        self.get.dialogue = self:createChild("Dialogue", {
            y = self.scene.camera.bottom - 48,
            talkSound = "sfx/talk",
            onNext = function()
                self.get.sm:nextEvt()
            end
        })
    end,

    onUpdate = function(self)
        self.get.sm:start()

        self.get.sm:wait(2)
        self.func:say("Ah, our new freelance clown!", "talk", "smile")
        self.func:say("I'm ${yellow}Morti${end}, and welcome to ${yellow}Morti's Circus${end}!", "talk", "smile")
        self.func:say("Here, we perform death-defying stunts for the amusement of all!", "talk", "smile")
        self.func:say("But never fear! We care for all our beloved clowns!", "talk", "smile")
        self.func:say("You may work whenever you want, on your own schedule.\nNot feeling it? Take the day off!", "talk", "smile")
        self.func:say("But hey, I hear ya got a family.", "talk", "smile")
        self.func:say("So you better work hard for their sake!\n${evil}HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHA${end}", "laugh")

        if self.get.sm:once() then
            self.get.dialogue.visible = false
            self.scene:createChild("FillTransition", {
                next = "TitleScene",
                fadeIn = 4,
                fadeOut = 2,
                interim = 1
            })
        end
    end,

    say = function(self, txt, mortiAnim, mortiEndAnim)
        if self.get.sm:once() then
            if mortiAnim then
                self.get.morti.animation = mortiAnim
            end
            self.get.dialogue.func:say(txt, function()
                if mortiEndAnim then
                    self.get.morti.animation = mortiEndAnim
                end
                self.get.sm:nextEvent()
            end)
        end
        self.get.sm:event()
        self.get.dialogue.func:waitInput(self.get.sm)
    end
})