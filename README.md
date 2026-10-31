# Steve Aimé — Portfolio IT et observabilité

Portfolio statique bilingue **français / anglais** : présentation, expertises, réalisations, parcours et contact. HTML, CSS et JavaScript minimal, sans dépendance externe ni compilation.

## Ouvrir le site

Ouvrir `public/index.html` dans un navigateur. Pour un aperçu HTTP et les protections locales, utiliser PowerShell 5.1 ou supérieur :

```powershell
git clone https://github.com/looker20/learn-github.git
cd learn-github
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Serve.ps1
```

Visiter **http://127.0.0.1:8080/**. Arrêter avec Ctrl+C. Ce serveur écoute uniquement sur l’ordinateur local et ne doit pas servir en production. `ExecutionPolicy Bypass` s’applique uniquement au processus lancé, sans modification permanente des réglages du poste ; respecter toute politique administrée.

Le même site est accessible sous **http://127.0.0.1:8080/portfolio/** pour vérifier les chemins relatifs. Autre port : `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Serve.ps1 -Port 8081`.

Sur un autre système, tout serveur de fichiers statiques peut servir `public/`. Aucun secret ou variable d’environnement n’est nécessaire.

## Organisation

- `public/index.html` : version française.
- `public/en/index.html` : version anglaise.
- `public/assets/` : styles, navigation et favicon.
- `scripts/` : aperçu local et vérifications.
- `docs/` : préparation de l’hébergement et bilan de vérification.
- `AGENTS.md`, `plans.md`, `sécurité.md` : consignes, décisions produit et référentiel sécurité.

## Modifier et vérifier

Modifier les textes dans les deux pages, conserver les ancres communes et les liens relatifs. Le CSS et le JavaScript sont partagés. La date de copyright est statique et se met à jour manuellement.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Verify.ps1
```

Le contrôle vérifie ressources locales, ancres, métadonnées, destinations externes et exclusion des documents privés. Il complète les essais navigateur de `docs/verification.md` ; il ne constitue pas un audit exhaustif.

Les essais navigateur utilisent Chrome ou Edge installé, le serveur local et un profil jetable dans `.local/`. Aucune dépendance à installer :

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Test-Browser.ps1
```

## Confidentialité

Le CV sert uniquement de source privée. **Il n’est pas inclus, publié ou téléchargeable.** Ne pas ajouter d’original, copie, PDF ou transcription intégrale. L’adresse précise et le téléphone sont exclus. La sélection d’informations professionnelles, l’e-mail et les liens professionnels sont publics dans le code.

Le site ne comporte ni formulaire, compte visiteur, cookies de suivi, outil analytique ni requête tierce au chargement. Les liens professionnels ne sont suivis que si activés. Un futur hébergeur peut conserver ses propres journaux techniques.

## GitHub et futur hébergement

GitHub conserve les sources et leur historique. Le site n’est pas encore déployé. Pour l’héberger, publier **uniquement le contenu de `public/`**, jamais la racine du dépôt. Voir [la préparation de l’hébergement](docs/hosting.md) et [le suivi sécurité](sécurité.md).

Après modification : effectuer les contrôles, examiner `git diff`, créer un commit explicite puis envoyer sans force. Ne jamais versionner de secret. Vérifier les fichiers suivis en plus de `.gitignore`.

Les protections HTTPS, MFA, domaine et en-têtes de production seront vérifiées lors de la mise en ligne. Les en-têtes du serveur local ne prouvent pas leur présence en production.
