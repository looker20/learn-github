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
4. Réalisations : ELK livré avec manuels et accompagnement, Nagios livré, mesure de productivité IA en cours ; expériences MPLS et FTTH présentées séparément.
5. Parcours : sélection d’expériences, de formations et langues parlées.
6. Contact : e-mail, LinkedIn et GitHub.

Dans la présentation À propos, utiliser le nom court « Steve Djieutcheu ». Le portrait est affiché sans monogramme superposé.

Deux modes sélectionnables : clair en tons pierre/sauge et sombre en tons ardoise/vert doux. Textes courants de 17 à 18 pixels, textes secondaires d’au moins 14 pixels. Le choix suit d’abord le système puis la préférence manuelle mémorisée, indépendamment de la langue. La photo fournie pour correspondre au profil LinkedIn remplace le portrait retouché à l’accueil : même cadrage carré sur téléphone et ordinateur, aucune nouvelle retouche ni monogramme. Le fichier source reste dans son emplacement personnel ; seule la photo autorisée est copiée dans les ressources du site. Aucun résultat chiffré, niveau d’expertise, témoignage ou certification inventé.

## Informations confirmées et limites

- Stage Infrabel : novembre 2024 à avril 2025.
- Analyste adjoint chez Infrabel : depuis septembre 2025. Ne pas lui attribuer automatiquement les missions du stage.
- Bloc complémentaire au master en informatique à l’Université de Mons : 2026–2027, en cours.
- Les formations et outils présentés sont une sélection, sans équivalence de diplôme étrangère inventée.
- Les réalisations sont décrites sans architecture interne, donnée client ni preuve confidentielle.
- Le schéma d’observabilité est conceptuel, pas une représentation du système interne.
- Confirmé par le propriétaire : deux projets livrés, ELK et Nagios ; un projet en cours sur l’impact de l’usage de l’IA par les équipes de développement sur leur productivité.
- La livraison ELK inclut un manuel de configuration, un manuel d’utilisation et une aide à la prise en main. Les documents ne sont pas fournis pour publication : les présenter sans lien de téléchargement fictif.
- Le propriétaire confirme que le déploiement et les tests du monitoring applicatif ont été réalisés sur OpenShift. Présenter cette plateforme dans les technologies et la réalisation ELK, sans inventer de version, de topologie ou de procédure interne.
- Aucun employeur, calendrier, résultat chiffré ou méthodologie supplémentaire n’est attribué aux nouveaux projets sans confirmation. Les stages réseau sont hors de ces compteurs.

## Réalisation

- HTML, CSS et JavaScript minimal, sans framework, paquet ni compilation.
- Traductions éditoriales locales, langue du navigateur au premier accès, choix manuel mémorisé et prioritaire. Français de repli si la langue est inconnue ou JavaScript désactivé.
- Fichiers publiables isolés dans `public/` ; ressources locales uniquement.
- Liens relatifs compatibles avec un déploiement sous un préfixe.
- Menu unique repliable sur tous les écrans, regroupant navigation, langue et apparence. Réglages masqués tant que le menu est fermé ; fermeture par Échap, clic extérieur ou sortie du focus. Le panneau défile sur écran court. Sans JavaScript, les liens restent visibles et les réglages inactifs sont masqués.
- Même ordre du contenu à toutes les largeurs, grilles ramenées à une colonne sur téléphone et accueil à une colonne sur tablette ; en-tête compact sans rangée de réglages séparée.
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
