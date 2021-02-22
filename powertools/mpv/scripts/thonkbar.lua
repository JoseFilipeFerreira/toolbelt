function update_panel()
    print("updating")
    os.execute("pkill --signal 62 thonkbar")
end

mp.register_event("file-loaded", update_panel)
mp.register_event("end-file", update_panel)
mp.observe_property("pause", "bool", update_panel)
