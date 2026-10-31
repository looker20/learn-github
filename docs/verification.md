# Bilan de vérification — 31 octobre 2026

## Périmètre

Portfolio statique français/anglais/néerlandais sur une seule page, contrôlé localement et sur GitHub Pages avec Chrome en mode headless. Les scripts et résultats décrivent des contrôles ciblés, pas une certification de sécurité ou d’accessibilité.

## Contrôles effectués

| Contrôle | Résultat et preuve |
| --- | --- |
| Structure statique | 9 fichiers publiables : une page HTML, CSS, initialisation du thème, navigation/traduction, catalogue de traductions, favicon SVG, portrait JPEG, robots.txt et sitemap.xml ; aucune dépendance d’exécution |
| Liens locaux et ancres | 19 références contrôlées par `scripts/Verify.ps1`, sans référence manquante ; une seule page HTML |
| Métadonnées | Attribut lang, titre et description mis à jour avec la langue choisie ; CSP présente |
| Confidentialité du CV | Aucun document original, PDF, copie, extraction ou téléchargement dans les fichiers publiables et candidats Git ; revue du contenu sélectionné |
| Coordonnées | E-mail, LinkedIn et GitHub uniquement ; absence du téléphone et de l’adresse précise vérifiée |
| Affichage | 36 scénarios locaux : 2 thèmes × 3 langues × 3 largeurs (360, 768, 1280) × 2 préfixes (racine et `/portfolio/`), sans débordement horizontal |
| Contrastes | Texte visible contrôlé sur ses fonds CSS, seuil 4,5:1 pour le texte courant et 3:1 pour le grand texte ; aucune insuffisance détectée par le contrôle ciblé |
| Navigation | Menu mobile au clavier, fermeture avec Échap et retour du focus, navigation vers une section ; menu FR/EN/NL sans navigation, changement d’URL ni remplacement du contenu DOM |
| Traduction | Titres et libellés accessibles traduits ; états des détails et section courante conservés ; choix mémorisé après rechargement |
| Détection de langue | Préférences en-GB, nl-BE, fr-BE, recherche de la première langue compatible, repli français, préférence manuelle prioritaire et valeur stockée invalide testés |
| Stockage bloqué | Changement de langue fonctionnel malgré le blocage de localStorage |
| Couverture | Chaque texte, libellé accessible, titre et description de la page possède une entrée anglaise et néerlandaise ; noms propres conservés lorsque pertinent |
| Ouverture directe | Changement FR/EN/NL vérifié en ouvrant le fichier HTML local directement, sans serveur |
| Réalisations | Ouverture des détails avec la touche Entrée |
| Accès rapide | Lien d’évitement utilisable au clavier et focus visible |
| Sans JavaScript | Navigation visible et contenu français lisible à 360 pixels ; menu de langue masqué |
| Portrait | JPEG 800 × 1000, 107 272 octets, sans EXIF ; chargé aux trois largeurs, texte alternatif traduit ; photo originale exclue du dépôt |
| Filtres | 2 projets livrés (ELK et Nagios), 1 projet IA en cours et 2 expériences réseau de stage ; les compteurs excluent les stages. Filtres par état et domaine, raccourcis des compteurs, conservation au changement de langue et annonce accessible traduite vérifiés |
| Thèmes et lisibilité | Clair pierre/sauge et sombre ardoise/vert ; textes visibles d’au moins 14 pixels et corps de 17–18 pixels ; contrastes vérifiés dans les deux modes. Choix mémorisé, priorité sur le système, valeurs invalides et stockage bloqué testés |
| Interactions et mouvement | Progression de lecture mise à jour, section active indiquée, apparition au défilement ; aucune animation ou transformation persistante en mode mouvement réduit |
| Mouvement réduit | Défilement fluide désactivé lorsque la préférence système est active |
| Réseau navigateur | Aucune requête tierce, violation CSP ou exception JavaScript observée pendant les essais |
| HTTP local | Pages et ressources : 200 ; route inconnue et `/AGENTS.md` : 404 |
| En-têtes locaux | CSP avec `frame-ancestors`, nosniff, refus d’iframe, politique de référent et permissions vérifiés sur le serveur d’aperçu |
| Revue visuelle | Captures néerlandaises mobile et bureau inspectées ; revue de la page française complète effectuée lors de la version précédente |

Les sorties et captures du navigateur sont générées sous `.local/`, exclu de Git. Relancer les scripts permet de les reproduire. Les liens externes ont été contrôlés comme destinations, sans connexion aux comptes ni vérification du fonctionnement d’une messagerie locale.

## Publication GitHub Pages vérifiée

