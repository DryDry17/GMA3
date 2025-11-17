# Scripts Popup avec Cases à Cocher - GrandMA3

## Description
Collection de scripts Lua pour GrandMA3 permettant d'afficher des popups avec sélection multiple (cases à cocher simulées).

---

## Scripts Disponibles

### 1. PopupCheckboxes.lua (Version Basique)
**Utilisation:**
- Script simple avec input texte
- Sélection par numéros séparés par des virgules
- 5 options prédéfinies

**Comment utiliser:**
1. Charger le plugin dans GrandMA3
2. Exécuter le script
3. Entrer les numéros (ex: `1,3,5`)
4. Valider

**Exemple:**
```
Input: 1,2,4
Résultat: Options 1, 2 et 4 sélectionnées
```

---

### 2. PopupCheckboxesAdvanced.lua (Version Avancée)
**Utilisation:**
- Interface plus complète avec 8 options
- Support de la commande "all"
- Confirmation avant exécution
- Mode Blind automatique

**Fonctionnalités:**
- ✓ Générer Presets Dimmer (1.1-1.5)
- ✓ Générer Presets Couleur (4.1-4.15)
- ✓ Générer Presets Position (2.x)
- ✓ Générer Groupes (L1-L6)
- ✓ Générer Séquences Couleur
- ✓ Générer Séquences Dimmer
- ✓ Générer Appearances
- ✓ Tout nettoyer (ClearAll)

**Comment utiliser:**
1. Exécuter le script
2. Entrer les numéros ou 'all' pour tout sélectionner
3. Confirmer l'action
4. Le script s'exécute en mode Blind

**Exemples:**
```
Input: 1,2,4     → Génère Dimmer, Couleur et Groupes
Input: all       → Exécute toutes les actions
Input: cancel    → Annule l'opération
```

---

### 3. PopupSimple.lua (Version Optimisée)
**Utilisation:**
- Interface visuelle améliorée
- 6 options principales
- Génération complète de show
- Logs détaillés dans Command Line

**Fonctionnalités:**
1. Dimmer Presets (5 presets: 0%, 25%, 50%, 75%, 100%)
2. Color Presets (5 couleurs: White, Red, Green, Blue, Yellow)
3. Position Presets (Position Home)
4. Groups L1-L6
5. Sequences
6. Appearances

**Comment utiliser:**
1. Exécuter le script
2. Choisir les options (ex: `1,2,4` ou `all`)
3. Confirmer
4. Vérifier les logs dans la Command Line

---

## Installation

1. Copier les fichiers .lua dans le dossier:
   ```
   C:\ProgramData\MALightingTechnology\gma3_library\datapools\plugins\
   ```

2. Dans GrandMA3:
   - Aller dans le menu **Plugins**
   - Importer le script
   - Assigner à un bouton/executor si nécessaire

---

## Syntaxe d'Input

| Input | Description |
|-------|-------------|
| `1` | Sélectionne l'option 1 |
| `1,3,5` | Sélectionne les options 1, 3 et 5 |
| `all` | Sélectionne toutes les options |
| `cancel` | Annule l'opération |
| *(vide)* | Annule l'opération |

---

## Fonctions API GrandMA3 Utilisées

### Popups et Dialogs
```lua
gma.textinput("Titre", "Message")  -- Input texte
gma.gui.msgbox("Titre", "Message") -- Message box
gma.gui.confirm("Titre", "Message") -- Confirmation Yes/No
```

### Commandes
```lua
Cmd('Store Preset 1.1')           -- Sauvegarder preset
Echo("Message")                   -- Afficher dans Command Line
```

---

## Personnalisation

### Ajouter une nouvelle option:
```lua
-- Dans la table items:
{
    label = "Ma nouvelle option",
    action = maFonction
}

-- Créer la fonction:
function maFonction()
    Cmd('Votre commande ici')
    print("✓ Action exécutée")
end
```

### Modifier les couleurs/presets:
Éditer les tables de données dans les fonctions `generateColorPresets()` ou similaires.

---

## Exemples d'Utilisation Pratiques

### Exemple 1: Setup rapide d'un show
```lua
-- Utiliser PopupSimple.lua
-- Input: all
-- Résultat: Tout le setup de base est créé
```

### Exemple 2: Seulement les couleurs
```lua
-- Utiliser PopupSimple.lua
-- Input: 2,6
-- Résultat: Color Presets + Appearances
```

### Exemple 3: Setup partiel
```lua
-- Utiliser PopupCheckboxesAdvanced.lua
-- Input: 1,4,5
-- Résultat: Dimmer + Groups + Sequences Color
```

---

## Dépannage

### Le script ne s'exécute pas:
- Vérifier que le fichier est bien dans le dossier plugins
- Vérifier la syntaxe Lua (pas d'erreurs)
- Consulter la Command Line pour les erreurs

### Les presets ne sont pas créés:
- Vérifier que vous avez des fixtures patchées
- Vérifier que les groupes existent
- Utiliser le mode Blind pour tester

### L'input ne fonctionne pas:
- Utiliser uniquement des chiffres et virgules
- Pas d'espaces
- Respecter la casse pour 'all' et 'cancel'

---

## Notes Importantes

1. **Mode Blind**: Les scripts utilisent le mode Blind pour ne pas affecter le show live
2. **Overwrite**: Les commandes utilisent `/Overwrite` pour remplacer les éléments existants
3. **Groupes**: Certains scripts nécessitent que les groupes 1-6 existent
4. **Backup**: Toujours sauvegarder votre show avant d'exécuter des scripts

---

## Version
- Version: 1.0
- Date: 2025-11-16
- Compatibilité: GrandMA3 (toutes versions)

---

## Support
Pour toute question ou personnalisation, consulter:
- Documentation GrandMA3 Lua API
- Forum GrandMA3 Community
- Help desk MA Lighting
