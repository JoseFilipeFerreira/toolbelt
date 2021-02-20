function notify_metadata_updated(name, data)
    notify_current_track()
end

function update_panel()
    local update_panel = ("pkill --signal 62 thonkbar")
    print("executing command: " .. update_panel)
    os.execute(update_panel)
end

mp.register_event("file-loaded", update_panel)
