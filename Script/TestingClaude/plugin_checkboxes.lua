--[[
Plugin GrandMA3 - Sélection d'actions par cases à cocher
Auteur: Votre Nom
Version: 1.0

Ce plugin affiche une interface avec des cases à cocher pour sélectionner
les actions à exécuter, puis exécute les commandes correspondantes.
--]]

-- Configuration des actions disponibles
local ACTIONS = {
    {
        name = "Clear Programmer",
        description = "Effacer le programmeur",
        command = "ClearAll"
    },
    {
        name = "Store Preset",
        description = "Stocker un preset",
        command = "Store Preset 1"
    },
    {
        name = "Update Sequence",
        description = "Mettre à jour la séquence",
        command = "Update Sequence 1"
    },
    {
        name = "Blackout",
        description = "Activer le blackout",
        command = "Blackout"
    },
    {
        name = "Release All",
        description = "Relâcher tous les executors",
        command = "Release Master 1"
    }
}

-- Fonction pour créer l'interface de sélection
function ShowCheckboxDialog()
    local messageText = "Sélectionnez les actions à exécuter:\n\n"

    -- Créer le texte avec toutes les options
    for i, action in ipairs(ACTIONS) do
        messageText = messageText .. string.format("[%d] %s - %s\n", i, action.name, action.description)
    end

    messageText = messageText .. "\nEntrez les numéros séparés par des espaces (ex: 1 3 5)"

    -- Demander la saisie utilisateur
    local userInput = gma.textinput("Sélection d'actions", messageText)

    if not userInput or userInput == "" then
        gma.feedback("Action annulée")
        return nil
    end

    return userInput
end

-- Fonction pour parser la sélection utilisateur
function ParseSelection(inputString)
    local selectedIndices = {}

    -- Extraire tous les nombres de la chaîne
    for num in string.gmatch(inputString, "%d+") do
        local index = tonumber(num)
        if index >= 1 and index <= #ACTIONS then
            table.insert(selectedIndices, index)
        end
    end

    return selectedIndices
end

-- Fonction pour confirmer les actions sélectionnées
function ConfirmActions(selectedIndices)
    if #selectedIndices == 0 then
        gma.feedback("Aucune action valide sélectionnée")
        return false
    end

    local confirmMessage = "Vous allez exécuter les actions suivantes:\n\n"

    for _, index in ipairs(selectedIndices) do
        confirmMessage = confirmMessage .. "• " .. ACTIONS[index].name .. "\n"
    end

    confirmMessage = confirmMessage .. "\nContinuer?"

    -- Créer un popup de confirmation
    local result = gma.gui.MessageBox({
        title = "Confirmation",
        message = confirmMessage,
        commands = {
            {value = 1, name = "Oui"},
            {value = 0, name = "Non"}
        },
        icon = "question"
    })

    return result == 1
end

-- Fonction pour exécuter les commandes sélectionnées
function ExecuteSelectedActions(selectedIndices)
    gma.feedback("=== Début de l'exécution ===")

    for i, index in ipairs(selectedIndices) do
        local action = ACTIONS[index]

        gma.feedback(string.format("[%d/%d] Exécution: %s", i, #selectedIndices, action.name))

        -- Exécuter la commande GrandMA3
        gma.cmd(action.command)

        -- Petit délai entre les commandes (optionnel)
        gma.sleep(0.1)
    end

    gma.feedback("=== Exécution terminée ===")

    -- Message final de succès
    gma.gui.MessageBox({
        title = "Succès",
        message = string.format("%d action(s) exécutée(s) avec succès!", #selectedIndices),
        commands = {{value = 0, name = "OK"}},
        icon = "info"
    })
end

-- Fonction principale du plugin
function Main()
    -- Étape 1: Afficher l'interface de sélection
    local userInput = ShowCheckboxDialog()

    if not userInput then
        return  -- Utilisateur a annulé
    end

    -- Étape 2: Parser la sélection
    local selectedIndices = ParseSelection(userInput)

    -- Étape 3: Confirmer les actions
    if not ConfirmActions(selectedIndices) then
        gma.feedback("Action annulée par l'utilisateur")
        return
    end

    -- Étape 4: Exécuter les actions sélectionnées
    ExecuteSelectedActions(selectedIndices)
end

-- Fonction de retour pour GrandMA3
function Execute(handle)
    Main()
end

-- Point d'entrée du plugin
return Main
