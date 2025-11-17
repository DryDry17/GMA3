--[[
Plugin de Découverte API - GrandMA3
Version: 1.0

Ce plugin teste TOUTES les variantes possibles de syntaxe
pour découvrir celle qui fonctionne dans votre version.
--]]

function Main(display_handle)
    -- Fonction helper pour tester sans crasher
    local function TryFunction(name, func)
        local success, result = pcall(func)
        if success then
            return "OK"
        else
            return "ERREUR"
        end
    end

    -- Variable pour stocker les résultats
    local results = ""
    results = results .. "=== TEST API GRANDMA3 ===\n\n"

    -- Test 1: Variantes de Printf/Echo
    results = results .. "--- Test Output Functions ---\n"

    local test1a = TryFunction("Printf", function()
        Printf("test")
    end)
    results = results .. "Printf() ................. " .. test1a .. "\n"

    local test1b = TryFunction("gma.Printf", function()
        gma.Printf("test")
    end)
    results = results .. "gma.Printf() ............ " .. test1b .. "\n"

    local test1c = TryFunction("Echo", function()
        Echo("test")
    end)
    results = results .. "Echo() .................. " .. test1c .. "\n"

    local test1d = TryFunction("gma.echo", function()
        gma.echo("test")
    end)
    results = results .. "gma.echo() .............. " .. test1d .. "\n"

    local test1e = TryFunction("gma.feedback", function()
        gma.feedback("test")
    end)
    results = results .. "gma.feedback() .......... " .. test1e .. "\n"

    -- Test 2: Variantes de Cmd
    results = results .. "\n--- Test Command Functions ---\n"

    local test2a = TryFunction("Cmd", function()
        Cmd("ClearAll")
    end)
    results = results .. "Cmd() ................... " .. test2a .. "\n"

    local test2b = TryFunction("gma.cmd", function()
        gma.cmd("ClearAll")
    end)
    results = results .. "gma.cmd() ............... " .. test2b .. "\n"

    local test2c = TryFunction("gma.Cmd", function()
        gma.Cmd("ClearAll")
    end)
    results = results .. "gma.Cmd() ............... " .. test2c .. "\n"

    -- Test 3: Variantes de Sleep
    results = results .. "\n--- Test Sleep Functions ---\n"

    local test3a = TryFunction("Sleep", function()
        Sleep(10)
    end)
    results = results .. "Sleep() ................. " .. test3a .. "\n"

    local test3b = TryFunction("gma.sleep", function()
        gma.sleep(0.01)
    end)
    results = results .. "gma.sleep() ............. " .. test3b .. "\n"

    -- Test 4: Variantes de TextInput
    results = results .. "\n--- Test Input Functions ---\n"

    -- Note: Ces tests peuvent afficher des popups
    -- Annulez-les immédiatement si ils apparaissent

    local test4a = TryFunction("TextInput", function()
        -- On ne lance pas vraiment pour ne pas bloquer
        return TextInput ~= nil
    end)
    results = results .. "TextInput existe ........ " .. test4a .. "\n"

    local test4b = TryFunction("gma.textinput", function()
        return gma.textinput ~= nil
    end)
    results = results .. "gma.textinput existe .... " .. test4b .. "\n"

    local test4c = TryFunction("PopupInput", function()
        return PopupInput ~= nil
    end)
    results = results .. "PopupInput existe ....... " .. test4c .. "\n"

    local test4d = TryFunction("gma.gui.PopupInput", function()
        return gma.gui and gma.gui.PopupInput ~= nil
    end)
    results = results .. "gma.gui.PopupInput ...... " .. test4d .. "\n"

    -- Test 5: Vérifier les modules disponibles
    results = results .. "\n--- Test Modules ---\n"

    local test5a = TryFunction("gma", function()
        return gma ~= nil
    end)
    results = results .. "gma module .............. " .. test5a .. "\n"

    local test5b = TryFunction("gma.gui", function()
        return gma.gui ~= nil
    end)
    results = results .. "gma.gui module .......... " .. test5b .. "\n"

    local test5c = TryFunction("gma.show", function()
        return gma.show ~= nil
    end)
    results = results .. "gma.show module ......... " .. test5c .. "\n"

    local test5d = TryFunction("gma.user", function()
        return gma.user ~= nil
    end)
    results = results .. "gma.user module ......... " .. test5d .. "\n"

    results = results .. "\n=== FIN DES TESTS ===\n"

    -- Maintenant, afficher les résultats avec la méthode qui fonctionne
    -- Essayer toutes les méthodes d'output

    pcall(function() gma.feedback(results) end)
    pcall(function() gma.echo(results) end)
    pcall(function() Printf(results) end)
    pcall(function() Echo(results) end)
    pcall(function() print(results) end)

    -- En dernier recours, écrire dans un fichier
    -- (si aucune output ne fonctionne)
    pcall(function()
        local file = io.open("C:\\Users\\Super\\Documents\\Progra\\GrandMA3\\GMA3\\Script\\ToKeep\\api_test_results.txt", "w")
        if file then
            file:write(results)
            file:close()
        end
    end)
end

function Execute(display_handle)
    Main(display_handle)
end

return Main
