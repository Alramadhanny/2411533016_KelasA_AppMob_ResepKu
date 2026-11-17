import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/pages/detail_page.dart';
import 'package:resepku/provider/favorite_provider.dart';
import 'package:resepku/widgets/recipe_image.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<FavoriteProvider>();
    final favorites = favoriteProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Favorit'),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              tooltip: 'Hapus semua',
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                context.read<FavoriteProvider>().clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Semua resep favorit dihapus'),
                  ),
                );
              },
            ),
        ],
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('Belum ada resep favorit'),
            )
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final recipe = favorites[index];

                return Dismissible(
                  key: ValueKey(recipe.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) {
                    context.read<FavoriteProvider>().toggle(recipe);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('${recipe.name} dihapus dari favorit'),
                        ),
                      );
                  },
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: RecipeImage(
                          url: recipe.image,
                          cacheWidth: 168,
                        ),
                      ),
                    ),
                    title: Text(recipe.name),
                    subtitle: Text(
                      '${recipe.cuisine} • ${recipe.totalTimeMinutes} menit • ★ ${recipe.rating}',
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(recipe: recipe),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}