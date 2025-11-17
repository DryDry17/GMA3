--[[
Plugin GrandMA3 - Sélection Multiple avec Checkboxes
Auteur: Votre Nom
Version: 2.0

Plugin avancé avec interface de cases à cocher pour sélectionner et exécuter
plusieurs actions simultanément.
--]]

-- Configuration des actions disponibles
local ACTIONS = {
    {
        id = "clear_prog",
        name = "Clear Programmer",
        description = "Effacer le programmeur",
        command = "ClearAll",
        enabled = true
    },
    {
        id = "store_preset",
        name = "Store Preset",
        description = "Stocker un preset couleur",
        command = "Store Preset 4.1",
        enabled = true
    },
    {
        id = "update_seq",
        name = "Update Sequence",
        description = "Mettre à jour la séquence 1",
        command = "Update Sequence 1",
        enabled = true
    },
    {
        id = "select_all",
        name = "Select All Fixtures",
        description = "Sélectionner tous les projecteurs",
        command = "SelectAll",
        enabled = true
    },
    {
        id = "at_full",
        name = "At Full",
        description = "Mettre l'intensité à 100%",
        command = "At 100",
        enabled = true
    }
}

-- Fonction pour afficher le dialogue avec checkboxes
function ShowCheckboxDialog()
    -- Construire le message avec les options numérotées
    local message = "=== SÉLECTION D'ACTIONS ===\n\n"
    message = message .. "Cochez les actions à exécuter:\n\n"

    for i, action in ipairs(ACTIONS) do
        message = message .. string.format("[%d] %s\n    → %s\n\n", i, action.name, action.description)
    end

    message = message .. "━━━━━━━━━━━━━━━━━━━━━━\n"
    message = message .. "Entrez les numéros des actions séparés par des espaces\n"
    message = message .. "Exemple: 1 3 5"

    -- Utiliser PopupInput pour la saisie
    local userInput = gma.textinput("Sélection Multiple", message)

    return userInput
end

-- Alternative: Créer un dialogue avec états de boutons (simulant des checkboxes)
function ShowAdvancedCheckboxDialog()
    local states = {}
    local commands = {}

    -- Créer des boutons pour chaque action (états persistants)
    for i, action in ipairs(ACTIONS) do
        table.insert(commands, {
            value = i,
            name = action.name
        })
        table.insert(states, {
            pressed = false  -- État initial: non coché
        })
    end

    -- Ajouter les boutons de contrôle
    table.insert(commands, {value = 100, name = "Tout Sélectionner"})
    table.insert(commands, {value = 101, name = "Tout Désélectionner"})
    table.insert(commands, {value = 200, name = "✓ Exécuter"})
    table.insert(commands, {value = 0, name = "✗ Annuler"})

    local message = "Cliquez sur les actions pour les activer/désactiver:\n\n"
    for i, action in ipairs(ACTIONS) do
        message = message .. string.format("• %s\n", action.description)
    end

    local result = gma.gui.MessageBox({
        title = "Sélection d'Actions",
        message = message,
        commands = commands,
        states = states,
        icon = "question",
        multiselect = true
    })

    return result, states
end

-- Parser la sélection utilisateur (format texte)
function ParseSelection(inputString)
    if not inputString or inputString == "" then
        return {}
    end

    local selectedIndices = {}
    local seen = {}  -- Pour éviter les doublons

    -- Extraire tous les nombres
    for num in string.gmatch(inputString, "%d+") do
        local index = tonumber(num)
        if index >= 1 and index <= #ACTIONS and not seen[index] then
            table.insert(selectedIndices, index)
            seen[index] = true
        end
    end

    -- Trier les indices
    table.sort(selectedIndices)

    return selectedIndices
end

