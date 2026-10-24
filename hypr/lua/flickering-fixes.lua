hl.config({
    opengl = {
        -- Reduces flicker if the hybrid NVIDIA GPU is enabled; ignored on Intel.
        nvidia_anti_flicker = true,
    },
})

hl.window_rule({
    match = { class = "^(jetbrains-.*)$" },
    no_initial_focus = true,
})
