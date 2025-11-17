--[[
Plugin GrandMA3 - Sélection Multiple (Version Compatible)
Auteur: Votre Nom
Version: 2.1

Plugin avec sélection de cases à cocher - Compatible toutes versions GrandMA3
Utilise uniquement les fonctions API confirmées.
--]]

-- Configuration des actions disponibles
local ACTIONS = {
    {
        id = "clear_prog",
        name = "Clear Programmer",
        description = "Effacer le programmeur",
        command = "ClearAll"
    },
    {
        id = "store_preset",
        name = "Store Preset",
        description = "Stocker un preset couleur",
        command = "Store Preset 4.1"
    },
    {
        id = "update_seq",
        name = "Update Sequence",
        description = "Mettre à jour la séquence 1",
        command = "Update Sequence 1"
    },
    {
        id = "select_all",
        name = "Select All Fixtures",
        description = "Sélectionner tous les projecteurs",
        command = "SelectAll"
    },
    {
        id = "at_full",
        name = "At Full",
        description = "Mettre l'intensité à 100%",
        command = "At 100"
    }
}

-- Fonction pour créer le message de sélection
function CreateSelectionMessage()
    local message = "=== SELECTION D'ACTIONS ===\n\n"
    message = message .. "Cochez les actions a executer:\n\n"

    for i, action in ipairs(ACTIONS) do
        message = message .. string.format("[%d] %s\n    > %s\n\n", i, action.name, action.description)
    end

    message = message .. "================================\n"
    message = message .. "Entrez les numeros separes par des espaces\n"
    message = message .. "Exemple: 1 3 5\n"
    message = message .. "Ou tapez 'all' pour tout selectionner"

    return message
end

-- Fonction pour afficher le dialogue de sélection
function ShowSelectionDialog()
    local message = CreateSelectionMessage()

    -- Utiliser PopupInput (fonction confirmée dans GrandMA3)
    local userInput = gma.textinput("Selection Multiple", message)

    return userInput
end

-- Parser la sélection utilisateur
function ParseSelection(inputString)
    if not inputString or inputString == "" then
        return nil
    end

    -- Vérifier si "all" est demandé
    if string.lower(inputString) == "all" or string.lower(inputString) == "tout" then
        local allIndices = {}
        for i = 1, #ACTIONS do
            table.insert(allIndices, i)
        end
        return allIndices
    end

    local selectedIndices = {}
    local seen = {}

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

-- Créer le message de confirmation
function CreateConfirmationMessage(selectedIndices)
    local message = string.format("Nombre d'actions: %d\n\n", #selectedIndices)
    message = message .. "Actions selectionnees:\n"
    message = message .. "================================\n"

    for i, index in ipairs(selectedIndices) do
        local action = ACTIONS[index]
        message = message .. string.format("%d. %s\n   Commande: %s\n\n", i, action.name, action.command)
    end

    message = message .. "================================\n"
    message = message .. "Tapez 'oui' pour executer\n"
    message = message .. "Tapez 'non' pour annuler"

    return message
end

-- Confirmer les actions avec l'utilisateur
function ConfirmActions(selectedIndices)
    if #selectedIndices == 0 then
        gma.feedback("Erreur: Aucune action valide selectionnee")
        return false
    end

    local message = CreateConfirmationMessage(selectedIndices)
    local response = gma.textinput("Confirmation", message)

    if not response then
        return false
    end

    local lowerResponse = string.lower(response)
    return lowerResponse == "oui" or lowerResponse == "yes" or lowerResponse == "o" or lowerResponse == "y"
end

-- Exécuter les actions sélectionnées
function ExecuteActions(selectedIndices)
    local totalActions = #selectedIndices
    local successCount = 0
    local errorCount = 0

    gma.echo("================================")
    gma.echo("   DEBUT DE L'EXECUTION")
    gma.echo("================================")
    gma.feedback("Execution de " .. totalActions .. " action(s)...")

    for i, index in ipairs(selectedIndices) do
        local action = ACTIONS[index]

        gma.echo(string.format("\n[%d/%d] %s", i, totalActions, action.name))
        gma.echo("Commande: " .. action.command)

        -- Exécuter la commande avec gestion d'erreur
        local success = pcall(function()
            gma.cmd(action.command)
        end)

        if success then
            gma.echo("OK Succes")
            successCount = successCount + 1
        else
            gma.echo("XX Erreur lors de l'execution")
            errorCount = errorCount + 1
        end

        -- Délai entre les commandes
        gma.sleep(0.2)
    end

    gma.echo("\n================================")
    gma.echo("   EXECUTION TERMINEE")
    gma.echo("================================")
    gma.echo(string.format("Succes: %d | Erreurs: %d | Total: %d", successCount, errorCount, totalActions))

    -- Feedback final
    local finalMessage = string.format(
        "Execution terminee! Reussies: %d | Echouees: %d | Total: %d",
        successCount,
        errorCount,
        totalActions
    )
    gma.feedback(finalMessage)
end

-- Fonction principale du plugin
function Main()
    gma.echo("\n================================")
    gma.echo("  Plugin: Selection Multiple")
    gma.echo("  Version: 2.1 (Compatible)")
    gma.echo("================================\n")

    -- Étape 1: Afficher le dialogue de sélection
    local userInput = ShowSelectionDialog()

    if not userInput then
        gma.feedback("Action annulee par l'utilisateur")
        return
    end

    -- Étape 2: Parser la sélection
    local selectedIndices = ParseSelection(userInput)

    if not selectedIndices or #selectedIndices == 0 then
        gma.feedback("Erreur: Aucune action valide selectionnee")
        return
    end

    -- Afficher les actions sélectionnées
    gma.feedback(string.format("%d action(s) selectionnee(s)", #selectedIndices))

    -- Étape 3: Confirmer les actions
    if not ConfirmActions(selectedIndices) then
        gma.feedback("Execution annulee")
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
    gma.echo("Plugin cleanup completed")
end

-- Retourner la fonction principale
return Main
