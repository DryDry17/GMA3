# GrandMA3 Lua API - Référence Rapide

## ✅ Fonctions Confirmées (Toujours Disponibles)

### Entrée/Sortie
```lua
-- Afficher un message dans la Command Line Feedback
gma.feedback("Message")

-- Afficher dans le log système
gma.echo("Message de log")

-- Demander une saisie utilisateur (POPUP)
local input = gma.textinput("Titre", "Message")
-- Retourne: string ou nil si annulé
```

### Exécution de Commandes
```lua
-- Exécuter une commande GrandMA3
gma.cmd("Store Preset 1")
gma.cmd("At Full")
gma.cmd("Go+ Sequence 1")
```

### Timing
```lua
-- Pause en secondes
gma.sleep(0.5)  -- 500ms
gma.sleep(1)    -- 1 seconde
```

### Informations Système
```lua
-- Version du logiciel
local version = gma.show.getvar("Version")

-- Obtenir l'heure actuelle
local time = gma.show.getvar("Time")

-- Nom du show
local showname = gma.show.getvar("ShowName")
```

---

## ❌ Fonctions NON Disponibles (Erreur 228)

Ces fonctions n'existent PAS dans GrandMA3:
```lua
-- ❌ NE PAS UTILISER
gma.gui.MessageBox()     -- N'existe pas
gma.gui.confirm()        -- N'existe pas
gma.PopupInput()         -- N'existe pas
gma.showmessage()        -- N'existe pas
```

**Solution:** Utilisez `gma.textinput()` à la place

---

## 🎯 Exemples d'Utilisation

### Popup de Saisie Simple
```lua
local name = gma.textinput("Entrez un nom", "Nom par defaut")
if name then
    gma.feedback("Nom saisi: " .. name)
else
    gma.feedback("Annule")
end
```

### Confirmation Oui/Non
```lua
local response = gma.textinput("Confirmation", "Tapez 'oui' pour confirmer")
if response and string.lower(response) == "oui" then
    gma.cmd("Store Preset 1")
    gma.feedback("Preset stocke!")
else
    gma.feedback("Annule")
end
```

### Saisie de Nombre
```lua
local input = gma.textinput("Numero de Preset", "Entrez un numero (1-999)")
if input then
    local number = tonumber(input)
    if number and number >= 1 and number <= 999 then
        gma.cmd("Store Preset " .. number)
        gma.feedback("Preset " .. number .. " stocke")
    else
        gma.feedback("Erreur: numero invalide")
    end
end
```

### Sélection Multiple
```lua
local input = gma.textinput("Selection", "Entrez les numeros (ex: 1 3 5)")
if input then
    for num in string.gmatch(input, "%d+") do
        local index = tonumber(num)
        gma.echo("Numero selectionne: " .. index)
        -- Traiter chaque numéro...
    end
end
```

### Exécution avec Gestion d'Erreur
```lua
local success, error = pcall(function()
    gma.cmd("Store Preset 1")
end)

if success then
    gma.feedback("Commande executee avec succes")
else
    gma.feedback("Erreur: " .. tostring(error))
end
```

---

## 📚 Accès aux Objets du Show

### Presets
```lua
-- Obtenir un preset
local preset = gma.show.getobj.preset(4, 1)  -- Pool 4, Index 1

-- Nom du preset
if preset then
    local name = preset.name
    gma.echo("Preset: " .. name)
end
```

### Séquences
```lua
-- Obtenir une séquence
local seq = gma.show.getobj.sequence(1)

if seq then
    gma.echo("Sequence: " .. seq.name)
end
```

### Groupes
```lua
-- Obtenir un groupe
local group = gma.show.getobj.group(1)

if group then
    gma.echo("Group: " .. group.name)
end
```

### Fixtures
```lua
-- Obtenir un fixture
local fixture = gma.show.getobj.fixture(1)

if fixture then
    gma.echo("Fixture ID: " .. fixture.fid)
end
```

---

## 🔍 Débogage

### Afficher les Messages
```lua
-- Dans le feedback (visible par l'utilisateur)
gma.feedback("Message utilisateur")

-- Dans le log système (pour débogage)
gma.echo("Message de debug")
```

### Tracer les Variables
```lua
local myVar = 42
gma.echo("myVar = " .. tostring(myVar))

local myTable = {a = 1, b = 2}
gma.echo("myTable.a = " .. tostring(myTable.a))
```

### Capturer les Erreurs
```lua
local success, error = pcall(function()
    -- Code à tester
    gma.cmd("Invalid Command")
end)

if not success then
    gma.echo("Erreur capturee: " .. tostring(error))
end
```

---

## 🛠️ Codes d'Erreur Courants

| Code | Signification | Solution |
|------|---------------|----------|
| **228** | Fonction API inexistante | Utilisez `gma.textinput()` au lieu de `gma.gui.*` |
| **Nil value** | Variable non initialisée | Vérifiez que la variable existe avant usage |
| **Bad argument** | Type de paramètre incorrect | Vérifiez les types (string, number, etc.) |

---

## 📖 Ressources

### Générer la Documentation Complète
Dans GrandMA3, tapez:
```
HelpLua
```

Cela créera le fichier:
```
C:\ProgramData\MA Lighting Technologies\grandma3\gma3_library\grandMA3_lua_functions.txt
```

Ce fichier contient **TOUTES** les fonctions disponibles dans votre version de GrandMA3.

---

## ⚡ Bonnes Pratiques

1. **Toujours vérifier les retours**
   ```lua
   local input = gma.textinput("Test", "Message")
   if input then
       -- Traiter l'input
   else
       -- Utilisateur a annulé
   end
   ```

2. **Utiliser pcall pour les commandes critiques**
   ```lua
   pcall(function() gma.cmd("Store Preset 1") end)
   ```

3. **Ajouter des feedbacks utilisateur**
   ```lua
   gma.feedback("Operation en cours...")
   -- Code long
   gma.feedback("Operation terminee!")
   ```

4. **Tester les plugins pas à pas**
   ```lua
   gma.echo("Etape 1")
   -- Code
   gma.echo("Etape 2")
   -- Code
   ```

---

Dernière mise à jour: 2025-01-17
