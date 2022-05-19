local function update_udm()
    os.execute("udm --resume -2")
end

-- luacheck: globals mp
mp.register_event("shutdown", update_udm)
