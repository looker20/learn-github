# Bilan de vérification — 31 octobre 2026

## Périmètre

Portfolio statique français/anglais/néerlandais sur une seule page, contrôlé localement sous Windows avec Chrome en mode headless. Aucun hébergement public n’a été créé. Les scripts et résultats décrivent des contrôles ciblés, pas une certification de sécurité ou d’accessibilité.

## Contrôles effectués

| Contrôle | Résultat et preuve |
| --- | --- |
| Structure statique | 5 fichiers publiables : une page HTML, CSS, navigation/traduction, catalogue de traductions et favicon SVG ; aucune dépendance d’exécution |
| Liens locaux et ancres | 14 références contrôlées par `scripts/Verify.ps1`, sans référence manquante ; une seule page HTML |
| Métadonnées | Attribut lang, titre et description mis à jour avec la langue choisie ; CSP présente |
| Confidentialité du CV | Aucun document original, PDF, copie, extraction ou téléchargement dans les fichiers publiables et candidats Git ; revue du contenu sélectionné |
| Coordonnées | E-mail, LinkedIn et GitHub uniquement ; absence du téléphone et de l’adresse précise vérifiée |
| Affichage | 18 scénarios : 3 langues × 3 largeurs (360, 768, 1280) × 2 préfixes (racine et `/portfolio/`), sans débordement horizontal |
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
| Mouvement réduit | Défilement fluide désactivé lorsque la préférence système est active |
| Réseau navigateur | Aucune requête tierce, violation CSP ou exception JavaScript observée pendant les essais |
| HTTP local | Pages et ressources : 200 ; route inconnue et `/AGENTS.md` : 404 |
| En-têtes locaux | CSP avec `frame-ancestors`, nosniff, refus d’iframe, politique de référent et permissions vérifiés sur le serveur d’aperçu |
| Revue visuelle | Captures néerlandaises mobile et bureau inspectées ; revue de la page française complète effectuée lors de la version précédente |

Les sorties et captures du navigateur sont générées sous `.local/`, exclu de Git. Relancer les scripts permet de les reproduire. Les liens externes ont été contrôlés comme destinations, sans connexion aux comptes ni vérification du fonctionnement d’une messagerie locale.

## Limites et contrôles ultérieurs

- Pas de test sur Safari, Firefox, appareils physiques ou lecteur d’écran ; revue complémentaire recommandée avant publication web.
- Le contrôle des contrastes ne couvre pas toutes les combinaisons de survol, styles système ou rendu d’extensions.
- HTTPS, certificats, en-têtes de production, DNS, domaine, protections DDoS et surveillance restent à configurer et vérifier chez le futur hébergeur.
- MFA, récupération des comptes, protections de branche et permissions GitHub n’ont pas été inspectés ou modifiés.
- Aucun retour arrière d’un hébergement n’a été testé ; aucun hébergement n’existe à cette étape.
- La description des missions repose sur le CV et les confirmations de dates. Aucune preuve interne ou mesure de performance n’est publiée.
- Les noms d’entreprises sont ceux des expériences demandées pour le portfolio ; leur présence n’implique aucun partenariat ni soutien.

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
