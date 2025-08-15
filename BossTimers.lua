/*local f = CreateFrame("Frame")

-- Register message handlers
BigWigsLoader.RegisterMessage(f, "BigWigs_StartBar", function(_, module, key, text, duration, icon)
    print(("|cff00ff00[BigWigs]|r StartBar: module=%s key=%s text=%q duration=%.1f icon=%s")
        :format(module and module.moduleName or "?", tostring(key), tostring(text), duration or 0, tostring(icon)))
end)

BigWigsLoader.RegisterMessage(f, "BigWigs_StopBar", function(_, module, text)
    print(("|cff00ff00[BigWigs]|r StopBar: module=%s text=%q")
        :format(module and module.moduleName or "?", tostring(text)))
end)

BigWigsLoader.RegisterMessage(f, "BigWigs_StopBars", function(_, module)
    print(("|cff00ff00[BigWigs]|r StopBars: module=%s")
        :format(module and module.moduleName or "?"))
end)

print("MY BW TAP")*/