Nodes:load("sprites/Dialogue")

Nodes:define("IntroScene", "Scene", {
    onCreate = function(self)
        self.props.sm = self:createChild("StateMachine")

        self.props.morti = self:createChild("Morti")

        self.props.overlay = self:createChild("FillRect", {
            color = Colors.Black
        })
        self.props.overlay.rect = self.camera.rect
        self.props.overlay.tween:to({
            alpha = 0,
            duration = 2
        })

        self.props.dialogue = self:createChild("Dialogue", {
            onNext = function()
                self.props.sm:nextEvt()
            end
        })
    end,

    onUpdate = function(self)
        self.props.sm:start()

        self.props.sm:wait(2)
        self.func:say("Ah, our new freelance clown!", "talk", "smile")
        self.func:say("I'm Morti, and welcome to Morti's Circus!", "talk", "smile")
        self.func:say("Here, we perform death-defying stunts for the amusement of all!", "talk", "smile")
        self.func:say("But never fear! We care for all our beloved clowns!", "talk", "smile")
        self.func:say("You may work whenever you want, on your own schedule.\nNot feeling it? Take the day off!", "talk", "smile")
        self.func:say("But hey, I hear ya got a family.", "talk", "smile")
        self.func:say("So you better work hard for their sake!\nHAHAHAHAHAHAHAHAHAHAHA", "laugh")

        if self.props.sm:once() then
            self.props.dialogue.visible = false
            self.scene:createChild("FillTransition", {
                next = "TitleScene",
                fadeIn = 5,
                fadeOut = 2,
                interim = 1
            })
        end
    end,

    say = function(self, txt, mortiAnim, mortiEndAnim)
        if self.props.sm:once() then
            if mortiAnim then
                self.props.morti.animation = mortiAnim
            end
            self.props.dialogue.func:say(txt, function()
                if mortiEndAnim then
                    self.props.morti.animation = mortiEndAnim
                end
                self.props.sm:nextEvent()
            end)
        end
        self.props.sm:event()
        if self.props.sm:event() then
            if self.input.mouse.left.justPressed or Keyboard:isDown(Key.Space) then
                self.props.sm:nextEvent()
            end
        end
    end
})