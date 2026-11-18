import 'package:flutter/material.dart';
import '../models/article.dart';
import '../widgets/category_card.dart';
import '../widgets/featured_article.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  List<Article> articles = List.of(sampleArticles);
  int refreshCount = 0;
  String lastUpdated = 'Not refreshed yet';

  String timeNow() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> refreshNews() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      refreshCount++;
      articles.insert(
        0,
        Article(
          id: 100 + refreshCount,
          title: 'Just in: Fresh news update #$refreshCount',
          category: 'Breaking',
          source: 'Live Desk',
          time: 'Just now',
          icon: Icons.bolt,
          color: Colors.amber,
        ),
      );
      lastUpdated = 'Updated at ${timeNow()}';
    });
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 1)),
    );
  }

  Widget sectionTitle(String title, {String? trailing}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: refreshKey,
        edgeOffset: kToolbarHeight + MediaQuery.of(context).padding.top,
        onRefresh: refreshNews,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // 1. Collapsing header 
            SliverAppBar(
              pinned: true,
              expandedHeight: 220,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => refreshKey.currentState?.show(),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: const Text('News Dashboard'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade900, Colors.indigo.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 56),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 42, color: Colors.indigo),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Hello, Reader',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            'Here is your daily briefing',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2. Featured article 
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: FeaturedArticle(
                  article: featuredArticle,
                  onTap: () => showMessage(featuredArticle.title),
                ),
              ),
            ),

            // 3. Trending
            sectionTitle('Trending Now'),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return GestureDetector(
                      onTap: () => showMessage(article.title),
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: article.color.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(article.icon, color: article.color.shade800),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                article.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 4. Category cards
            sectionTitle('Categories'),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];
                    return CategoryCard(
                      category: category,
                      onTap: () => showMessage('${category.name} selected'),
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),

            // 5. Latest news...
            sectionTitle('Latest News', trailing: lastUpdated),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final article = articles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: article.color.shade100,
                        child: Icon(article.icon, color: article.color.shade800),
                      ),
                      title: Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${article.category} • ${article.source} • ${article.time}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => showMessage(article.title),
                    ),
                  );
                },
                childCount: articles.length,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
