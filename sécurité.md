# Suivi opérationnel de la sécurité

## Périmètre et responsabilités

La première version définie dans [plans.md](plans.md) est un portfolio statique trilingue sur une seule page, publié sur GitHub Pages à la demande du propriétaire. Le dépôt est public sur instruction explicite. Aucun compte visiteur, formulaire, base de données, téléversement ni serveur de production administré. Contact par e-mail, LinkedIn et GitHub. Seule la préférence de langue est mémorisée localement, sans transmission. Les traductions sont locales et ne passent pas par un service tiers. Toute extension impose de réévaluer les mesures conditionnelles.

Le propriétaire gère les comptes, le domaine, les autorisations et les décisions de risque. L’agent prépare le code, la configuration et les vérifications accessibles. Les protections déléguées à un hébergeur restent à confirmer et à vérifier.

## Contrôles prioritaires avant publication

États : à décider, à vérifier, en cours, vérifié, non applicable avec justification. Chaque preuve précise une date, un résultat et un emplacement sans secret ni code de récupération.

| Contrôle | Responsable | État | Preuve attendue |
| --- | --- | --- | --- |
| Périmètre et inventaire des services tiers | Propriétaire et agent | Vérifié localement le 31/10/2026 | Site statique sans dépendance ni requête tierce au chargement ; docs/verification.md |
| MFA et récupération des comptes | Propriétaire | À vérifier | Confirmation datée sans donnée sensible |
| Poste et accès de développement | Propriétaire | À vérifier | Revue datée |
| Dépôt, permissions et déploiement | Propriétaire et agent | Déploiement vérifié le 31/10/2026 ; protections de branche non inspectées | Dépôt public autorisé, workflow réussi, actions épinglées, permissions de déploiement limitées ; docs/verification.md |
| Secrets et dépendances | Agent | Contrôlé localement le 31/10/2026 | Contrôle ciblé du code, des fichiers candidats Git et des ressources publiables ; aucune dépendance installée ; docs/verification.md |
| Confidentialité des projets et du CV | Propriétaire et agent | Contrôlé localement le 31/10/2026 | CV absent du dépôt et du site, pas de téléchargement ; contenus professionnels sélectionnés, sans coordonnées exclues ; docs/verification.md |
| HTTPS, domaine éventuel et en-têtes | Propriétaire et agent | HTTPS et HSTS vérifiés le 31/10/2026 ; limites d’en-têtes documentées | Redirection HTTPS, 7 ressources vérifiées, absence des en-têtes personnalisés constatée ; docs/verification.md |
| Contact et données collectées | Propriétaire et agent | Choix confirmé et vérifié localement le 31/10/2026 | Liens e-mail, LinkedIn et GitHub ; aucun formulaire ni collecte applicative |
| Surveillance, quotas et alertes | Propriétaire | À vérifier | Réglages et destinataire des alertes |
| Sauvegarde et retour arrière | Propriétaire et agent | À vérifier | Test réel de restauration |

Chaque ligne doit être vérifiée ou justifiée comme non applicable avant publication. Toute exception décrit le risque restant, la décision du propriétaire, la compensation et la date de réexamen. Aucun état ci-dessus ne certifie une protection déjà mise en œuvre.

### Limites de la publication GitHub Pages

Le propriétaire a demandé explicitement la publication sur GitHub Pages et le passage du dépôt en public. Les contrôles MFA, récupération, poste et protections de branche restent non vérifiés ; aucune confirmation de leur activation n’est présumée. Le propriétaire conserve leur responsabilité.

GitHub Pages ne permet pas à ce workflow de personnaliser les en-têtes HTTP. Les réponses observées ne contiennent pas CSP, nosniff, X-Frame-Options, Referrer-Policy ni Permissions-Policy. Les compensations actuelles sont la CSP et la politique de référent intégrées au HTML, l’absence de ressources distantes, de comptes, de formulaire et d’opérations sensibles. Ces mesures ne remplacent pas tous les en-têtes manquants, notamment la protection contre l’intégration en iframe. Réexaminer le choix d’hébergement avant tout ajout dynamique ou sensible et lors de la revue trimestrielle. Ce constat n’est pas une certification ni une déclaration d’acceptation d’audit par le propriétaire.

