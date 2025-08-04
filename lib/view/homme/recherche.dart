import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ArticleSearchScreen extends StatefulWidget {
  @override
  _ArticleSearchScreenState createState() => _ArticleSearchScreenState();
}

class _ArticleSearchScreenState extends State<ArticleSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _searchArticles(_searchController.text);
      } else {
        setState(() => searchResults = []);
      }
    });
  }

  Future<void> _searchArticles(String keyword) async {
    setState(() => _isLoading = true);
    
    try {
      await searchArticles(keyword); // Votre méthode existante
    } catch (e) {
      print('Erreur de recherche: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // VOTRE MÉTHODE EXISTANTE (légèrement optimisée)
  Future<void> searchArticles(String keyword) async {
    final firestore = FirebaseFirestore.instance;
    final lowerKeyword = keyword.toLowerCase();

    final futures = [
      firestore
          .collection('articles')
          .orderBy('nomArticle')
          .startAt([lowerKeyword])
          .endAt([lowerKeyword + '\uf8ff'])
          .get(),
      firestore
          .collection('articles')
          .orderBy('userName')
          .startAt([lowerKeyword])
          .endAt([lowerKeyword + '\uf8ff'])
          .get(),
    ];

    final snapshots = await Future.wait(futures);
    final allDocs = [...snapshots[0].docs, ...snapshots[1].docs];

    final uniqueDocs = {
      for (var doc in allDocs) doc.id: doc.data()
    };

    setState(() {
      searchResults = uniqueDocs.values.toList().cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher articles ou fournisseurs...',
            border: InputBorder.none,
          ),
          autofocus: true,
        ),
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (searchResults.isEmpty) {
      return Center(
        child: Text(_searchController.text.isEmpty
            ? 'Commencez à taper pour rechercher'
            : 'Aucun résultat trouvé'),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final article = searchResults[index];
        return ListTile(
          leading: Image.network(article['imageUrl'] ?? ''),
          title: Text(article['nomArticle']),
          subtitle: Text('Fournisseur: ${article['userName']}'),
          trailing: Text('${article['prixArticle']} €'),
        );
      },
    );
  }
}                