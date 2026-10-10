---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "us",
        kb_options   = "altwin:meta_alt",
        repeat_delay = 200,
        repeat_rate  = 35,
        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor        = 0.8,
        },
    },

    cursor = {
        hide_on_key_press = true,
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
