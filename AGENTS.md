# Consignes de travail pour le portfolio professionnel

## Objectif du projet

Créer un portfolio professionnel trilingue français/anglais/néerlandais présentant mon profil d’ingénieur IT orienté infrastructures et observabilité, mes compétences, mes activités, mon parcours et mes réalisations, dont mon expérience DevSecOps.

Conserver le code source et la documentation sur GitHub afin de pouvoir consulter le projet, le récupérer et poursuivre son développement depuis différents ordinateurs.

## Documents de référence

- Lire plans.md avant de développer une fonctionnalité.
- Lire sécurité.md et appliquer les mesures pertinentes.
- Respecter les éventuelles consignes des sous-répertoires.
- Maintenir la documentation cohérente avec le site réalisé.
- Signaler les contradictions entre les documents.

## Méthode de travail

- Examiner le projet existant avant toute modification.
- Préserver les modifications de l’utilisateur.
- Avancer par changements limités et compréhensibles.
- Privilégier les solutions simples et maintenables.
- Expliquer les choix techniques importants.
- Signaler les informations manquantes et poursuivre les tâches qui ne dépendent pas de ces informations.
- Ne pas ajouter de fonctionnalité complexe sans besoin établi.

## Contenu du portfolio

- Présenter uniquement des informations réelles.
- Ne pas inventer d’expérience, de compétence, de certification, de témoignage, de résultat chiffré ou de coordonnée.
- Distinguer les contributions personnelles du travail collectif.
- Identifier clairement les contenus provisoires pendant le développement et les retirer avant publication.
- Respecter la confidentialité des missions et les droits de publication des textes, images et documents.
- Le CV est une source privée de rédaction uniquement : ne jamais le copier dans le dépôt, le publier, le transcrire intégralement, en créer un PDF ou proposer son téléchargement. Ne pas versionner d’extraction intermédiaire.
- Publier uniquement les informations professionnelles sélectionnées ; exclure l’adresse précise et le téléphone. L’e-mail et les liens LinkedIn/GitHub sont autorisés.

## Conception et développement

- Privilégier un site statique pour la première version.
- Limiter les dépendances et les services tiers.
- Conserver une seule page HTML avec menu FR/EN/NL : traduire le contenu sur place, y compris les libellés accessibles et métadonnées. Ne pas créer de page par langue ni appeler de service de traduction distant.
- Prévoir un affichage adapté au mobile et à l’ordinateur.
- Utiliser du HTML sémantique et une navigation accessible.
- Assurer la lisibilité, les contrastes et le focus clavier.
- Optimiser les images et limiter les ressources chargées.
- Prévoir les informations utiles au référencement.
- Organiser les fichiers de manière claire.
- Conserver les textes en UTF-8.

## Sécurité

- Appliquer les contrôles pertinents de sécurité.md.
- Ne jamais enregistrer de secrets dans le dépôt ou dans les fichiers envoyés au navigateur.
- Ne pas publier de données personnelles ou confidentielles sans autorisation.
- Valider côté serveur les données si une fonction dynamique est ajoutée.
- Justifier tout ajout de formulaire, compte utilisateur, base de données ou service externe.
- Ne jamais présenter le site comme inviolable.
- Distinguer les protections prévues des protections vérifiées.

## Gestion Git et GitHub

- Utiliser le dépôt existant et vérifier sa destination distante avant tout envoi.
- Consulter les modifications avant de préparer un commit.
- Créer des commits cohérents avec des messages explicites.
- Exclure les secrets, fichiers temporaires, dépendances installées et fichiers locaux inutiles avec .gitignore.
- Versionner les fichiers nécessaires pour reconstruire le site, y compris les fichiers de verrouillage des dépendances.
- Ne pas écraser le travail distant ni réécrire l’historique partagé sans instruction explicite.
- Ne pas modifier la visibilité du dépôt sans demande.
- Effectuer les commits, les envois sur GitHub et les déploiements conformément aux instructions données par l’utilisateur.

## Documentation et reproductibilité

Maintenir un README.md expliquant :

- L’objectif du portfolio.
- Les technologies utilisées.
- Les prérequis.
- L’installation et le démarrage local.
- Les commandes de vérification et de construction.
- La structure des principaux dossiers.
- La procédure de déploiement et de mise à jour.
- Les variables de configuration éventuelles, sans leurs secrets.

Le projet doit pouvoir être récupéré depuis GitHub et lancé sur un autre ordinateur en suivant cette documentation.

## Vérifications et livraison

- Exécuter les vérifications adaptées aux modifications.
- Vérifier l’affichage, les liens et le contact, ainsi que l’absence du CV et de tout lien de téléchargement.
- Contrôler l’accessibilité et les mesures de sécurité applicables.
- Ne déclarer un contrôle réussi que s’il a réellement été effectué.
- Résumer les modifications, les vérifications et les limites.
- Documenter les points restant à traiter avant publication.

## Publication

Distinguer deux opérations :

1. Envoyer le code et la documentation dans le dépôt GitHub.
2. Déployer le site sur un hébergement pour le rendre accessible dans un navigateur.

Avant publication, vérifier les contenus, les fichiers envoyés, les paramètres de production et la possibilité de restauration.
