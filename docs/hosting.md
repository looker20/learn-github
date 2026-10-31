# Préparation de l’hébergement

La publication utilise GitHub Pages. Le dépôt a été rendu public à la demande du propriétaire ; GitHub Pages est activé en mode GitHub Actions et HTTPS est imposé. Le workflow `.github/workflows/pages.yml` vérifie le projet puis publie uniquement `public/`, jamais la racine du dépôt. Les actions officielles sont épinglées sur des commits immuables et les permissions d’écriture sont limitées au travail de déploiement.

## Activation GitHub Pages

1. Dans `looker20/learn-github`, ouvrir **Settings → Pages** et sélectionner **GitHub Actions** comme source.
2. Le dépôt est public sur décision explicite du propriétaire. Aucun abonnement pour dépôt privé n’est requis pour ce mode de publication.
3. Envoyer le workflow préparé sur `main`, puis suivre **Actions → Deploy portfolio to GitHub Pages**.
4. Vérifier la réussite du déploiement et l’URL retournée avant de partager le site.

Adresse configurée : `https://looker20.github.io/learn-github/`. Le résultat du déploiement et les contrôles réels sont consignés dans `docs/verification.md`.

Les changements ultérieurs de `public/` sur `main` déclencheront une nouvelle publication. Un lancement manuel sera également possible. Pour revenir à une version saine, rétablir les fichiers concernés par un nouveau commit, sans réécriture d’historique, puis relancer le workflow. Cette procédure de restauration reste à tester.

GitHub Pages gère les réponses HTTP : les en-têtes personnalisés ci-dessous ne sont pas appliqués par ce workflow. La CSP embarquée dans le HTML reste présente ; ses directives qui exigent un en-tête, notamment `frame-ancestors`, devront être évaluées sur la réponse réelle. Ne pas déclarer toutes les protections actives sans vérification.

## Configuration recommandée

Configurer ces en-têtes sur les réponses HTTP de l’hébergeur, puis les vérifier réellement :

```text
Content-Security-Policy: default-src 'none'; style-src 'self'; script-src 'self'; img-src 'self'; font-src 'self'; connect-src 'none'; object-src 'none'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

La CSP fournie dans les pages est une protection complémentaire. `frame-ancestors` doit être transmis dans l’en-tête HTTP : une balise meta ne l’applique pas. Le serveur local applique les en-têtes ci-dessus pour les vérifications, sans préjuger de la configuration de production.

Après validation de HTTPS et de tous les services concernés, activer progressivement HSTS. Ne pas activer `includeSubDomains` ou le préchargement sans examiner leurs conséquences sur tous les sous-domaines.

## Avant toute mise en ligne

- Choisir un hébergeur permettant les en-têtes nécessaires ; vérifier ses garanties de disponibilité et sa configuration.
- Activer HTTPS, le renouvellement des certificats et la redirection HTTP vers HTTPS.
- Vérifier MFA, récupération des comptes, droits GitHub, DNS et domaine éventuel.
- Définir les alertes et le retour à une version saine ; tester la restauration.
- Relire les informations professionnelles et autorisations de publication.
- Vérifier les trois langues, le sélecteur sans navigation et le comportement mobile sur l’URL réelle.
- Ajouter l’URL canonique et le sitemap lorsque le domaine et le chemin sont connus. Les langues partagent une seule URL : ne pas annoncer de pages linguistiques distinctes avec hreflang.
- Préciser les informations de confidentialité liées à l’hébergeur : celui-ci peut produire des journaux techniques même si le site n’utilise aucun outil de suivi.

Références : [OWASP HTTP Headers](https://cheatsheetseries.owasp.org/cheatsheets/HTTP_Headers_Cheat_Sheet.html), [OWASP CSP](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html).
