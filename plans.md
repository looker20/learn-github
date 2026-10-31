# Plan du portfolio professionnel

## Objectif et périmètre validés

Créer un portfolio trilingue français/anglais/néerlandais pour les recruteurs et responsables techniques, centré sur les infrastructures IT, l’observabilité et l’automatisation. Présenter également l’expérience DevSecOps de Steve Aimé.

Livrer les fichiers dans le dépôt `looker20/learn-github` et publier `public/` sur GitHub Pages à l’adresse `https://looker20.github.io/learn-github/`. Le propriétaire a demandé de rendre le dépôt public. Aucun compte visiteur, base de données, formulaire ou serveur de production à administrer.

## Confidentialité du CV

Le CV fourni est une source privée pour rédiger une sélection de contenus professionnels. Ne pas copier le document dans le dépôt, ne pas en produire de transcription intégrale ou de PDF, et ne proposer aucun téléchargement. Ne pas conserver d’extraction intermédiaire. Le téléphone et l’adresse précise ne sont pas publics. L’e-mail et les liens LinkedIn/GitHub sont autorisés.

## Structure et identité

Une seule page avec un menu Français / English / Nederlands qui traduit le contenu sur place, sans rechargement, navigation ou changement d’URL :

1. Accueil : titre, introduction et liens vers les réalisations et le contact.
2. Présentation : synthèse du parcours et intérêts professionnels.
3. Expertises : observabilité, automatisation, réseaux, virtualisation et cloud.
4. Réalisations : supervision applicative chez Infrabel, MPLS chez CAMTEL, FTTH chez TELEINFRA.
5. Parcours : sélection d’expériences, de formations et langues parlées.
6. Contact : e-mail, LinkedIn et GitHub.

Fond clair, bleu profond, accents turquoise et typographie système. Portrait professionnel retouché à partir de la photo fournie, intégré à l’accueil ; l’original reste hors du dépôt. Aucun résultat chiffré, niveau d’expertise, témoignage ou certification inventé.

## Informations confirmées et limites

- Stage Infrabel : novembre 2024 à avril 2025.
- Analyste adjoint chez Infrabel : depuis septembre 2025. Ne pas lui attribuer automatiquement les missions du stage.
- Bloc complémentaire au master en informatique à l’Université de Mons : 2026–2027, en cours.
- Les formations et outils présentés sont une sélection, sans équivalence de diplôme étrangère inventée.
- Les réalisations sont décrites sans architecture interne, donnée client ni preuve confidentielle.
- Le schéma d’observabilité est conceptuel, pas une représentation du système interne.

## Réalisation

- HTML, CSS et JavaScript minimal, sans framework, paquet ni compilation.
- Traductions éditoriales locales, langue du navigateur au premier accès, choix manuel mémorisé et prioritaire. Français de repli si la langue est inconnue ou JavaScript désactivé.
- Fichiers publiables isolés dans `public/` ; ressources locales uniquement.
- Liens relatifs compatibles avec un déploiement sous un préfixe.
- Navigation mobile améliorée par JavaScript, avec liens visibles sans JavaScript.
- Animations finies d’entrée et de défilement, survol des cartes, indicateur de lecture et section active. Respect du mouvement réduit ; le contenu n’est pas caché en cas d’échec d’animation.
- Filtres de réalisations utilisables au clavier, avec état et nombre de résultats annoncés ; changement de langue conservant le filtre sélectionné.
- Structure sémantique, accès clavier, focus visible et mouvement réduit.
- Titres et descriptions traduits ; domaine définitif requis avant URL canoniques et sitemap.
- En-têtes de production à configurer et vérifier lors de l’hébergement : voir `docs/hosting.md`.

## Vérifications et livraison

- Exécuter `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Verify.ps1`.
- Vérifier les trois langues, les dates, les ancres et les liens.
- Vérifier l’absence du CV, de copies et de coordonnées exclues dans les fichiers publiables et les fichiers destinés à Git.
- Tester le navigateur à 360, 768 et 1280 pixels, le clavier, les détails des projets, le menu, la traduction sans navigation et la préférence mémorisée ; vérifier le repli français sans JavaScript.
- Contrôler les chemins à la racine et sous `/portfolio/` avec le serveur local.
- Documenter les résultats réels et les limites dans `docs/verification.md`.
- Mettre à jour le README et les mesures applicables de `sécurité.md`.
- Examiner le contenu du commit, vérifier le dépôt distant, envoyer sans force et confirmer la révision distante.

## Hébergement GitHub Pages

Publier depuis `main` avec GitHub Actions, après vérification. Seul `public/` entre dans l’artefact de publication. Vérifier l’URL réelle et distinguer les en-têtes gérés par GitHub de ceux disponibles uniquement en local. Les contrôles de comptes et le test de restauration restent à documenter séparément. Un domaine personnalisé reste facultatif.
