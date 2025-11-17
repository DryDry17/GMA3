--[[
Plugin GrandMA3 - Sélection Multiple (Version Correcte)
Auteur: Votre Nom
Version: 2.2

Plugin avec sélection de cases à cocher - API GrandMA3 Officielle
Utilise les fonctions Object-Free confirmées dans la documentation.
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

    -- Utiliser TextInput (fonction Object-Free confirmée)
    local userInput = TextInput("Selection Multiple", message)

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
    message = message .. "Voulez-vous executer ces actions?"

    return message
end

-- Confirmer les actions avec l'utilisateur
function ConfirmActions(selectedIndices)
    if #selectedIndices == 0 then
        Printf("Erreur: Aucune action valide selectionnee\n")
        return false
    end

    local message = CreateConfirmationMessage(selectedIndices)

    -- Utiliser Confirm (fonction Object-Free confirmée)
    local result = Confirm("Confirmation", message)

    return result
end

-- Exécuter les actions sélectionnées
function ExecuteActions(selectedIndices)
    local totalActions = #selectedIndices
    local successCount = 0
    local errorCount = 0

    Printf("================================\n")
    Printf("   DEBUT DE L'EXECUTION\n")
    Printf("================================\n")
    Printf("Execution de %d action(s)...\n", totalActions)

    for i, index in ipairs(selectedIndices) do
        local action = ACTIONS[index]

        Printf("\n[%d/%d] %s\n", i, totalActions, action.name)
        Printf("Commande: %s\n", action.command)

        -- Exécuter la commande avec gestion d'erreur
        local success = pcall(function()
            Cmd(action.command)
        end)

        if success then
            Printf("OK Succes\n")
            successCount = successCount + 1
        else
            Printf("XX Erreur lors de l'execution\n")
            errorCount = errorCount + 1
        end

        -- Délai entre les commandes (en millisecondes)
        Sleep(200)
    end

    Printf("\n================================\n")
    Printf("   EXECUTION TERMINEE\n")
    Printf("================================\n")
    Printf("Succes: %d | Erreurs: %d | Total: %d\n", successCount, errorCount, totalActions)

    -- Message final
    local finalMessage = string.format(
        "Execution terminee!\n\nReussies: %d\nEchouees: %d\nTotal: %d",
        successCount,
        errorCount,
        totalActions
    )

    MessageBox({
        title = "Rapport d'Execution",
        message = finalMessage,
        icon = "info"
    })
end

-- Fonction principale du plugin
function Main()
    Printf("\n================================\n")
    Printf("  Plugin: Selection Multiple\n")
    Printf("  Version: 2.2 (API Officielle)\n")
    Printf("================================\n\n")

    -- Étape 1: Afficher le dialogue de sélection
    local userInput = ShowSelectionDialog()

    if not userInput then
        Printf("Action annulee par l'utilisateur\n")
        return
    end

    -- Étape 2: Parser la sélection
    local selectedIndices = ParseSelection(userInput)

    if not selectedIndices or #selectedIndices == 0 then
        Printf("Erreur: Aucune action valide selectionnee\n")
        return
    end

    -- Afficher les actions sélectionnées
    Printf("%d action(s) selectionnee(s)\n", #selectedIndices)

    -- Étape 3: Confirmer les actions
    if not ConfirmActions(selectedIndices) then
        Printf("Execution annulee\n")
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
    Printf("Plugin cleanup completed\n")
end

-- Retourner la fonction principale
return Main
