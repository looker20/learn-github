# Préparation de l’hébergement

Le site n’est pas déployé. Publier uniquement le contenu de `public/`, jamais la racine du dépôt. Aucune installation ni compilation n’est nécessaire. Les liens fonctionnent également sous un préfixe de chemin.

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
- Vérifier les deux langues, les liens et le comportement mobile sur l’URL réelle.
- Ajouter les URL canoniques, les alternates absolus et le sitemap lorsque le domaine et le chemin sont connus.
- Préciser les informations de confidentialité liées à l’hébergeur : celui-ci peut produire des journaux techniques même si le site n’utilise aucun outil de suivi.

Références : [OWASP HTTP Headers](https://cheatsheetseries.owasp.org/cheatsheets/HTTP_Headers_Cheat_Sheet.html), [OWASP CSP](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html).
