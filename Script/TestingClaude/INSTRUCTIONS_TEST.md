# Instructions de Test - Erreur 167

## 🔴 Erreur 167 = Problème de Syntaxe API

L'erreur 167 indique que les noms de fonctions ne sont pas corrects.
Nous devons découvrir la syntaxe exacte pour votre version de GrandMA3.

---

## 🧪 ÉTAPE 1: Test Ultra Simple

### Exécuter `plugin_ultra_simple.lua`

1. **Copiez** tout le contenu de `plugin_ultra_simple.lua`
2. **Créez** un nouveau plugin dans GrandMA3
3. **Collez** le code dans l'éditeur Lua
4. **Sauvegardez** le plugin
5. **Exécutez-le** en cliquant dessus

### Que va-t-il se passer?

- Si **aucune erreur**: Le système de plugins fonctionne!
- Si **erreur**: Notez le numéro d'erreur exact

### Où voir les résultats?

Le plugin créera un fichier:
```
C:\Users\Super\Documents\Progra\GrandMA3\GMA3\Script\ToKeep\plugin_output.txt
```

**Ouvrez ce fichier** et copiez son contenu.

---

## 🧪 ÉTAPE 2: Test de Découverte API

### Exécuter `plugin_discover_api.lua`

1. **Copiez** tout le contenu de `plugin_discover_api.lua`
2. **Créez** un nouveau plugin dans GrandMA3
3. **Collez** le code
4. **Exécutez-le**

### Résultats attendus

Le plugin testera toutes les variantes de syntaxe:
- `Printf()` vs `gma.Printf()`
- `Echo()` vs `gma.echo()`
- `Cmd()` vs `gma.cmd()`
- Etc.

Les résultats s'afficheront dans:
1. La Command Line Feedback (si ça fonctionne)
2. Le fichier `api_test_results.txt` (sinon)

---

## 🎯 ÉTAPE 3: Consulter les Exemples GrandMA3

### Méthode A: Plugins d'Exemple Fournis

GrandMA3 inclut des plugins d'exemple. Pour les trouver:

1. Dans GrandMA3, ouvrez la **Plugins Pool**
2. Cherchez des plugins **pré-installés** ou **d'exemple**
3. **Éditez** un plugin existant pour voir son code
4. **Copiez** la syntaxe exacte qu'ils utilisent

### Méthode B: Documentation HelpLua

Dans la ligne de commande GrandMA3, tapez:
```
HelpLua
```

Cela génère:
```
C:\ProgramData\MA Lighting Technologies\grandma3\gma3_library\grandMA3_lua_functions.txt
```

**Ouvrez ce fichier** et cherchez:
- Comment afficher des messages (feedback/echo/printf)
- Comment demander input utilisateur (textinput/popup)
- Comment exécuter des commandes (cmd)

### Méthode C: Templates de Code

Dans l'éditeur de plugin GrandMA3:
1. Cliquez sur **"Code Templates"**
2. Parcourez les exemples fournis
3. Copiez la syntaxe utilisée dans les templates

---

## 📋 Checklist de Diagnostic

Après avoir testé, répondez à ces questions:

- [ ] `plugin_ultra_simple.lua` s'exécute sans erreur?
- [ ] Le fichier `plugin_output.txt` a été créé?
- [ ] Que contient `plugin_output.txt`?
- [ ] `plugin_discover_api.lua` s'exécute sans erreur?
- [ ] Quelles fonctions affichent "OK"?
- [ ] Quelles fonctions affichent "ERREUR"?
- [ ] Quelle est votre version exacte de GrandMA3? (Menu > About)
- [ ] Avez-vous trouvé le fichier `grandMA3_lua_functions.txt`?

---

## 🔍 Informations à me Fournir

Pour que je puisse créer un plugin qui fonctionne, envoyez-moi:

### 1. Version de GrandMA3
```
Menu > About > Version: ?
```

### 2. Contenu du fichier plugin_output.txt
```
Copiez tout le contenu ici
```

### 3. Résultats des tests API (si disponible)
```
Quelles fonctions affichent "OK"?
```

### 4. Extrait de grandMA3_lua_functions.txt
Si vous avez généré ce fichier, copiez les 50 premières lignes environ.

---

## 💡 Solutions Possibles

Selon votre version, la syntaxe correcte pourrait être:

### Variante 1: Préfixe gma.
```lua
gma.feedback("Message")
gma.echo("Message")
gma.cmd("Store Preset 1")
gma.sleep(0.1)
```

### Variante 2: Sans préfixe
```lua
Printf("Message\n")
Echo("Message")
Cmd("Store Preset 1")
Sleep(100)
```

### Variante 3: Module gma.user.
```lua
gma.user.feedback("Message")
gma.user.textinput("Titre", "Message")
```

### Variante 4: Avec handle
```lua
function Execute(display_handle)
    display_handle:Echo("Message")
    display_handle:Cmd("Store Preset 1")
end
```

---

## 🆘 Si les Tests ne Fonctionnent Pas

Si même `plugin_ultra_simple.lua` donne une erreur:

### 1. Vérifiez la Structure du Plugin

Dans l'éditeur de plugin, assurez-vous que:
- Le plugin a un **Nom**
- Il a au moins un **Component** (Lua)
- Le code est dans le **Component**, pas ailleurs

### 2. Testez avec Lua Basique

Créez un plugin avec juste:
```lua
function Main()
    return true
end

return Main
```

Si cela fonctionne, ajoutez progressivement du code.

### 3. Vérifiez les Permissions

Certains plugins nécessitent des **User Rights** spécifiques:
- Dans l'éditeur de plugin
- Vérifiez les paramètres de **User Rights**
- Essayez avec tous les droits activés

### 4. Consultez le Log Système

Dans GrandMA3:
```
Menu > System > Log
```

Regardez les messages d'erreur détaillés.

---

## 📞 Prochaine Étape

**Exécutez ces deux plugins de test et envoyez-moi les résultats.**

Avec ces informations, je pourrai créer un plugin fonctionnel adapté à votre version spécifique de GrandMA3!

---

Créé le: 2025-01-17
