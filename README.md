# Steve Aimé — Portfolio IT et observabilité

Portfolio statique trilingue **français / anglais / néerlandais**, sur une seule page : présentation, expertises, réalisations, parcours et contact. HTML, CSS et JavaScript minimal, sans dépendance externe ni compilation.

Adresse publique configurée : **https://looker20.github.io/learn-github/**. Suivre la publication dans l’onglet **Actions** du dépôt.

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

## Choisir la langue

Le bouton **Menu**, sur téléphone comme sur ordinateur, ouvre un panneau commun contenant les liens de navigation, le choix de langue **Français / English / Nederlands** et l’apparence **Clair / Sombre**. La langue et l’apparence restent à l’intérieur de ce menu. Le panneau se ferme avec Échap, un clic extérieur, le choix d’une section ou la sortie du focus ; les réglages restent accessibles par défilement sur un écran en paysage.

Le changement de langue traduit le contenu, les libellés accessibles, le titre et la description, sans changer d’URL ni recharger la page. Les détails des projets et le focus sont conservés.

Au premier accès, le site utilise la première langue prise en charge dans les préférences du navigateur (dont en-GB, nl-BE et fr-BE), sinon le français. Le choix manuel est conservé dans `localStorage` sous `portfolio-language` et devient prioritaire. Si le stockage est bloqué, le changement fonctionne pour la visite en cours. Sans JavaScript, le contenu français et la navigation restent lisibles ; le menu de langue est masqué.

## Apparence et lisibilité

Le sélecteur d’apparence propose **Clair / Sombre**. Le mode clair emploie des tons pierre et sauge ; le mode sombre des tons ardoise et vert doux. Au premier accès, la préférence système est utilisée. Le choix manuel, mémorisé localement sous `portfolio-theme`, devient prioritaire. Le thème reste identique au changement de langue et fonctionne pour la visite même si le stockage est bloqué. Un petit script local initialise le thème avant le CSS pour éviter un éclair clair au chargement.

Les textes courants font 17 à 18 pixels et les textes secondaires au moins 14 pixels. Les contrastes sont vérifiés dans les deux modes.

L’en-tête reste compact sur toutes les largeurs. Les contenus suivent le même ordre sur téléphone et ordinateur ; les grilles se présentent en une colonne lorsque la largeur est limitée. L’accueil passe en une colonne sur tablette pour garder les textes et la photo lisibles.

Le bilan affiché est de **2 projets livrés** (ELK, Nagios) et **1 projet en cours** (mesure de productivité liée à l’IA). Les manuels de configuration et d’utilisation ainsi que l’accompagnement sont mentionnés pour ELK ; aucun document privé n’est publié. Les expériences de stage réseau sont présentées séparément et ne sont pas ajoutées à ces compteurs.

Le projet de monitoring applicatif ELK a été déployé et testé sur **OpenShift**, mentionné dans les technologies et la réalisation, dans les trois langues.

## Organisation des fichiers

- `public/index.html` : page unique, avec contenu français de repli.
- `public/assets/translations.js` : traductions anglaises et néerlandaises.
- `public/assets/theme.js` : initialisation du thème avant affichage.
- `public/assets/` : styles, navigation et favicon.
- `scripts/` : aperçu local et vérifications.
- `docs/` : préparation de l’hébergement et bilan de vérification.
- `AGENTS.md`, `plans.md`, `sécurité.md` : consignes, décisions produit et référentiel sécurité.

## Modifier et vérifier

Le portrait d’accueil est la photo fournie par le propriétaire pour correspondre à celle de son profil LinkedIn : JPEG carré de 1372 × 1372 pixels, 114 761 octets, sans EXIF. Il est repris sans nouvelle retouche ni modification du cadrage. Il remplace le précédent portrait génératif. Voir [les informations sur la photo](docs/portrait.md).

Le portrait est affiché sans monogramme superposé. La présentation À propos utilise le nom court **Steve Djieutcheu** en français, anglais et néerlandais.

Le site propose des filtres de réalisations, un indicateur de lecture et un repère de section dans le menu. Les animations d’entrée et de défilement sont finies, sans boucle, et respectent `prefers-reduced-motion`. Sans JavaScript, le portrait, les textes et toutes les réalisations restent visibles. Aucun service tiers n’est ajouté.

Modifier le contenu français dans la page et maintenir les clés et traductions correspondantes dans `public/assets/translations.js`. Les clés sont les textes français exacts, après suppression des espaces de début et de fin. Le moteur modifie les nœuds texte et attributs sans injecter de HTML. Les noms propres et outils restent inchangés si nécessaire. La date de copyright est statique et se met à jour manuellement.

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

Le site ne comporte ni formulaire, compte visiteur, cookies de suivi, outil analytique ni requête tierce au chargement. Seules les préférences de langue et de thème sont enregistrées localement, sans transmission à un tiers. Les liens professionnels ne sont suivis que si activés. L’hébergeur peut conserver ses propres journaux techniques.

## GitHub et publication

Le dépôt est public à la demande du propriétaire. GitHub conserve les sources et l’historique ; GitHub Pages publie le portfolio. Le workflow `.github/workflows/pages.yml` vérifie le projet puis publie **uniquement `public/`**, jamais la racine du dépôt. Les changements de ce dossier sur `main` déclenchent une publication ; un lancement manuel est aussi possible dans Actions. Voir [la configuration d’hébergement](docs/hosting.md) et [le suivi sécurité](sécurité.md).

À chaque modification livrée, actualiser ce README pour décrire le résultat et les éventuelles nouvelles instructions. Effectuer les contrôles adaptés, examiner `git diff` et les fichiers suivis, puis créer un commit explicite et pousser sur GitHub sans force, sauf demande contraire du propriétaire. Ne jamais versionner de secret ; `.gitignore` ne remplace pas la revue des fichiers suivis.

Quand les fichiers du site changent, attendre la réussite du déploiement GitHub Pages et vérifier la version en ligne avant d’annoncer sa publication. Un changement limité au README ou aux consignes est envoyé sur GitHub sans nécessiter de nouveau déploiement du site.

HTTPS est imposé dans les réglages Pages. Les contrôles effectués sont consignés dans [le bilan](docs/verification.md). MFA et récupération restent à confirmer par le propriétaire. Ce workflow ne personnalise pas les en-têtes HTTP gérés par GitHub Pages ; la CSP embarquée reste présente. Les en-têtes locaux ne prouvent pas leur présence en production.