-- Afficher un récapitulatif des actions sélectionnées
function ShowSummary(selectedIndices)
    if #selectedIndices == 0 then
        gma.gui.MessageBox({
            title = "Erreur",
            message = "Aucune action sélectionnée!\n\nVeuillez sélectionner au moins une action.",
            commands = {{value = 0, name = "OK"}},
            icon = "error"
        })
        return false
    end

    -- Construire le message de confirmation
    local message = string.format("Nombre d'actions: %d\n\n", #selectedIndices)
    message = message .. "Actions sélectionnées:\n"
    message = message .. "━━━━━━━━━━━━━━━━━━━━━━\n"

    for i, index in ipairs(selectedIndices) do
        local action = ACTIONS[index]
        message = message .. string.format("%d. %s\n   Commande: %s\n\n", i, action.name, action.command)
    end

    message = message .. "━━━━━━━━━━━━━━━━━━━━━━\n"
    message = message .. "Voulez-vous exécuter ces actions?"

    -- Demander confirmation
    local result = gma.gui.MessageBox({
        title = "Confirmation d'Exécution",
        message = message,
        commands = {
            {value = 1, name = "✓ Exécuter"},
            {value = 0, name = "✗ Annuler"}
        },
        icon = "question"
    })

    return result == 1
end

-- Exécuter les actions sélectionnées avec feedback
function ExecuteActions(selectedIndices)
    local totalActions = #selectedIndices
    local successCount = 0
    local errorCount = 0

    gma.echo("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    gma.echo("   DÉBUT DE L'EXÉCUTION")
    gma.echo("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    for i, index in ipairs(selectedIndices) do
        local action = ACTIONS[index]

        gma.echo(string.format("\n[%d/%d] %s", i, totalActions, action.name))
        gma.echo("Commande: " .. action.command)

        -- Exécuter la commande
        local success, error = pcall(function()
            gma.cmd(action.command)
        end)

        if success then
            gma.echo("✓ Succès")
            successCount = successCount + 1
        else
            gma.echo("✗ Erreur: " .. tostring(error))
            errorCount = errorCount + 1
        end

        -- Délai entre les commandes
        gma.sleep(0.2)
    end

    gma.echo("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    gma.echo("   EXÉCUTION TERMINÉE")
    gma.echo("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    gma.echo(string.format("Succès: %d | Erreurs: %d | Total: %d", successCount, errorCount, totalActions))

    -- Message final
    local icon = errorCount > 0 and "warning" or "info"
    local message = string.format(
        "Exécution terminée!\n\n✓ Réussies: %d\n✗ Échouées: %d\n━━━━━━━━━━━━\nTotal: %d action(s)",
        successCount,
        errorCount,
        totalActions
    )

    gma.gui.MessageBox({
        title = "Rapport d'Exécution",
        message = message,
        commands = {{value = 0, name = "OK"}},
        icon = icon
    })
end

-- Fonction principale du plugin
function Main()
    gma.echo("\n╔════════════════════════════════════╗")
    gma.echo("║  Plugin: Sélection Multiple       ║")
    gma.echo("║  Version: 2.0                      ║")
    gma.echo("╚════════════════════════════════════╝\n")

    -- Étape 1: Afficher le dialogue de sélection
    local userInput = ShowCheckboxDialog()

    if not userInput then
        gma.feedback("⚠ Action annulée par l'utilisateur")
        return
    end

    -- Étape 2: Parser la sélection
    local selectedIndices = ParseSelection(userInput)

    -- Étape 3: Afficher le récapitulatif et confirmer
    if not ShowSummary(selectedIndices) then
        gma.feedback("⚠ Exécution annulée")
        return
    end

    -- Étape 4: Exécuter les actions
    ExecuteActions(selectedIndices)
end

-- Points d'entrée pour GrandMA3
function Execute(handle)
    Main()
end

function Cleanup()
    -- Nettoyage si nécessaire
end

function PluginInfo()
    return {
        name = "Sélection Multiple avec Checkboxes",
        version = "2.0",
        author = "Votre Nom",
        description = "Permet de sélectionner et exécuter plusieurs actions via une interface de cases à cocher"
    }
end

-- Retourner la fonction principale
return Main