- Dépôt rendu public sur demande explicite du propriétaire, sans document CV dans le dépôt ou l’historique examiné.
- Pages activé en mode GitHub Actions, HTTPS imposé.
- Premier déploiement réussi : [workflow 41207065640](https://github.com/looker20/learn-github/actions/runs/41207065640), révision `a962a8dc62c2d0a59770d421797f0b3e9f8afbd6`.
- Mise à jour portrait et interactions réussie : [workflow 41208946244](https://github.com/looker20/learn-github/actions/runs/41208946244), révision `f56f2751acb51ab8c911de1b61e47bc467b182ca` ; essais navigateur sur l’URL publique réussis dans les trois langues aux trois largeurs.
- Mise à jour thèmes et bilan de projets réussie : [workflow 41210636166](https://github.com/looker20/learn-github/actions/runs/41210636166), révision `5df42acb258349e180b142ac12e2e7d8d562a3af`. Les 18 scénarios publics (2 thèmes × 3 langues × 3 largeurs) passent, dont taille des textes, contrastes, compteurs, filtres et navigation clavier.
- Précision OpenShift confirmée par le propriétaire et publiée : [workflow 41211587645](https://github.com/looker20/learn-github/actions/runs/41211587645), révision `f8339abfeaf5d9a8dce9e4ada0b57cc5ca00f4a9`. Ajout aux technologies et au projet ELK : déploiement et tests du monitoring applicatif sur OpenShift, avec traductions anglaise et néerlandaise. Vérification statique réussie ; les neuf fichiers en ligne correspondent au contenu attendu. Les 18 scénarios navigateur publics passent après cet ajout, sans débordement, régression de contraste, erreur JavaScript ou violation CSP observée.
- Adresse vérifiée : **https://looker20.github.io/learn-github/**.
- Les neuf fichiers publics répondent en HTTPS 200 et correspondent au contenu local après normalisation des fins de ligne pour les textes ; le JPEG publié possède la même empreinte SHA-256 que le fichier attendu et le type `image/jpeg`.
- HTTP redirige vers HTTPS. HSTS observé : `max-age=31556952`.
- `/AGENTS.md`, `/README.md`, `/.git/config` et l’ancienne page `/en/index.html` répondent 404 sur le site. Les documents suivis restent visibles dans le dépôt public.
- Dix-huit scénarios navigateur sur l’URL réelle : modes clair/sombre, FR/EN/NL à 360, 768 et 1280 pixels. Portrait, filtres au clavier, annonces de résultats traduites, compteurs 2 livrés / 1 en cours, progression de lecture, section active, lisibilité, contrastes, menu, traduction sur place, persistance et stockage bloqué passent. Le mode mouvement réduit désactive les animations et les transformations de révélation.
- Aucune requête tierce ni erreur JavaScript ou CSP observée pendant les essais.
- CSP, nosniff, X-Frame-Options, Referrer-Policy et Permissions-Policy absents des en-têtes HTTP de production observés. La CSP et la politique de référent intégrées à la page restent disponibles ; `frame-ancestors` ne fonctionne pas via une balise meta. Aucun en-tête local n’est présenté comme actif en production.

Reproduire les essais navigateur du site publié :

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Test-Browser.ps1 -BaseUrl https://looker20.github.io/learn-github -Deployed
```

## Limites et contrôles ultérieurs

- Pas de test sur Safari, Firefox, appareils physiques ou lecteur d’écran ; revue complémentaire recommandée avant publication web.
- Le contrôle des contrastes ne couvre pas toutes les combinaisons de survol, styles système ou rendu d’extensions.
- Un domaine personnalisé, les alertes et la surveillance restent à décider. Les protections DDoS du fournisseur n’ont pas fait l’objet d’un test de charge.
- MFA, récupération des comptes, protections de branche et permissions GitHub n’ont pas été inspectés ou modifiés.
- La procédure de retour arrière est documentée, mais aucun retour arrière du site en ligne n’a été exécuté.
- La description des missions repose sur le CV et les confirmations de dates. Aucune preuve interne ou mesure de performance n’est publiée.
- Les noms d’entreprises sont ceux des expériences demandées pour le portfolio ; leur présence n’implique aucun partenariat ni soutien.
- Le portrait est une retouche générative à partir de la photo fournie, inspectée visuellement. Voir `docs/portrait.md` pour la consigne et le traitement du fichier.

## Reproduire les essais

Depuis la racine du dépôt :

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Verify.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Serve.ps1
```

Dans un second terminal, avec Chrome ou Edge installé :

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/Test-Browser.ps1
```

Le paramètre `ExecutionPolicy` concerne uniquement le processus lancé et ne change pas la politique permanente du poste. Respecter les politiques administrées de l’organisation. Le navigateur utilise un profil de test distinct du profil personnel et est arrêté à la fin du contrôle.
