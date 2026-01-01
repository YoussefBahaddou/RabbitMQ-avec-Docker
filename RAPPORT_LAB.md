# Rapport de Lab : Clients Synchrones

## Partie G — Récapitulatif des résultats

### Tableau 1 — Performance (latence et débit)

**Configuration Eureka**

| Méthode | Temps Moyen (ms) | Débit (req/s) | P95 (ms) |
| :--- | :--- | :--- | :--- |
| **RestTemplate** | | | |
| **Feign** | | | |
| **WebClient** | | | |

**Configuration Consul**

| Méthode | Temps Moyen (ms) | Débit (req/s) | P95 (ms) |
| :--- | :--- | :--- | :--- |
| **RestTemplate** | | | |
| **Feign** | | | |
| **WebClient** | | | |

### Tableau 2 — CPU / Mémoire

| Méthode | Eureka CPU% | Eureka RAM (MB) | Consul CPU% | Consul RAM (MB) |
| :--- | :--- | :--- | :--- | :--- |
| **RestTemplate** | | | | |
| **Feign** | | | | |
| **WebClient** | | | | |

### Tableau 3 — Résilience (Scénarios de panne)

| Scénario | Observation (Comportement) | Temps de reprise | Taux d'échec (%) |
| :--- | :--- | :--- | :--- |
| **Panne Service-Client** | | | |
| **Panne Service-Voiture** | | | |
| **Panne Discovery** | | | |

### Tableau 4 — Simplicité et Maintenabilité

| Méthode | Configuration Initiale (Facile/Moyen/Difficile) | Lignes de Code (approx) | Complexité |
| :--- | :--- | :--- | :--- |
| **RestTemplate** | | | |
| **Feign** | | | |
| **WebClient** | | | |

---

## Partie H — Analyse et Discussion

### 1. Performance en charge
*Quelle méthode donne la meilleure latence ?*
> (Votre réponse ici)

*Le débit maximal observé ?*
> (Votre réponse ici)

### 2. Maintenabilité
*Quelle méthode est la plus simple à maintenir ?*
> (Votre réponse ici)

### 3. Impact du Discovery
*Comparaison Eureka vs Consul sur la latence/stabilité :*
> (Votre réponse ici)

### 4. Résilience
*Comportement observé lors des pannes :*
> (Votre réponse ici)

### Conclusion Générale
> (Résumé des forces et faiblesses)