## Confidentialité des réalisations

Le CV sert uniquement de source privée : aucun original, copie, PDF, transcription intégrale, extraction intermédiaire ni lien de téléchargement dans le dépôt ou le site. Le téléphone et l’adresse précise sont exclus ; l’e-mail et les liens professionnels sont autorisés. Examiner les captures, schémas, dépôts, démonstrations et leurs métadonnées. Retirer ou anonymiser les noms de clients non autorisés, adresses internes, identifiants, données personnelles et jetons. Vérifier les contenus liés et conserver une trace non sensible des autorisations de publication.

## Préparation de la restauration et des incidents

| Information | À compléter avant publication |
| --- | --- |
| Responsable et contact hors du site | À renseigner |
| Hébergeur, fournisseur du domaine et support | À choisir puis renseigner |
| Emplacement protégé des sauvegardes et configurations | À renseigner |
| Référence du coffre et procédure de récupération | À renseigner sans identifiants secrets |
| Dernière version saine | À renseigner |
| Délai de restauration et perte de données acceptables | À définir |
| Dernier test de restauration | À réaliser et dater |

En cas d’incident : conserver les éléments utiles à l’analyse, suspendre les déploiements compromis, révoquer les accès exposés, restaurer une version saine, vérifier le service puis corriger la cause. Consigner les actions et dates dans un emplacement à accès restreint.

## Entretien proposé

- Après chaque évolution importante : refaire les contrôles concernés.
- Chaque mois : examiner alertes, dépendances, liens et contenus.
- Chaque trimestre : revoir accès, récupération et domaine ; tester la restauration.
- Après un incident : revoir les risques et les procédures.

Fréquences à confirmer par le propriétaire ; traiter les alertes urgentes sans attendre ces échéances.

## Référentiel détaillé conservé

Les mesures ci-dessous servent de référence. Les sections concernant comptes visiteurs, API, téléversements et serveurs sont conditionnelles ; elles ne justifient pas l’ajout de ces fonctions.

# Plan de sécurité du portfolio DevSecOps

## Objectif et principes

Protéger le site, son code, sa chaîne de déploiement, les comptes de gestion et les données éventuelles. Aucun site n’est inviolable : l’objectif est de réduire les possibilités d’attaque, détecter les incidents et permettre une restauration rapide.

Ce document décrit les mesures à prévoir. Il ne certifie pas leur mise en œuvre. Les protections devront être adaptées à l’hébergement et vérifiées avant publication.

Pour la première version, privilégier un site statique avec peu de dépendances, sans compte visiteur, sans base de données et sans serveur à administrer si les fonctionnalités ne l’exigent pas.

## 1. Réduire la surface d’attaque

- Générer les pages statiques lors du déploiement.
- Ne pas exposer d’espace d’administration public sans besoin.
- Ajouter des comptes, une base de données ou une API seulement pour une fonctionnalité justifiée.
- Limiter les bibliothèques et supprimer les composants inutilisés.
- Héberger les polices, images et scripts avec le site lorsque possible.
- Éviter les widgets, scripts de suivi et intégrations tierces superflus.
- Évaluer pour chaque fonctionnalité les risques et le coût de maintenance.

## 2. Sécuriser les comptes de gestion

Appliquer ces mesures à GitHub, à l’hébergement, au fournisseur du domaine et à l’adresse e-mail de récupération :

- Utiliser des mots de passe uniques, générés et conservés dans un gestionnaire.
- Activer l’authentification multifacteur (MFA).
- Privilégier les passkeys ou clés de sécurité FIDO2/WebAuthn, résistantes au phishing.
- Prévoir une méthode de récupération sûre et une clé de secours lorsque possible.
- Conserver les codes de récupération hors ligne dans un emplacement protégé.
- Examiner régulièrement les sessions, appareils, applications et accès autorisés.
- Activer les alertes de connexion et de modification des paramètres.
- Utiliser des comptes individuels et les permissions minimales.

