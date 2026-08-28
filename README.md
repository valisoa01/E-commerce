# 🛒 E-Commerce Riverpod

Application Flutter de démonstration validant la maîtrise du **state management avec Riverpod**, à travers une petite app e-commerce fonctionnelle.

## Fonctionnalités

- 📦 Catalogue de produits (liste en grille + écran détail)
- 🛒 Panier d'achat (ajout, suppression, modification de quantité, total)
- ❤️ Favoris persistés localement (survivent à la fermeture de l'app)
- 🔍 Recherche par nom, filtrage par catégorie, tri (prix / nom)
- 👤 Écran de profil utilisateur (mocké)
- ✨ Petite animation lors de l'ajout au panier

## Architecture

Le projet suit une architecture en couches, pour séparer clairement les responsabilités :

```
lib/
├── data/            → Source de données brute (lit le JSON mocké dans les assets)
├── models/          → Classes de données simples (Product, CartItem)
├── repositories/     → Fait le lien entre la donnée brute et les objets métier
├── services/        → Services techniques indépendants de Riverpod (persistance des favoris)
├── providers/        → Toute la logique Riverpod (state management)
├── screens/         → Les écrans (un fichier = un écran)
└── widgets/         → Composants réutilisables (carte produit, ligne panier, sélecteur de quantité)
```

Règle suivie : une couche ne connaît que la couche juste en dessous d'elle.
Par exemple, les écrans ne parlent jamais directement au repository : ils
passent toujours par un provider.

Les données produits sont **mockées** dans `assets/data/products.json` et
chargées via `ProductsDataSource`, comme si elles venaient d'une vraie API
(avec un petit délai simulé dans le repository).

## Providers utilisés

| Provider | Type | Rôle |
|---|---|---|
| `productRepositoryProvider` | `Provider` | Fournit une instance unique du repository produits |
| `productsProvider` | `FutureProvider` | Charge la liste des produits (asynchrone) |
| `searchQueryProvider` | `NotifierProvider` | Texte de la barre de recherche |
| `selectedCategoryProvider` | `NotifierProvider` | Catégorie sélectionnée dans les filtres |
| `sortOptionProvider` | `NotifierProvider` | Option de tri choisie |
| `filteredProductsProvider` | `Provider` (dérivé) | Combine produits + recherche + filtre + tri |
| `categoriesProvider` | `Provider` (dérivé) | Liste des catégories disponibles |
| `cartProvider` | `NotifierProvider` | Contenu du panier (ajout/suppression/quantité) |
| `cartTotalProvider` | `Provider` (dérivé) | Prix total du panier |
| `cartItemCountProvider` | `Provider` (dérivé) | Nombre d'articles (badge de l'icône panier) |
| `favoritesStorageServiceProvider` | `Provider` | Injecte le service de persistance des favoris |
| `favoritesProvider` | `NotifierProvider` | Ids des produits favoris, avec sauvegarde locale automatique |
| `userProfileProvider` | `Provider` | Profil utilisateur mocké |

Cela couvre les 3 grandes familles de providers Riverpod : `Provider`
(dépendances/valeurs calculées), `FutureProvider` (données asynchrones) et
`NotifierProvider` (état qui évolue avec des actions métier — que ce soit un
état simple comme une chaîne de caractères, ou plus riche comme une liste).

> **Note de version** : ce projet utilise Riverpod 3, où `StateProvider`,
> `StateNotifier` et `StateNotifierProvider` (présents dans les anciennes
> versions / tutoriels) ont été retirés au profit de `Notifier` et
> `NotifierProvider`, qui remplissent exactement le même rôle.

## Gestion des états asynchrones

Toutes les données asynchrones (`productsProvider`, `filteredProductsProvider`,
`categoriesProvider`) exposent un `AsyncValue`, géré dans l'UI avec
`.when(data: ..., loading: ..., error: ...)`, ce qui permet d'afficher
proprement un indicateur de chargement ou un message d'erreur.

## Persistance des favoris

Les favoris sont sauvegardés localement grâce au package `shared_preferences`,
via `FavoritesStorageService`. `FavoritesNotifier` charge les favoris au
démarrage et les réenregistre à chaque modification.

## Lancer le projet

```bash
flutter pub get
flutter run
```
