-- Script GrandMA3 - Fenêtre popup avancée avec cases à cocher
-- Auteur: Assistant
-- Description: Version améliorée avec interface utilisateur

function print(msg)
    Echo(msg)
end

-- Fonction pour créer une checkbox simple
function createCheckbox(title, items)
    local selection = {}

    -- Afficher le menu principal
    local menuText = title .. "\n" .. string.rep("=", 50) .. "\n\n"

    for i, item in ipairs(items) do
        menuText = menuText .. string.format("[%d] %s\n", i, item.label)
    end

    menuText = menuText .. "\n" .. string.rep("=", 50) .. "\n"
    menuText = menuText .. "Entrez les numéros à sélectionner (ex: 1,2,5)\n"
    menuText = menuText .. "ou 'all' pour tout sélectionner\n"
    menuText = menuText .. "ou 'cancel' pour annuler"

    -- Demander l'input
    local input = gma.textinput("Sélection", menuText)

    if not input or input == "" or input:lower() == "cancel" then
        return nil
    end

    -- Traiter "all"
    if input:lower() == "all" then
        for i = 1, #items do
            selection[i] = true
        end
        return selection
    end

    -- Parser les numéros
    for num in string.gmatch(input, "%d+") do
        local idx = tonumber(num)
        if idx and idx >= 1 and idx <= #items then
            selection[idx] = true
        end
    end

    return selection
end

-- Fonction principale
function main()
    -- Définir les items avec leurs actions
    local items = {
        { label = "Générer Presets Dimmer (1.1-1.5)", action = generateDimmerPresets },
        { label = "Générer Presets Couleur (4.1-4.15)", action = generateColorPresets },
        { label = "Générer Presets Position (2.x)", action = generatePositionPresets },
        { label = "Générer Groupes (L1-L6)", action = generateGroups },
        { label = "Générer Séquences Couleur", action = generateColorSequences },
        { label = "Générer Séquences Dimmer", action = generateDimmerSequences },
        { label = "Générer Appearances", action = generateAppearances },
        { label = "Tout nettoyer (ClearAll)", action = clearAll }
    }

    -- Afficher la popup et récupérer la sélection
    local selection = createCheckbox("Configuration du Show - Sélectionnez les éléments à générer", items)

    if not selection then
        print("Action annulée par l'utilisateur")
        return
    end

    -- Compter les sélections
    local count = 0
    for _ in pairs(selection) do
        count = count + 1
    end

    if count == 0 then
        gma.gui.msgbox("Information", "Aucune option sélectionnée")
        return
    end

    -- Confirmation
    local confirmText = "Vous allez exécuter " .. count .. " action(s):\n\n"
    for i, isSelected in pairs(selection) do
        if isSelected then
            confirmText = confirmText .. "• " .. items[i].label .. "\n"
        end
    end
    confirmText = confirmText .. "\nContinuer ?"

    local confirm = gma.gui.confirm("Confirmation", confirmText)

    if confirm then
        -- Activer le mode Blind
        Cmd('Blind')

        -- Exécuter les actions sélectionnées
        print("Début de l'exécution...")
        for i, isSelected in pairs(selection) do
            if isSelected then
                print("→ " .. items[i].label)
                if items[i].action then
                    items[i].action()
                end
            end
        end

        -- Désactiver le mode Blind
        Cmd('Blind Off')

        gma.gui.msgbox("Succès", count .. " action(s) exécutée(s) avec succès!")
        print("Terminé!")
    else
        print("Exécution annulée")
    end
end

-- Fonctions d'action (exemples)
function generateDimmerPresets()
    Cmd('Store Preset 1.1 /Overwrite')
    Cmd('Label Preset 1.1 "100%"')
    print("  ✓ Presets Dimmer générés")
end

function generateColorPresets()
    Cmd('Store Preset 4.1 /Overwrite')
    Cmd('Label Preset 4.1 "White"')
    print("  ✓ Presets Couleur générés")
end

function generatePositionPresets()
    Cmd('Store Preset 2.1 /Overwrite')
    Cmd('Label Preset 2.1 "Home"')
    print("  ✓ Presets Position générés")
end

function generateGroups()
    for i = 1, 6 do
        Cmd('Store Group ' .. i .. ' /Overwrite')
        Cmd('Label Group ' .. i .. ' "L' .. i .. ' Grid"')
    end
    print("  ✓ Groupes générés")
end

function generateColorSequences()
    Cmd('Store Sequence 101 /Overwrite')
    Cmd('Label Sequence 101 "Colors"')
    print("  ✓ Séquences Couleur générées")
end

function generateDimmerSequences()
    Cmd('Store Sequence 201 /Overwrite')
    Cmd('Label Sequence 201 "Dimmer"')
    print("  ✓ Séquences Dimmer générées")
end

function generateAppearances()
    Cmd('Store Appearance 101 /Overwrite')
    Cmd('Label Appearance 101 "Custom"')
    print("  ✓ Appearances générées")
end

function clearAll()
    Cmd('ClearAll')
    print("  ✓ Tout nettoyé")
end

return main