Une application TOTP constitue une solution de repli ; le SMS est moins robuste. Protéger la récupération du compte autant que sa connexion. Le MFA concerne les accès de gestion : il n’est pas nécessaire de créer un compte pour les visiteurs du portfolio.

Référence : [OWASP — Multifactor Authentication](https://cheatsheetseries.owasp.org/cheatsheets/Multifactor_Authentication_Cheat_Sheet.html).

## 3. Protéger le poste de développement

- Maintenir le système, le navigateur, Git et l’éditeur à jour.
- Activer le chiffrement du disque et le verrouillage automatique.
- Utiliser une protection contre les logiciels malveillants.
- Limiter les extensions d’éditeur et de navigateur aux éléments nécessaires et fiables.
- Protéger les clés SSH par une phrase secrète et révoquer les clés inutilisées.
- Examiner les scripts de projets inconnus avant leur exécution.
- Sauvegarder les éléments nécessaires à la récupération.

Un poste compromis peut permettre le vol d’accès ou l’introduction de code malveillant avant publication.

## 4. Protéger GitHub et la chaîne de déploiement

Selon les fonctions disponibles dans l’offre utilisée :

- Protéger la branche de production contre les modifications accidentelles, les suppressions et les réécritures non autorisées.
- Utiliser des pull requests et des contrôles automatisés.
- Faire relire les changements sensibles lorsqu’un relecteur est disponible.
- Accorder aux workflows, jetons et comptes de service les permissions minimales.
- Séparer les environnements de prévisualisation et de production.
- Ne pas exposer de secrets aux contributions non fiables.
- Épingler les actions tierces sur des références immuables et les actualiser.
- Préférer une identité temporaire via OIDC aux identifiants cloud permanents lorsque disponible.
- Utiliser des environnements de construction propres et isolés.
- Conserver les journaux de déploiement et permettre un retour à une version précédente.

Les workflows sont du code privilégié. Examiner avec soin les changements de pipeline et les permissions de publication.

Référence : [OWASP — CI/CD Security](https://cheatsheetseries.owasp.org/cheatsheets/CI_CD_Security_Cheat_Sheet.html).

## 5. Gérer les secrets et les dépendances

### Secrets

- Ne jamais committer de mot de passe, jeton ou clé privée.
- Ne jamais placer un secret dans le JavaScript livré au navigateur : il devient public.
- Utiliser le stockage sécurisé de l’hébergeur ou un gestionnaire de secrets.
- Séparer les accès de développement et de production.
- Limiter la portée et la durée de vie des identifiants.
- Révoquer immédiatement tout secret exposé. Supprimer le fichier ne suffit pas, car l’historique Git peut le conserver.
- Rechercher les secrets exposés dans le dépôt et les artefacts de construction.

### Dépendances

- Ajouter une bibliothèque seulement lorsqu’elle est nécessaire.
- Conserver un fichier de verrouillage des versions.
- Activer les alertes de vulnérabilité et examiner les mises à jour.
- Supprimer les paquets abandonnés et inutilisés.
- Vérifier la provenance des composants et les scripts exécutés à l’installation.
- Pour un projet plus important, produire un inventaire des composants (SBOM).

Référence : [OWASP — CI/CD Security](https://cheatsheetseries.owasp.org/cheatsheets/CI_CD_Security_Cheat_Sheet.html).

## 6. Protéger le domaine, le DNS et HTTPS

- Activer HTTPS avec renouvellement automatique du certificat.
- Rediriger HTTP vers HTTPS et éliminer le contenu mixte.
- Activer HSTS après validation du fonctionnement HTTPS.
- Inclure les sous-domaines dans HSTS uniquement s’ils peuvent fonctionner durablement en HTTPS.
- Verrouiller le transfert du domaine et activer son renouvellement automatique.
- Surveiller les expirations et modifications DNS.
- Activer DNSSEC lorsque le fournisseur et le registre le permettent.
- Supprimer les enregistrements DNS vers des services abandonnés pour limiter les risques de prise de contrôle de sous-domaines.
- Configurer SPF, DKIM et DMARC si le domaine sert à envoyer des e-mails.

DNSSEC protège l’authenticité des réponses DNS et ne remplace pas HTTPS. Déployer HSTS avec prudence pour éviter de rendre des services inaccessibles.

Référence : [OWASP — HTTP Headers](https://cheatsheetseries.owasp.org/cheatsheets/HTTP_Headers_Cheat_Sheet.html).

## 7. Configurer les protections du navigateur

Adapter les en-têtes HTTP aux ressources et intégrations réellement utilisées.

| Protection | Objectif |
| --- | --- |
| `Content-Security-Policy` | Restreindre les scripts et ressources autorisés |
| CSP `frame-ancestors` | Contrôler l’intégration dans une iframe et limiter le clickjacking |
| `X-Content-Type-Options: nosniff` | Empêcher certaines interprétations incorrectes des types de fichiers |
| `Referrer-Policy` | Limiter les informations transmises lors des navigations |
| `Permissions-Policy` | Désactiver les capacités inutiles, comme caméra et microphone |
| `Strict-Transport-Security` | Imposer HTTPS aux navigateurs qui connaissent la politique |

- Tester la CSP, éventuellement en mode `Report-Only`, avant application stricte.
- Éviter les autorisations larges comme `unsafe-eval` et limiter les scripts en ligne.
- Employer des hashes ou des nonces selon l’architecture ; les nonces doivent être imprévisibles et renouvelés pour chaque réponse.
- Évaluer COOP et COEP selon les besoins d’isolation et la compatibilité des intégrations.
- Utiliser l’intégrité des sous-ressources (SRI) pour les ressources tierces compatibles lorsque pertinent.

Références : [OWASP — HTTP Headers](https://cheatsheetseries.owasp.org/cheatsheets/HTTP_Headers_Cheat_Sheet.html), [OWASP — Content Security Policy](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html).

## 8. Si un formulaire de contact est ajouté

- Valider côté serveur les formats, types et longueurs.
- Limiter la taille et la fréquence des requêtes.
- Prévenir les injections dans les en-têtes d’e-mail.
- Ne pas construire directement du HTML, des commandes ou des requêtes à partir des données reçues.
- Encoder les données selon leur contexte d’affichage.
- Déployer un anti-spam progressif : champ piège, limitation de débit, puis challenge si nécessaire.
- Ne pas permettre l’envoi arbitraire d’e-mails vers des destinataires choisis par le visiteur.
- Collecter le minimum de données et définir leur durée de conservation et leur suppression.
- Prévoir une protection CSRF si le fonctionnement repose sur des cookies ou une session.
- Évaluer les protections et pratiques du prestataire si le formulaire est externalisé.

La validation côté navigateur améliore l’expérience mais ne constitue pas une barrière de sécurité.

Référence : [OWASP — Input Validation](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html).

## 9. Si des comptes ou une API sont ajoutés

- Utiliser une solution d’authentification éprouvée.
- Vérifier les autorisations côté serveur pour chaque action et chaque ressource.
- Refuser les accès par défaut et séparer les rôles.
- Configurer les cookies de session avec `Secure`, `HttpOnly` et une politique `SameSite` adaptée.
- Renouveler l’identifiant de session après authentification et invalider la session à la déconnexion.
- Définir des expirations de session adaptées au risque.
- Limiter la force brute et les tentatives automatisées de réutilisation de mots de passe.
- Utiliser des jetons de réinitialisation à usage unique, à durée limitée et difficiles à deviner.
- Exiger une réauthentification pour les opérations sensibles.
- Si des mots de passe sont stockés, utiliser une bibliothèque de hachage adaptée et maintenue ; ne pas concevoir de cryptographie personnalisée.
- Utiliser des requêtes SQL paramétrées pour les accès à une base.
- Restreindre CORS ; CORS ne remplace pas l’authentification ni les autorisations.
- Tester les injections, les accès non autorisés aux objets et les abus de logique métier.
- Éviter de révéler des détails internes dans les messages d’erreur.

Ne pas imposer de changements périodiques de mots de passe sans raison. Privilégier des mots de passe robustes, le MFA et la réaction aux compromissions.

Référence : [OWASP — Authentication](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html).

## 10. Si des téléversements ou imports sont ajoutés

### Fichiers envoyés par les visiteurs

- Limiter les types, tailles et quantités autorisés.
- Vérifier le contenu sans faire confiance à l’extension ou au type déclaré.
- Générer les noms de stockage.
- Stocker les fichiers hors des emplacements exécutables.
- Contrôler les autorisations de consultation et téléchargement.
- Analyser les fichiers selon le risque.
- Encadrer la décompression des archives, les chemins et les volumes extraits.
- Traiter les formats actifs, notamment HTML et SVG, avec une attention particulière.

### Imports depuis une URL

- Restreindre les protocoles et destinations autorisés.
- Empêcher les accès aux réseaux internes et aux services de métadonnées cloud.
- Contrôler les redirections et la résolution DNS.
- Fixer des limites de temps, de taille et de connexions.

Ces restrictions protègent notamment contre les attaques SSRF.

Références : [OWASP — File Upload](https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html), [OWASP — SSRF Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html).

## 11. Si un serveur ou des conteneurs sont administrés

- Utiliser des versions maintenues et appliquer les correctifs.
- Exposer uniquement les ports nécessaires.
- Restreindre les interfaces d’administration par réseau privé ou accès contrôlé.
- Accorder les permissions minimales aux comptes de service.
- Désactiver les services inutiles et les modes debug.
- Exécuter les applications sans privilèges administrateur.
- Isoler les environnements et les bases de données.
- Restreindre les connexions sortantes lorsque possible.
- Utiliser des images minimales, analysées et régulièrement reconstruites.
- Éviter les conteneurs privilégiés et l’exposition du socket Docker.
- Définir des limites de ressources.
- Protéger les données et sauvegardes sensibles au repos, avec une gestion distincte des clés.

Un hébergement statique géré permet de déléguer une partie importante de cette administration. Les responsabilités restant à la charge du propriétaire doivent être identifiées.

## 12. Assurer la disponibilité, la détection et la restauration

- Prévoir une protection DDoS fournie par l’hébergement ou un service en amont.
- Limiter le débit des fonctionnalités dynamiques.
- Configurer quotas et alertes de consommation pour limiter les coûts d’un abus.
- Surveiller la disponibilité, les certificats et les modifications inattendues.
- Conserver des journaux utiles sans mots de passe, jetons ou données personnelles inutiles.
- Définir leur durée de conservation et restreindre leur accès.
- Alerter sur les changements d’accès et les déploiements.
- Sauvegarder le code, la configuration et les données éventuelles.
- Protéger les sauvegardes contre la suppression via un compte compromis.
- Tester réellement la restauration et définir les délais de récupération acceptables.
- Prévoir une procédure d’incident : suspendre un déploiement, révoquer les accès, restaurer, examiner la cause et corriger.

Un WAF peut compléter ces mesures. Il ne corrige pas une application vulnérable et nécessite un réglage adapté.

## 13. Vérifier avant publication et dans la durée

### Avant la mise en ligne

- Identifier les actifs, risques, points d’entrée et flux de données.
- Relire le code, les workflows et les configurations sensibles.
- Rechercher les secrets et analyser les dépendances.
- Vérifier HTTPS, les en-têtes et les fichiers accessibles publiquement.
- Vérifier l’absence de fichiers de configuration privés, sauvegardes, clés ou contenu confidentiel dans les artefacts publiés.
- Tester les formulaires, les permissions et les comportements d’erreur éventuels.
- Vérifier les sauvegardes et le retour à une version précédente.
- Réaliser les tests actifs uniquement sur les environnements autorisés.

### Après publication

- Traiter les alertes et les mises à jour selon le risque.
- Réexaminer les accès régulièrement.
- Refaire les contrôles après une évolution importante.
- Prévoir un audit indépendant si des fonctions sensibles sont ajoutées.
- Publier éventuellement un canal de signalement de vulnérabilités, par exemple via `security.txt`.

Les outils automatiques complètent la revue humaine, particulièrement pour les permissions et la logique métier.

Référence : [OWASP — Secure Code Review](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html).
