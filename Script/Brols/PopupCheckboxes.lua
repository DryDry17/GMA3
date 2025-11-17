-- Script GrandMA3 - Fenêtre popup avec cases à cocher
-- Auteur: Assistant
-- Description: Affiche une fenêtre popup avec des cases à cocher

function print(msg)
    Echo(msg)
end

function main()
    -- Définir les options pour les cases à cocher
    local options = {
        "Option 1 - Dimmer",
        "Option 2 - Couleur",
        "Option 3 - Position",
        "Option 4 - Gobo",
        "Option 5 - Beam"
    }

    -- Créer le texte du message
    local message = "Sélectionnez les options à activer:\n\n"
    for i, option in ipairs(options) do
        message = message .. i .. ". " .. option .. "\n"
    end
    message = message .. "\nEntrez les numéros séparés par des virgules (ex: 1,3,5):"

    -- Afficher la popup avec input
    local userInput = gma.textinput("Configuration", message)

    if userInput then
        -- Traiter l'input utilisateur
        local selectedOptions = {}

        -- Parser l'input (format: 1,3,5)
        for num in string.gmatch(userInput, "%d+") do
            local optionNum = tonumber(num)
            if optionNum and optionNum >= 1 and optionNum <= #options then
                table.insert(selectedOptions, optionNum)
            end
        end

        -- Afficher les options sélectionnées
        if #selectedOptions > 0 then
            local result = "Options sélectionnées:\n"
            for _, optionNum in ipairs(selectedOptions) do
                result = result .. "- " .. options[optionNum] .. "\n"
                print("Sélectionné: " .. options[optionNum])
            end

            gma.gui.msgbox("Confirmation", result)

            -- Exécuter des actions selon les options sélectionnées
            executeSelectedOptions(selectedOptions)
        else
            gma.gui.msgbox("Info", "Aucune option sélectionnée")
        end
    else
        print("Action annulée")
    end
end

function executeSelectedOptions(selectedOptions)
    for _, optionNum in ipairs(selectedOptions) do
        if optionNum == 1 then
            print("Activation des presets Dimmer...")
            -- Cmd('Store Preset 1.1')
        elseif optionNum == 2 then
            print("Activation des presets Couleur...")
            -- Cmd('Store Preset 4.1')
        elseif optionNum == 3 then
            print("Activation des presets Position...")
            -- Cmd('Store Preset 2.1')
        elseif optionNum == 4 then
            print("Activation des presets Gobo...")
            -- Cmd('Store Preset 5.1')
        elseif optionNum == 5 then
            print("Activation des presets Beam...")
            -- Cmd('Store Preset 3.1')
        end
    end
end

return main
