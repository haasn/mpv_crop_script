function script_crop_toggle()
  if crop_active then
      unapply()
      crop_active = false
      return
  end

  if asscropper.active then
    asscropper:stop_crop(true)
  else
    local on_crop = function(crop)
      mp.set_osd_ass(0, 0, "")
      apply(crop)
      crop_active = true
    end
    local on_cancel = function()
      mp.osd_message("Crop canceled")
      mp.set_osd_ass(0, 0, "")
    end

    asscropper:start_crop(nil, on_crop, on_cancel)
    if not asscropper.active then
      mp.osd_message("No video to crop!", 2)
    end
  end
end


local next_tick_time = nil
function on_tick_listener()
  local now = mp.get_time()
  if next_tick_time == nil or now >= next_tick_time then
    if asscropper.active and display_state:recalculate_bounds() then
      mp.set_osd_ass(display_state.screen.width, display_state.screen.height, asscropper:get_render_ass())
    end
    next_tick_time = now + (1/60)
  end
end


function apply(crop)
    mp.command(string.format("no-osd vf add @%s:crop=%d:%d:%d:%d", SCRIPT_NAME,
                             crop.w, crop.h, crop.x, crop.y))
end

function unapply()
    mp.command(string.format("no-osd vf del @" .. SCRIPT_NAME .. ":crop"))
end

----------------------
-- Instances, binds --
----------------------

display_state = DisplayState()
asscropper = ASSCropper(display_state)
crop_active = false

asscropper.tick_callback = on_tick_listener
mp.register_event("tick", on_tick_listener)

local used_keybind = SCRIPT_KEYBIND
-- Disable the default keybind if asked to
if script_options.disable_keybind then
  used_keybind = nil
end
mp.add_key_binding(used_keybind, SCRIPT_HANDLER, script_crop_toggle)
