-- Script GrandMA3 - Popup simple avec sélection
-- Auteur: Assistant
-- Description: Version simplifiée et rapide

function main()
    -- Menu de sélection simple
    local message = [[
╔════════════════════════════════════════╗
║   GÉNÉRATEUR DE SHOW - SÉLECTION      ║
╚════════════════════════════════════════╝

Cochez les éléments à générer :

[1] ☐ Dimmer Presets
[2] ☐ Color Presets
[3] ☐ Position Presets
[4] ☐ Groups (L1-L6)
[5] ☐ Sequences
[6] ☐ Appearances

────────────────────────────────────────
Entrez vos choix (ex: 1,2,4 ou 'all')
Appuyez sur Annuler pour quitter
]]

    -- Demander l'input
    local input = gma.textinput("Configuration Show", message)

    if not input or input == "" then
        Echo("Opération annulée")
        return
    end

    -- Initialiser les flags
    local flags = {
        dimmer = false,
        color = false,
        position = false,
        groups = false,
        sequences = false,
        appearances = false
    }

    -- Parser l'input
    if input:lower() == "all" then
        flags.dimmer = true
        flags.color = true
        flags.position = true
        flags.groups = true
        flags.sequences = true
        flags.appearances = true
    else
        for num in string.gmatch(input, "%d+") do
            local choice = tonumber(num)
            if choice == 1 then flags.dimmer = true
            elseif choice == 2 then flags.color = true
            elseif choice == 3 then flags.position = true
            elseif choice == 4 then flags.groups = true
            elseif choice == 5 then flags.sequences = true
            elseif choice == 6 then flags.appearances = true
            end
        end
    end

    -- Construire le message de confirmation
    local selected = {}
    if flags.dimmer then table.insert(selected, "Dimmer Presets") end
    if flags.color then table.insert(selected, "Color Presets") end
    if flags.position then table.insert(selected, "Position Presets") end
    if flags.groups then table.insert(selected, "Groups") end
    if flags.sequences then table.insert(selected, "Sequences") end
    if flags.appearances then table.insert(selected, "Appearances") end

    if #selected == 0 then
        gma.gui.msgbox("Information", "Aucune option sélectionnée")
        return
    end

    -- Afficher la confirmation
    local confirmMsg = "Éléments à générer:\n\n"
    for i, item in ipairs(selected) do
        confirmMsg = confirmMsg .. "✓ " .. item .. "\n"
    end
    confirmMsg = confirmMsg .. "\nContinuer ?"

    if not gma.gui.confirm("Confirmation", confirmMsg) then
        Echo("Opération annulée")
        return
    end

    -- Exécuter les actions
    Echo("═══════════════════════════════════")
    Echo("Début de la génération...")
    Echo("═══════════════════════════════════")

    Cmd('Blind')

    if flags.groups then
        Echo("→ Génération des Groupes...")
        for i = 1, 6 do
            Cmd('Store Group ' .. i .. ' /Overwrite')
            Cmd('Label Group ' .. i .. ' "L' .. i .. '"')
        end
        Echo("  ✓ 6 groupes créés")
    end

    if flags.dimmer then
        Echo("→ Génération Dimmer Presets...")
        local dimValues = {100, 75, 50, 25, 0}
        for i, val in ipairs(dimValues) do
            Cmd('ClearAll')
            Cmd('Group 1 At ' .. val)
            Cmd('Store Preset 1.' .. i .. ' /Overwrite')
            Cmd('Label Preset 1.' .. i .. ' "' .. val .. '%"')
        end
        Echo("  ✓ 5 presets dimmer créés")
    end

    if flags.color then
        Echo("→ Génération Color Presets...")
        local colors = {
            {name = "White", gel = "MA.white"},
            {name = "Red", gel = "MA.red"},
            {name = "Green", gel = "MA.green"},
            {name = "Blue", gel = "MA.blue"},
            {name = "Yellow", gel = "MA.yellow"}
        }
        for i, color in ipairs(colors) do
            Cmd('ClearAll')
            Cmd('Group 1 At Gel "' .. color.gel .. '"')
            Cmd('Store Preset 4.' .. i .. ' /Overwrite')
            Cmd('Label Preset 4.' .. i .. ' "' .. color.name .. '"')
        end
        Echo("  ✓ " .. #colors .. " presets couleur créés")
    end

    if flags.position then
        Echo("→ Génération Position Presets...")
        Cmd('ClearAll')
        Cmd('Group 1 Attribute "Pan" At 0')
        Cmd('Attribute "Tilt" At -45')
        Cmd('Store Preset 2.1 /Overwrite')
        Cmd('Label Preset 2.1 "Home"')
        Echo("  ✓ Presets position créés")
    end

    if flags.sequences then
        Echo("→ Génération Sequences...")
        Cmd('Store Sequence 101 /Overwrite')
        Cmd('Label Sequence 101 "Main Sequence"')
        Echo("  ✓ Sequences créées")
    end

    if flags.appearances then
        Echo("→ Génération Appearances...")
        Cmd('Store Appearance 101 /Overwrite')
        Cmd('Label Appearance 101 "Custom App"')
        Cmd('Set Appearance 101 "BackR" 255')
        Cmd('Set Appearance 101 "BackG" 255')
        Cmd('Set Appearance 101 "BackB" 255')
        Echo("  ✓ Appearances créées")
    end

    Cmd('Blind Off')
    Cmd('ClearAll')

    Echo("═══════════════════════════════════")
    Echo("✓ Génération terminée avec succès!")
    Echo("═══════════════════════════════════")

    gma.gui.msgbox("Succès", "Tous les éléments ont été générés!\n\nConsultez la Command Line pour les détails.")
end

return main
