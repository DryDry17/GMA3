-- Fonction pour afficher un popup de confirmation
-- Retourne true si l'utilisateur confirme, false sinon

function ShowConfirmPopup(message, title)
    -- Titre par défaut si non spécifié
    title = title or "Confirmation"

    -- Affiche le popup de confirmation avec MessageBox
    -- Type "OkCancel" permet OK ou Annuler
    -- Type "YesNo" permet Oui ou Non
    local result = gma.gui.MessageBox({
        title = title,
        message = message,
        commands = {
            {value = 1, name = "OK"},
            {value = 0, name = "Annuler"}
        },
        states = {{pressed = false}},
        icon = "question"
    })

    -- Retourne true si OK (value=1), false sinon
    return result == 1
end

-- Alternative: fonction simple avec PopupInput pour texte
function ShowInputPopup(prompt, defaultValue)
    local result = gma.textinput(prompt, defaultValue or "")
    return result
end

-- Alternative: Message simple sans confirmation
function ShowMessagePopup(message, title)
    title = title or "Information"
    gma.gui.MessageBox({
        title = title,
        message = message,
        commands = {{value = 0, name = "OK"}},
        icon = "info"
    })
end

-- Exemple d'utilisation:
--
-- 1. Confirmation OK/Annuler:
-- local response = ShowConfirmPopup("Voulez-vous vraiment exécuter cette action?", "Attention")
-- if response then
--     gma.echo("Action confirmée")
--     -- Votre code ici
-- else
--     gma.echo("Action annulée")
-- end
--
-- 2. Saisie de texte:
-- local userInput = ShowInputPopup("Entrez un nom:", "Default")
-- if userInput then
--     gma.echo("Vous avez saisi: " .. userInput)
-- end
--
-- 3. Message simple:
-- ShowMessagePopup("Opération terminée avec succès!", "Succès")

return {
    ShowConfirmPopup = ShowConfirmPopup,
    ShowInputPopup = ShowInputPopup,
    ShowMessagePopup = ShowMessagePopup
}
