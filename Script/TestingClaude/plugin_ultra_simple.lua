--[[
Plugin Ultra Simple - GrandMA3
Version: 1.0

Ce plugin utilise UNIQUEMENT les fonctions Lua standard
pour vérifier que le système de plugins fonctionne.
--]]

-- Variable globale pour stocker les résultats
_G.test_results = {}

function Main(display_handle)
    -- Test 1: Le plugin s'exécute
    table.insert(_G.test_results, "Plugin demarre!")

    -- Test 2: Fonctions Lua de base
    local a = 10 + 5
    table.insert(_G.test_results, "Math fonctionne: " .. tostring(a))

    -- Test 3: Strings
    local str = "Hello GrandMA3"
    table.insert(_G.test_results, "String: " .. str)

    -- Test 4: Boucles
    local sum = 0
    for i = 1, 5 do
        sum = sum + i
    end
    table.insert(_G.test_results, "Boucle: sum = " .. tostring(sum))

    -- Test 5: Tables
    local actions = {"Action1", "Action2", "Action3"}
    table.insert(_G.test_results, "Table size: " .. #actions)

    -- Test 6: Vérifier si gma existe
    if gma then
        table.insert(_G.test_results, "Module 'gma' existe")

        -- Tester gma.feedback
        if gma.feedback then
            table.insert(_G.test_results, "gma.feedback existe")
            pcall(function()
                gma.feedback("Test depuis plugin ultra simple")
            end)
        end

        -- Tester gma.echo
        if gma.echo then
            table.insert(_G.test_results, "gma.echo existe")
            pcall(function()
                gma.echo("Test echo")
            end)
        end

        -- Tester gma.cmd
        if gma.cmd then
            table.insert(_G.test_results, "gma.cmd existe")
        end
    else
        table.insert(_G.test_results, "Module 'gma' N'EXISTE PAS")
    end

    -- Essayer d'afficher les résultats
    local output = table.concat(_G.test_results, "\n")

    -- Méthode 1: gma.feedback
    if gma and gma.feedback then
        pcall(function() gma.feedback(output) end)
    end

    -- Méthode 2: gma.echo
    if gma and gma.echo then
        pcall(function() gma.echo(output) end)
    end

    -- Méthode 3: print Lua standard
    pcall(function() print(output) end)

    -- Méthode 4: Écrire dans un fichier
    pcall(function()
        local file = io.open("C:\\Users\\Super\\Documents\\Progra\\GrandMA3\\GMA3\\Script\\ToKeep\\plugin_output.txt", "w")
        if file then
            file:write("=== RESULTATS DU PLUGIN ===\n\n")
            file:write(output)
            file:write("\n\n=== FIN ===\n")
            file:close()
        end
    end)

    return true
end

function Execute(display_handle)
    return Main(display_handle)
end

function Cleanup()
    -- Nettoyage
end

return Main
