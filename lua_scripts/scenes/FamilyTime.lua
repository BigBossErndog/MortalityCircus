FamilyTimeData = {
    {
        "You taught your son how to ride a bicycle.",
        "He rode straight into a tree. You both laughed about it for hours."
    },
    {
        "You took the family out to a park.",
        "A squirrel stole your wife's sandwich straight out of her hands!"
    },
    {
        "You and the family spent the day playing board games.",
        "You son attempted to cheat, but you caught him. He was very embarrassed."
    },
    {
        "You spent the day at the beach with your family.",
        "Your son built a sandcastle so big that it collapsed on him. He laughed it off."
    },
    {
        "You took your family to a local fair.",
        "Your son won a giant stuffed animal, but it was too big for him to carry. You had to help him."
    },
    {
        "You and your family went fishing at a nearby lake.",
        "Your son caught his first fish! He was so proud of himself."
    },
    {
        "You took your family to a local carnival.",
        "Your son rode in a bumper car for the first time and loved it."
    },
    {
        "You spent the day baking cookies with your family.",
        "Your son accidentally added salt instead of sugar, but the cookies still tasted good!"
    }
}

Nodes:define("FamilyTime", "Scene", {
    onCreate = function(self)
        self:createChild("Sprite", {
            texture = "familyTime_bg"
        })

        self.props.mentalMeter = self:createChild("MentalMeter", {
            depth = 100
        })

        self.props.dialogue = self:createChild("Dialogue", {
            y = self.scene.camera.bottom - 40
        })

        self.props.event = FamilyTimeData[math.random(1, #FamilyTimeData)]

        self.props.gain = math.random(30, 60)
        self.props.gainText = "+" .. self.props.gain .. " Mental Health"

        self.props.sm = self:createChild("StateMachine")
    end,

    onUpdate = function(self)
        self.props.sm:start()
        self.props.sm:wait(1.5)

        for i = 1, #self.props.event do
            if self.props.sm:once() then
                self.props.dialogue.func:say(self.props.event[i], function()
                    self.props.sm:nextEvent()
                end)
            end
            self.props.sm:event()
            self.props.dialogue.func:waitInput(self.props.sm)
        end
        if self.props.sm:once() then
            self.props.mentalMeter.func:changeValue(self.props.gain)
            self.props.dialogue.props.text.color = "#a8dfff"
        end
        self.func:say(self.props.gainText)
        if self.props.sm:once() then
            self:createChild("FillTransition", {
                fadeIn = 2,
                fadeOut = 1,
                interim = 1,
                next = "ANewDay"
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
        self.props.dialogue.func:waitInput(self.props.sm)
    end
})