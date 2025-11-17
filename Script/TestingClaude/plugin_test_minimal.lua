--[[
Plugin de Test Minimal - GrandMA3
Version: 1.0

Ce plugin teste les fonctions de base une par une pour identifier
quelle fonction fonctionne dans votre version de GrandMA3.
--]]

function Main()
    -- Test 1: Printf
    local test1 = pcall(function()
        Printf("=== TEST DES FONCTIONS API ===\n")
    end)

    if not test1 then
        -- Si Printf ne fonctionne pas, essayer Echo
        pcall(function() Echo("Test avec Echo") end)
        return
    end

    Printf("\n")
    Printf("Test 1: Printf() ............... OK\n")

    -- Test 2: Echo
    local test2 = pcall(function()
        Echo("Test Echo")
    end)
    Printf("Test 2: Echo() ................. %s\n", test2 and "OK" or "ERREUR")

    -- Test 3: TextInput
    local test3 = false
    local input = nil
    pcall(function()
        input = TextInput("Test TextInput", "Cliquez OK pour continuer")
        test3 = true
    end)
    Printf("Test 3: TextInput() ............ %s\n", test3 and "OK" or "ERREUR")

    -- Test 4: Confirm
    local test4 = false
    pcall(function()
        local result = Confirm("Test Confirm", "Cliquez OK")
        test4 = true
    end)
    Printf("Test 4: Confirm() .............. %s\n", test4 and "OK" or "ERREUR")

    -- Test 5: MessageBox
    local test5 = false
    pcall(function()
        MessageBox({title = "Test", message = "Test MessageBox"})
        test5 = true
    end)
    Printf("Test 5: MessageBox() ........... %s\n", test5 and "OK" or "ERREUR")

    -- Test 6: Cmd
    local test6 = false
    pcall(function()
        Cmd("ClearAll")
        test6 = true
    end)
    Printf("Test 6: Cmd() .................. %s\n", test6 and "OK" or "ERREUR")

    -- Test 7: Sleep
    local test7 = false
    pcall(function()
        Sleep(100)
        test7 = true
    end)
    Printf("Test 7: Sleep() ................ %s\n", test7 and "OK" or "ERREUR")

    Printf("\n")
    Printf("=== FIN DES TESTS ===\n")
    Printf("\n")

    -- Résumé
    local okCount = 0
    if test1 then okCount = okCount + 1 end
    if test2 then okCount = okCount + 1 end
    if test3 then okCount = okCount + 1 end
    if test4 then okCount = okCount + 1 end
    if test5 then okCount = okCount + 1 end
    if test6 then okCount = okCount + 1 end
    if test7 then okCount = okCount + 1 end

    Printf("Resultat: %d/7 fonctions disponibles\n", okCount)
    Printf("\n")
    Printf("Copiez ce resultat et envoyez-le\n")
end

function Execute(handle)
    Main()
end

return Main
