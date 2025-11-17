# Guide de Débogage - Plugins GrandMA3

## 🔴 Erreurs Courantes et Solutions

### Erreur 228: "Attempt to call a nil value"
**Cause**: Fonction API inexistante

**Solutions**:
- ❌ `gma.gui.MessageBox()` → ✅ `MessageBox()`
- ❌ `gma.confirm()` → ✅ `Confirm()`

---

### Erreur 191: "Bad argument"
**Cause**: Préfixe `gma.` incorrect pour les fonctions Object-Free

**Solutions**:
| ❌ Incorrect | ✅ Correct |
|-------------|-----------|
| `gma.textinput()` | `TextInput()` |
| `gma.echo()` | `Echo()` ou `Printf()` |
| `gma.feedback()` | `Printf()` |
| `gma.cmd()` | `Cmd()` |
| `gma.sleep()` | `Sleep()` |

---

## ✅ Fonctions API Confirmées

### Entrée Utilisateur

#### TextInput()
```lua
-- Syntaxe de base
local input = TextInput("Titre", "Message")

-- Avec valeur par défaut
local input = TextInput("Titre", "Message", "Valeur par defaut")

-- Vérifier si annulé
if input then
    Printf("Vous avez saisi: %s\n", input)
else
    Printf("Annule\n")
end
```

#### Confirm()
```lua
-- Syntaxe de base
local result = Confirm("Titre", "Message de confirmation")

-- result est true si OK, false si annulé
if result then
    Printf("Confirme!\n")
else
    Printf("Annule\n")
end
```

#### MessageBox()
```lua
-- Afficher un message simple
MessageBox({
    title = "Information",
    message = "Ceci est un message",
    icon = "info"
})

-- Note: La syntaxe exacte peut varier selon la version
```

### Sortie et Affichage

#### Printf()
```lua
-- Afficher un message formaté
Printf("Message simple\n")
Printf("Valeur: %d\n", 42)
Printf("Texte: %s, Nombre: %d\n", "hello", 123)
```

#### Echo()
```lua
-- Afficher dans le log
Echo("Message de log")
```

### Exécution de Commandes

#### Cmd()
```lua
-- Exécuter une commande GrandMA3
Cmd("Store Preset 1")
Cmd("At Full")
Cmd("Go+ Sequence 1")

-- Avec gestion d'erreur
local success = pcall(function()
    Cmd("Store Preset 1")
end)

if success then
    Printf("Commande executee\n")
else
    Printf("Erreur d'execution\n")
end
```

### Timing

#### Sleep()
```lua
-- Pause en millisecondes
Sleep(100)   -- 100ms
Sleep(1000)  -- 1 seconde
Sleep(500)   -- 500ms
```

---

## 🧪 Méthode de Test

### Étape 1: Tester les Fonctions de Base

Créez un plugin simple pour tester chaque fonction:

```lua
function Main()
    -- Test 1: Printf
    Printf("Test 1: Printf fonctionne\n")

    -- Test 2: TextInput
    local input = TextInput("Test", "Entrez quelque chose")
    if input then
        Printf("Vous avez saisi: %s\n", input)
    end

    -- Test 3: Confirm
    local result = Confirm("Test", "Confirmez-vous?")
    Printf("Resultat: %s\n", tostring(result))

    -- Test 4: Cmd
    Printf("Test de commande...\n")
    Cmd("ClearAll")

    -- Test 5: Sleep
    Printf("Attente 1 seconde...\n")
    Sleep(1000)
    Printf("Termine!\n")
end

return Main
```

### Étape 2: Identifier la Fonction Problématique

Si une erreur survient, ajoutez des Printf() pour tracer:

```lua
function Main()
    Printf("Debut du plugin\n")

    Printf("Avant TextInput\n")
    local input = TextInput("Test", "Message")
    Printf("Apres TextInput\n")

    if input then
        Printf("Input recu: %s\n", input)
    else
        Printf("Input annule\n")
    end

    Printf("Fin du plugin\n")
end
```

### Étape 3: Utiliser pcall pour Capturer les Erreurs

```lua
function SafeExecute()
    local success, error = pcall(function()
        -- Votre code ici
        local input = TextInput("Test", "Message")
        Printf("Input: %s\n", tostring(input))
    end)

    if not success then
        Printf("ERREUR CAPTUREE: %s\n", tostring(error))
    end
end
```

