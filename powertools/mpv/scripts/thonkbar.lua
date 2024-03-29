local function update_panel()
    os.execute("pkill --signal 61 thonkbar")
end

-- luacheck: globals mp
mp.register_event("file-loaded", update_panel)
mp.register_event("end-file", update_panel)
mp.observe_property("pause", "bool", update_panel)
mp.observe_property("volume", "number", update_panel)
