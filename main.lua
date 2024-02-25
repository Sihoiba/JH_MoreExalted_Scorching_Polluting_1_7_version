register_blueprint "exalted_kw_corrosive"
{
    flags = { EF_NOPICKUP },
    text = {
        status = "CORROSIVE",
        sdesc  = "spawns acid pools in the vicinity, acid immunity",
    },
    attributes = {
        counter = 0,
        resist = {
            acid   = 100,
        },
    },
    callbacks = {
        on_activate = [[
            function( self, entity )
                nova.log("Attaching polluting")
                entity:attach( "exalted_kw_corrosive" )
            end
        ]],
        on_action = [[
            function ( self, entity, time_passed, last )
                local level = world:get_level()
                local player = world:get_player()

                local place = function( level, c )
                    if not level:get_cell_flags( c )[ EF_NOMOVE ] then
                        local acid  = level:get_entity( c, "acid_pool" )
                        if not acid then
                            acid = level:place_entity( "acid_pool", c )
                        end
                        acid.attributes.acid_amount = 10
                        acid.lifetime.time_left = math.max( acid.lifetime.time_left, 300 + math.random(100) )
                    end
                end

                if time_passed > 0 then
                    local sattr = self.attributes
                    sattr.counter = sattr.counter + time_passed
                    local entityPos = world:get_position( entity )
                    if sattr.counter > 150 then
                        nova.log("Pollution spreading acid")
                        sattr.counter = 0
                        local rc = gtk.random_near_coord( entityPos, 3 )
                        if rc then
                            ui:spawn_fx( entity, "ps_broken_sparks", entity )
                            place( level, rc )
                        end
                    end
                end

            end
        ]],
    },
}

register_blueprint "exalted_kw_infernal"
{
    flags = { EF_NOPICKUP },
    text = {
        status = "INFERNAL",
        sdesc  = "spawns fire in the vicinity, fire immunity, cold affliction",
    },
    attributes = {
        counter = 0,
        resist = {
            ignite = 100,
            cold   = -100
        },
    },
    callbacks = {
        on_activate = [[
            function( self, entity )
                local orig_ignite_resist = entity:attribute( "resist", "ignite" )
                if orig_ignite_resist and orig_ignite_resist < 0 then
                    self.attributes["ignite.resist"] = self.attributes["ignite.resist"] + (-1 * orig_ignite_resist)
                end
                entity:attach( "exalted_kw_infernal" )
            end
        ]],
        on_action = [[
            function ( self, entity, time_passed, last )
                -- nova.log("Scorching checking on action")
                local level = world:get_level()
                local player = world:get_player()

                local place = function( c )
                    ui:spawn_fx( entity, "scorching_smoke", entity )
                    gtk.place_flames( c, 6, 300 + math.random(100) )
                end

                if time_passed > 0 then
                    local sattr = self.attributes
                    sattr.counter = sattr.counter + time_passed
                    local entityPos = world:get_position( entity )
                    if sattr.counter > 150 then
                        local rc = gtk.random_near_coord( entityPos, 3 )
                        if rc then
                            place( rc )
                        end
                    end
                end
                -- nova.log("Scorching done making fire")
            end
        ]],
    },
}