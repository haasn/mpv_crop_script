local SCRIPT_NAME = "mpv_crop_script"

local SCRIPT_KEYBIND = "c"
local SCRIPT_HANDLER = "crop-playback"

local assdraw = require 'mp.assdraw'
local msg = require 'mp.msg'
local opt = require 'mp.options'
local utils = require 'mp.utils'

--------------------
-- Script options --
--------------------

local script_options = {
    disable_keybind = false
}

-- Read user-given options, if any
read_options(script_options, SCRIPT_NAME)
