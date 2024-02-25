nova.require "data/lua/gfx/common"

register_gfx_blueprint "scorching_smoke"
{
    tag = "scorching_smoke",
    scene = {
        position = vec3( 0.0, 0.5, 0.0 ),
    },
    point_generator = {
        type     = "box",
        position = vec3(0,0.2,0),
        extents  = vec3(0.7,0.8,0.7),
    },
    particle = {
        material        = "data/texture/particles/smoke_02/smoke_02",
        group_id        = "pgroup_enviro",
        tiling          = 8,
        destroy_owner   = true,
    },
    particle_emitter = {
        angle    = 20,
        rate     = 4,
        color    = 0.7,
        size     = { {0.7}, {1.0} },
        velocity = { 0.1, 0.2 },
        lifetime = { 1.5, 2.5 },
        duration = 2,
    },
    particle_animator = {
        range = ivec2(0,63),
        rate  = 24.0,
    },
    particle_transform = {
        force = vec3(0,0.1,0),
        scale = 0.02,
    },
    particle_fade = {
        fade_in   = 0.5,
        fade_out  = 1.5,
    },
}