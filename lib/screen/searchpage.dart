import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:notegen/data/hive_note_model.dart';
import 'package:notegen/screen/editpage.dart';
import 'package:provider/provider.dart';
import 'package:notegen/provider/note_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';
  List<Note> _filteredNotes = [];
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSearchAppBar(context),
          SliverToBoxAdapter(
            child: _buildSearchBar(),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 8),
            sliver: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAppBar(BuildContext context) {
    return SliverAppBar.large(
      expandedHeight: 160,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Search Notes',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Center(
          child: Icon(
            Icons.search,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SearchBar(
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.primary.withOpacity(0.05),
        ),
        elevation: const WidgetStatePropertyAll(0),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        controller: _searchController,
        hintText: 'Search your notes...',
        hintStyle: WidgetStateProperty.all(
          TextStyle(
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
        ),
        leading: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.primary,
        ),
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
            _filteredNotes = Provider.of<NoteProvider>(context, listen: false)
                .searchNotes(query);
          });
        },
        trailing: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                  _filteredNotes.clear();
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const Gap(16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.color
                      ?.withOpacity(0.7),
                ),
          ),
          if (subtitle != null) ...[
            const Gap(8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.5),
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(
          icon: Icons.search,
          title: 'Start searching your notes',
          subtitle: 'Type in the search bar to find your notes',
        ),
      );
    }

    if (_filteredNotes.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(
          icon: Icons.search_off,
          title: 'No notes found',
          subtitle: 'Try searching with different keywords',
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final note = _filteredNotes[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoteEditPage(id: note.id),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              note.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          _buildDateChip(note.updatedAt),
                        ],
                      ),
                      const Gap(8),
                      Text(
                        note.simpletxt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: _filteredNotes.length,
      ),
    );
  }

  Widget _buildDateChip(DateTime date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _formatDate(date),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}







// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:notegen/data/hive_note_model.dart';
// import 'package:notegen/screen/editpage.dart';
// import 'package:provider/provider.dart';
// import 'package:notegen/provider/note_provider.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   String _searchQuery = '';
//   List<Note> _filteredNotes = [];
//   final _searchController = TextEditingController();

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final noteProvider = Provider.of<NoteProvider>(context);

//     return Scaffold(
//       // backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         // backgroundColor: Colors.white,

//         title: const Text(
//           'Search Notes',
//           style: TextStyle(
//             // color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SearchBar(
//               elevation: const WidgetStatePropertyAll(0),
//               padding: const WidgetStatePropertyAll(
//                   EdgeInsets.symmetric(horizontal: 16)),
//               controller: _searchController,
//               hintText: 'Search your notes...',
//               leading: const Icon(Icons.search),
//               onChanged: (query) {
//                 setState(() {
//                   _searchQuery = query;
//                   _filteredNotes = noteProvider.searchNotes(query);
//                 });
//               },
//               trailing: [
//                 _searchQuery.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(
//                           Icons.clear,
//                           color: Colors.black,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _searchController.clear();
//                             _searchQuery = '';
//                             _filteredNotes.clear();
//                           });
//                         })
//                     : Container()
//               ],
//             ),
//           ),
//           const Gap(8),
//           Expanded(
//             child: _buildSearchResults(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     if (_filteredNotes.isEmpty && _searchQuery.isNotEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
//             const Gap(16),
//             Text(
//               'No notes found',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const Gap(8),
//             Text(
//               'Try searching with different keywords',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_searchQuery.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search, size: 48, color: Colors.grey[400]),
//             const Gap(16),
//             Text(
//               'Start searching your notes',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: _filteredNotes.length,
//       itemBuilder: (context, index) {
//         final note = _filteredNotes[index];
//         return Card(
//           elevation: 0,
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           color: Colors.blue[50],
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(16),
//             title: Text(
//               note.title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.black,
//               ),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Gap(8),
//                 Text(
//                   note.simpletxt,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color: Colors.black.withOpacity(0.8),
//                   ),
//                 ),
//                 const Gap(8),
//                 Text(
//                   _formatDate(note.updatedAt),
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.black.withOpacity(0.6),
//                   ),
//                 ),
//               ],
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => NoteEditPage(id: note.id),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }
