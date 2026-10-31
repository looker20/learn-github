# Rapport de tests du portfolio — 31 octobre 2026

## Périmètre

Campagne relancée à la demande du propriétaire, de 18:57 à 19:02, heure locale de Bruxelles. Révision examinée : `0a4fa88874f95a329fe58304a3ca9d06e4a6d60a` ; les fichiers du site sont ceux du déploiement `c87be1c80f9452ca405d5cefabe3ad17318e39a0`.

Site contrôlé : https://looker20.github.io/learn-github/

**Résultat : aucun échec dans les contrôles exécutés.** Aucune correction du code du site n’a été nécessaire pendant cette campagne. Ce résultat concerne les scénarios ci-dessous et ne constitue pas une certification de sécurité ou d’accessibilité.

## Résultats

| Contrôle | Résultat |
| --- | --- |
| Vérification statique | Réussie : 9 fichiers publiables, 19 références locales et ancres, une seule page HTML, métadonnées et exclusions des documents privés |
| Navigateur local | 108 scénarios réussis : 9 largeurs × 3 langues × 2 thèmes × 2 chemins, à la racine et sous `/portfolio/` |
| Navigateur sur le site public | 54 scénarios réussis : mêmes largeurs, langues et thèmes sur l’URL réelle |
| Affichage | Largeurs 320, 360, 390, 640, 768, 900, 1023, 1024 et 1280 pixels ; aucun débordement horizontal détecté |
| Navigation | Barre horizontale et réglages toujours visibles en haut dès 1024 pixels ; menu vertical regroupant les mêmes éléments en dessous ; logo vectoriel présent |
| Clavier et tactile | Tabulation, lien d’évitement, focus visible, Échap, clic extérieur, détails des projets et filtres vérifiés ; changement de disposition conservant un focus visible ; menu défilant et appui tactile émulé à 844 × 390 pixels |
| Langues et thèmes | FR/EN/NL, métadonnées et libellés accessibles, choix mémorisé, préférences du navigateur, variantes régionales, repli et stockage bloqué vérifiés ; choix de thème conservé au changement de langue |
| Lisibilité | Textes visibles d’au moins 14 pixels ; contrôle ciblé des contrastes réussi dans les deux thèmes, avec seuils de 4,5:1 pour le texte courant et 3:1 pour le grand texte |
| Replis | Contenu français et navigation lisibles sans JavaScript ; changement de langue en ouverture directe du fichier HTML ; mouvement réduit respecté |
| Réalisations et portrait | Compteurs de 2 projets livrés et 1 en cours, filtres, annonces traduites et détails fonctionnels ; portrait chargé, texte alternatif traduit, aucun monogramme superposé |
| Ressources publiées | 9 réponses HTTPS 200 ; textes conformes au contenu local après normalisation des fins de ligne ; JPEG publié avec la même empreinte SHA-256 et le type `image/jpeg` |
| Référencement | Langue, titre et description contrôlés ; URL canonique, robots.txt et sitemap cohérents avec l’adresse publique |
| Réseau et JavaScript | Aucune requête tierce, exception JavaScript ou violation CSP observée dans les essais |
| Confidentialité | Aucun CV, document privé, fichier de travail local ou type de fichier de clé dans les chemins suivis par Git ; aucun téléchargement de CV dans le site |
| Recherche ciblée de secrets | Aucun jeton GitHub, clé AWS au format recherché ou clé privée détecté dans les fichiers texte suivis ; aucun motif de téléphone belge ou camerounais détecté dans les textes publics |
| Revue visuelle | Captures de l’accueil français sur ordinateur à 1280 pixels et néerlandais sur mobile à 390 pixels inspectées |

Inventaire des ressources publiques : **204 442 octets**, soit environ 200 Kio, sans dépendance d’exécution. Il s’agit du poids des neuf fichiers, pas d’une mesure de temps de chargement ou d’un score de performance.

## HTTPS et protections observées

HTTP redirige vers HTTPS. L’en-tête HSTS observé est `max-age=31556952`. Les chemins `/AGENTS.md`, `/README.md`, `/.git/config` et l’ancienne page `/en/index.html` répondent 404 sur le site ; les documents versionnés restent accessibles dans le dépôt GitHub public.

Les en-têtes HTTP CSP, X-Content-Type-Options, X-Frame-Options, Referrer-Policy et Permissions-Policy ne figurent pas dans les réponses de production observées. La CSP et la politique de référent intégrées au HTML sont présentes. Ces limites d’hébergement déjà documentées restent ouvertes ; les protections locales ne sont pas présentées comme actives en production. Voir [le suivi sécurité](../sécurité.md) et [l’hébergement](hosting.md).

## Limites

- Essais sous Chrome headless, dans un profil isolé et un onglet simulé actif, avec tailles d’écran et tactile émulés. Safari, Firefox, téléphone physique et lecteur d’écran non testés.
- Les contrôles de contraste ne couvrent pas toutes les interactions possibles, styles système et extensions du navigateur.
- Les liens professionnels sont vérifiés comme destinations configurées ; aucune connexion à LinkedIn ou GitHub n’est effectuée pour tester les profils. Le lien e-mail est contrôlé, sans envoi de message.
- La recherche de secrets repose sur des motifs ciblés et ne garantit pas l’absence de tout secret possible. MFA, récupération des comptes et protections de branche non inspectées.
- Aucun test de charge, audit d’intrusion, score Lighthouse ou test réel de restauration n’a été effectué.

## Reproduction et traces

Les commandes des contrôles versionnés sont dans [le README](../README.md). Outils exécutés : `scripts/Verify.ps1`, `scripts/Test-Browser.ps1` en local puis avec `-BaseUrl https://looker20.github.io/learn-github -Deployed`, et le script local de contrôle HTTP du site public `.local/Test-Live.ps1`. Ce dernier reste un outil local non versionné.

Traces conservées sur la machine, dans `.local/` exclu de Git : `tests-2026-10-31-local.txt`, `tests-2026-10-31-public.txt` et captures PNG. Aucun document privé ou fichier temporaire n’est ajouté au dépôt pour cette livraison.
