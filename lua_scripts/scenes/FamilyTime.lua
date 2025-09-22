FamilyTimeData = {
    {
        "You taught your son how to ride a bicycle.",
        "He rode straight into a tree. You both laughed about it for hours."
    },
    {
        "You took the family out to the park.",
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
        "You spent the day baking cookies with your family.",
        "Your son accidentally added salt instead of sugar, but the cookies still tasted good!"
    },
    {
        "You took your family on a hike in the mountains.",
        "Your son slipped and fell, but you caught him just in time. You both laughed about it afterwards."
    }
}

Nodes:define("FamilyTime", "Scene", {
    onCreate = function(self)
        self:createChild("Sprite", {
            texture = "familyTime_bg"
        })

        self.get.mentalMeter = self:createChild("MentalMeter", {
            depth = 100
        })

        self.get.dialogue = self:createChild("Dialogue", {
            y = self.scene.camera.bottom - 40
        })

        self.get.event = FamilyTimeData[math.random(1, #FamilyTimeData)]

        self.get.gain = math.random(30, 50)
        self.get.gainText = "+" .. self.get.gain .. " Mental Health"

        self.get.sm = self:createChild("StateMachine")
    end,

    onUpdate = function(self)
        self.get.sm:start()
        self.get.sm:wait(1.5)

        for i = 1, #self.get.event do
            if self.get.sm:once() then
                self.get.dialogue.func:say(self.get.event[i], function()
                    self.get.sm:nextEvent()
                end)
            end
            self.get.sm:event()
            self.get.dialogue.func:waitInput(self.get.sm)
        end
        if self.get.sm:once() then
            self.get.mentalMeter.func:changeValue(self.get.gain)
            self.get.dialogue.props.text.color = "#a8dfff"
        end
        self.func:say(self.get.gainText)
        if self.get.sm:once() then
            self:createChild("FillTransition", {
                fadeIn = 2,
                fadeOut = 1,
                interim = 1,
                next = "ANewDay"
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