---

## 🔍 Diagnostic des Erreurs

### Si TextInput() ne fonctionne pas

Essayez ces alternatives:

```lua
-- Alternative 1: PopupInput
local input = PopupInput({title = "Test", message = "Message"})

-- Alternative 2: UserInput (si disponible)
local input = UserInput("Test", "Message")

-- Alternative 3: Via commande
Cmd('Set $myVar "default"')
-- Puis l'utilisateur édite dans la ligne de commande
```

### Si Confirm() ne fonctionne pas

```lua
-- Alternative: Utiliser TextInput
local response = TextInput("Confirmation", "Tapez 'oui' pour confirmer")
local confirmed = response and (string.lower(response) == "oui" or string.lower(response) == "yes")
```

---

## 📖 Obtenir la Documentation Complète

### Méthode 1: Commande HelpLua

Dans GrandMA3, tapez:
```
HelpLua
```

Cela génère:
```
C:\ProgramData\MA Lighting Technologies\grandma3\gma3_library\grandMA3_lua_functions.txt
```

Ce fichier contient **TOUTES** les fonctions disponibles avec leur syntaxe exacte.

### Méthode 2: Code Templates dans l'Éditeur

1. Ouvrez l'éditeur de plugin
2. Cliquez sur "Code Templates"
3. Vous verrez des exemples de code avec les fonctions correctes

### Méthode 3: API Description

Dans l'éditeur de plugin:
1. Cliquez sur "API Description"
2. Parcourez les fonctions disponibles
3. Notez la syntaxe exacte

---

## 🎯 Checklist de Débogage

Avant de demander de l'aide, vérifiez:

- [ ] J'ai généré `grandMA3_lua_functions.txt` avec HelpLua
- [ ] J'ai vérifié que la fonction existe dans ma version
- [ ] J'utilise les fonctions sans préfixe `gma.` (ex: `Printf()` pas `gma.Printf()`)
- [ ] J'ai testé avec un plugin minimal
- [ ] J'ai ajouté des Printf() pour tracer l'exécution
- [ ] J'ai utilisé pcall() pour capturer les erreurs
- [ ] J'ai vérifié les majuscules (ex: `TextInput` pas `textInput`)

---

## 💡 Conseils de Développement

### 1. Développement Incrémental

Commencez simple et ajoutez progressivement:

```lua
-- Version 1: Juste un message
function Main()
    Printf("Hello World\n")
end

-- Version 2: Ajouter une saisie
function Main()
    local input = TextInput("Test", "Entrez quelque chose")
    Printf("Vous avez saisi: %s\n", tostring(input))
end

-- Version 3: Ajouter une commande
function Main()
    local input = TextInput("Test", "Entrez un numero")
    if input then
        Cmd("Store Preset " .. input)
    end
end
```

### 2. Toujours Vérifier les Retours

```lua
-- ❌ Mauvais
local input = TextInput("Test", "Message")
Cmd("Store Preset " .. input)  -- input peut être nil!

-- ✅ Bon
local input = TextInput("Test", "Message")
if input then
    Cmd("Store Preset " .. input)
else
    Printf("Annule par l'utilisateur\n")
end
```

### 3. Logger l'Exécution

```lua
function Main()
    Printf("=== DEBUT DU PLUGIN ===\n")

    Printf("Etape 1: Demande de saisie\n")
    local input = TextInput("Test", "Message")

    Printf("Etape 2: Verification\n")
    if not input then
        Printf("ERREUR: Pas d'input\n")
        return
    end

    Printf("Etape 3: Execution\n")
    Cmd("Store Preset " .. input)

    Printf("=== FIN DU PLUGIN ===\n")
end
```

---

## 🆘 Si Rien ne Fonctionne

Si vous avez toujours des erreurs:

1. **Vérifiez votre version de GrandMA3**
   - L'API peut varier entre versions
   - Certaines fonctions sont apparues dans des versions récentes

2. **Consultez le fichier généré par HelpLua**
   - C'est LA référence pour votre version spécifique

3. **Regardez les plugins d'exemple**
   - GrandMA3 inclut des plugins d'exemple
   - Copiez leur syntaxe exacte

4. **Testez dans la ligne de commande Lua**
   ```
   Lua "Printf('Test\\n')"
   ```

---

Dernière mise à jour: 2025-01-17
Version GrandMA3: 2.3+
