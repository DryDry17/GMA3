# Plugins GrandMA3 - Guide d'Utilisation

## 📁 Fichiers Disponibles

### 1. `confirm_popup.lua`
Bibliothèque de fonctions pour créer des popups (confirmation, saisie, messages).

### 2. `plugin_checkboxes.lua`
Plugin basique avec sélection par numéros.

### 3. `plugin_checkbox_advanced.lua` ⭐ **RECOMMANDÉ**
Plugin avancé avec interface complète et gestion d'erreurs.

---

## 🚀 Installation dans GrandMA3

### Méthode 1: Via l'interface graphique

1. Ouvrez la **Plugins Pool** dans GrandMA3
2. Cliquez sur un slot vide pour créer un nouveau plugin
3. Dans "Edit UserPlugin":
   - **Name**: Sélection Multiple
   - **Author**: Votre nom
   - **Version**: 2.0
4. Ajoutez un nouveau **Component** (Lua)
5. Copiez le code de `plugin_checkbox_advanced.lua`
6. Collez-le dans l'éditeur Lua
7. Sauvegardez le plugin

### Méthode 2: Import de fichier

1. Placez les fichiers `.lua` dans le dossier des plugins:
   ```
   C:\ProgramData\MA Lighting Technologies\grandma3\gma3_library\datapools\plugins\
   ```

2. Dans GrandMA3, tapez:
   ```
   Import "plugin_checkbox_advanced.lua" At Plugin 1
   ```

---

## 📖 Utilisation du Plugin

### Lancement

**Option 1:** Cliquez sur le plugin dans la Plugins Pool

**Option 2:** Ligne de commande:
```
Plugin "Sélection Multiple"
```

**Option 3:** Assignez-le à un executor:
```
Assign Plugin "Sélection Multiple" At Executor 201
```

### Interface Utilisateur

1. **Premier dialogue**: Liste des actions disponibles
   ```
   [1] Clear Programmer → Effacer le programmeur
   [2] Store Preset → Stocker un preset couleur
   [3] Update Sequence → Mettre à jour la séquence 1
   [4] Select All Fixtures → Sélectionner tous les projecteurs
   [5] At Full → Mettre l'intensité à 100%
   ```

2. **Saisie**: Entrez les numéros séparés par des espaces
   ```
   Exemple: 1 3 5
   ```

3. **Confirmation**: Vérifiez les actions sélectionnées

4. **Exécution**: Les commandes s'exécutent avec feedback

---

## ⚙️ Personnalisation

### Modifier les Actions

Éditez la table `ACTIONS` dans le plugin:

```lua
local ACTIONS = {
    {
        id = "mon_action",              -- ID unique
        name = "Mon Action",            -- Nom affiché
        description = "Description",    -- Description détaillée
        command = "Go+ Sequence 1",     -- Commande GrandMA3
        enabled = true                  -- Activer/désactiver
    },
    -- Ajoutez d'autres actions...
}
```

### Exemples de Commandes GrandMA3

```lua
-- Contrôle de séquences
command = "Go+ Sequence 1"
command = "Pause Sequence 1"
command = "Off Sequence 1"

-- Sélection
command = "Fixture 1 Thru 10"
command = "Group 1"
command = "SelectAll"

-- Presets
command = "Store Preset 4.1"
command = "Call Preset 4.1"

-- Intensité et attributs
command = "At 50"
command = "At Full"

-- Macros
command = "Macro 1"

-- Vues
command = "View 1.1"
```

---

## 🎯 Scénarios d'Utilisation

### Scénario 1: Initialisation de Show
```
Actions sélectionnées: 1, 4, 5
→ Clear Programmer
→ Select All Fixtures
→ At Full
```

### Scénario 2: Sauvegarde Rapide
```
Actions sélectionnées: 2, 3
→ Store Preset
→ Update Sequence
```

### Scénario 3: Reset Complet
```
Actions sélectionnées: 1
→ Clear Programmer
```

---

## 🐛 Débogage

### Afficher les logs
Les messages s'affichent dans la **Command Line Feedback**.

### Vérifier les fonctions disponibles
Tapez dans GrandMA3:
```
HelpLua
```
Cela génère `grandMA3_lua_functions.txt` dans:
```
C:\ProgramData\MA Lighting Technologies\grandma3\gma3_library\
```

### Tester une commande
Avant de l'ajouter au plugin, testez-la dans la ligne de commande:
```
Store Preset 4.1
```

---

## 📝 Notes Importantes

⚠️ **Permissions**: Certaines commandes peuvent nécessiter des droits utilisateur spécifiques.

⚠️ **Numérotation**: Assurez-vous que les presets, séquences, etc. existent avant d'exécuter les commandes.

⚠️ **Timing**: Le délai entre les commandes est de 0.2s par défaut. Modifiez avec:
```lua
gma.sleep(0.5)  -- 500ms de pause
```

⚠️ **Compatibilité**: Testé sur GrandMA3 v2.3+

---

## 🔄 Versions

- **v1.0** (plugin_checkboxes.lua): Version basique
- **v2.0** (plugin_checkbox_advanced.lua): Interface améliorée avec gestion d'erreurs

---

## 📧 Support

Pour plus d'informations:
- Documentation officielle: https://help.malighting.com/
- Commande HelpLua pour la référence API complète

---

Bonne utilisation! 🎭
