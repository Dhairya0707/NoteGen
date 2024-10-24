// // ignore_for_file: use_build_context_synchronously, avoid_print

// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:notegen/provider/note_provider.dart';
// import 'package:notegen/screen/editpage.dart';
// import 'package:provider/provider.dart';

// class NotesPage extends StatefulWidget {
//   const NotesPage({super.key});

//   @override
//   State<NotesPage> createState() => _NotesPageState();
// }

// class _NotesPageState extends State<NotesPage> {
//   bool isCreating = false;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<NoteProvider>(
//       builder: (context, noteProvider, child) => Scaffold(
//         appBar: AppBar(
//           toolbarHeight: MediaQuery.of(context).size.height * 0.065,
//           scrolledUnderElevation: 0,
//           actions: [
//             PopupMenuButton<SortType>(
//               onSelected: (sortType) {
//                 noteProvider.changeSortType(sortType);
//               },
//               itemBuilder: (context) => [
//                 const PopupMenuItem(
//                   value: SortType.title,
//                   child: Text('Sort by Title'),
//                 ),
//                 const PopupMenuItem(
//                   value: SortType.createdAt,
//                   child: Text('Sort by Created Date'),
//                 ),
//                 const PopupMenuItem(
//                   value: SortType.updatedAt,
//                   child: Text('Sort by Updated Date'),
//                 ),
//               ],
//             ),
//           ],
//           title: const Text(
//             'NoteGenie',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: Column(
//           children: [
//             const Gap(10),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.78,
//               child: _buildNotesList(noteProvider),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () async {
//             if (!isCreating) {
//               setState(() {
//                 isCreating = true;
//               });
//               String id = await noteProvider.createnote();

//               if (id.isNotEmpty) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => NoteEditPage(id: id)),
//                 );
//                 setState(() {
//                   isCreating = false;
//                 });
//               } else {
//                 print("Something went wrong!");
//               }
//             }
//           },
//           child: isCreating
//               ? const CircularProgressIndicator()
//               : const Icon(Icons.add),
//         ),
//       ),
//     );
//   }

//   Widget _buildNotesList(NoteProvider provider) {
//     if (provider.noteslist.isEmpty) {
//       return const Center(child: Text('No notes yet. Create one!'));
//     }

//     final Color backgroundColor = Colors.blue[50]!;
//     const Color textColor = Colors.black;

//     return ListView.builder(
//       itemCount: provider.noteslist.length,
//       itemBuilder: (context, index) {
//         final note = provider.noteslist[index];
//         final plainTextContent = note.simpletxt;
//         final id = note.id;
//         return Card(
//           elevation: 0,
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           color: backgroundColor,
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(16),
//             title: Text(
//               note.title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: textColor,
//               ),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 8),
//                 Text(
//                   plainTextContent,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(color: textColor.withOpacity(0.8)),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   _formatDate(note.updatedAt),
//                   style: TextStyle(
//                       fontSize: 12, color: textColor.withOpacity(0.6)),
//                 ),
//               ],
//             ),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {
//                 _showDeleteConfirmation(context, provider, id);
//               },
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => NoteEditPage(id: id)),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _showDeleteConfirmation(
//       BuildContext context, NoteProvider provider, String id) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Delete Note"),
//           content: const Text("Are you sure you want to delete this note?"),
//           actions: <Widget>[
//             TextButton(
//               child: const Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               }, // Close the dialog
//             ),
//             TextButton(
//               child: const Text("Delete"),
//               onPressed: () {
//                 provider.deletenote(id);
//                 Navigator.of(context).pop();
//               }, // Close the dialog
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _formatDate(DateTime date) {
//     // Date formatting logic
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:notegen/provider/note_provider.dart';
import 'package:notegen/screen/editpage.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool isCreating = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildAppBar(context, noteProvider),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: _buildNotesList(noteProvider),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (!isCreating) {
              setState(() {
                isCreating = true;
              });
              String id = await noteProvider.createnote();

              if (id.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoteEditPage(id: id)),
                );
                setState(() {
                  isCreating = false;
                });
              }
            }
          },
          icon: isCreating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.add),
          label: Text(isCreating ? 'Creating...' : 'New Note'),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, NoteProvider noteProvider) {
    return SliverAppBar.large(
      expandedHeight: 160,
      pinned: true,
      actions: [
        PopupMenuButton<SortType>(
          icon: Icon(
            Icons.sort,
            color: Theme.of(context).colorScheme.primary,
          ),
          onSelected: (sortType) {
            noteProvider.changeSortType(sortType);
          },
          itemBuilder: (context) => [
            _buildSortMenuItem(SortType.title, Icons.sort_by_alpha, 'Title'),
            _buildSortMenuItem(
                SortType.createdAt, Icons.calendar_today, 'Created Date'),
            _buildSortMenuItem(
                SortType.updatedAt, Icons.update, 'Last Modified'),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'NoteGenie',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Center(
          child: Icon(
            Icons.note_alt_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<SortType> _buildSortMenuItem(
      SortType value, IconData icon, String text) {
    return PopupMenuItem<SortType>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const Gap(12),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_add,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const Gap(16),
            Text(
              'No notes yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withOpacity(0.7),
                  ),
            ),
            const Gap(8),
            Text(
              'Tap the button below to create your first note',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.5),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesList(NoteProvider provider) {
    if (provider.noteslist.isEmpty) {
      return _buildEmptyState();
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final note = provider.noteslist[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
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
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () => _showDeleteConfirmation(
                                context, provider, note.id),
                          ),
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
                      const Gap(8),
                      _buildDateChip(note.updatedAt),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: provider.noteslist.length,
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

  void _showDeleteConfirmation(
      BuildContext context, NoteProvider provider, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                provider.deletenote(id);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
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
