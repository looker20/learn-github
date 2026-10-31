# Plan du portfolio professionnel

## Objectif et périmètre validés

Créer un portfolio bilingue français/anglais pour les recruteurs et responsables techniques, centré sur les infrastructures IT, l’observabilité et l’automatisation. Présenter également l’expérience DevSecOps de Steve Aimé.

Livrer les fichiers dans le dépôt `looker20/learn-github` et les envoyer sur GitHub. L’hébergement public et le domaine feront l’objet d’une étape ultérieure. Aucun compte visiteur, base de données, formulaire ou serveur de production à administrer.

## Confidentialité du CV

Le CV fourni est une source privée pour rédiger une sélection de contenus professionnels. Ne pas copier le document dans le dépôt, ne pas en produire de transcription intégrale ou de PDF, et ne proposer aucun téléchargement. Ne pas conserver d’extraction intermédiaire. Le téléphone et l’adresse précise ne sont pas publics. L’e-mail et les liens LinkedIn/GitHub sont autorisés.

## Structure et identité

Une page française et une page anglaise avec les mêmes sections et un sélecteur de langue :

1. Accueil : titre, introduction et liens vers les réalisations et le contact.
2. Présentation : synthèse du parcours et intérêts professionnels.
3. Expertises : observabilité, automatisation, réseaux, virtualisation et cloud.
4. Réalisations : supervision applicative chez Infrabel, MPLS chez CAMTEL, FTTH chez TELEINFRA.
5. Parcours : sélection d’expériences, de formations et langues parlées.
6. Contact : e-mail, LinkedIn et GitHub.

Fond clair, bleu profond, accents turquoise, typographie système et monogramme en l’absence de photographie. Aucun résultat chiffré, niveau d’expertise, témoignage ou certification inventé.

## Informations confirmées et limites

- Stage Infrabel : novembre 2024 à avril 2025.
- Analyste adjoint chez Infrabel : depuis septembre 2025. Ne pas lui attribuer automatiquement les missions du stage.
- Bloc complémentaire au master en informatique à l’Université de Mons : 2026–2027, en cours.
- Les formations et outils présentés sont une sélection, sans équivalence de diplôme étrangère inventée.
- Les réalisations sont décrites sans architecture interne, donnée client ni preuve confidentielle.
- Le schéma d’observabilité est conceptuel, pas une représentation du système interne.

## Réalisation

- HTML, CSS et JavaScript minimal, sans framework, paquet ni compilation.
- Fichiers publiables isolés dans `public/` ; ressources locales uniquement.
- Liens relatifs compatibles avec un déploiement sous un préfixe.
- Navigation mobile améliorée par JavaScript, avec liens visibles sans JavaScript.
- Structure sémantique, accès clavier, focus visible et mouvement réduit.
- Titres et descriptions traduits ; domaine définitif requis avant URL canoniques et sitemap.
- En-têtes de production à configurer et vérifier lors de l’hébergement : voir `docs/hosting.md`.

## Vérifications et livraison

- Exécuter `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Verify.ps1`.
- Vérifier les deux langues, les dates, les ancres et les liens.
- Vérifier l’absence du CV, de copies et de coordonnées exclues dans les fichiers publiables et les fichiers destinés à Git.
- Tester le navigateur à 360, 768 et 1280 pixels, le clavier, les détails des projets, le menu, les liens de langue et la lecture sans JavaScript.
- Contrôler les chemins à la racine et sous `/portfolio/` avec le serveur local.
- Documenter les résultats réels et les limites dans `docs/verification.md`.
- Mettre à jour le README et les mesures applicables de `sécurité.md`.
- Examiner le contenu du commit, vérifier le dépôt distant, envoyer sans force et confirmer la révision distante.

## Étape ultérieure : hébergement

Choisir le fournisseur et le domaine, vérifier HTTPS et les en-têtes, confirmer les protections des comptes, puis tester restauration et URL réelle. Un envoi sur GitHub ne constitue pas un déploiement web.
