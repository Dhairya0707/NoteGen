import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:notegen/provider/note_provider.dart';
import 'package:notegen/screen/Ai_options/chat_with_ai.dart';
import 'package:provider/provider.dart';

class AIFeaturesShowcase extends StatelessWidget {
  const AIFeaturesShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar.large(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'AI Features',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Center(
          child: Icon(
            Icons.auto_awesome,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainFeatures(context),
          const Gap(32),
          _buildWritingAssistant(context),
          const Gap(32),
          _buildSmartTools(context),
          const Gap(32),
          _buildInteractiveFeatures(context),
        ],
      ),
    );
  }

  Widget _buildMainFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Core Features'),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                context,
                title: 'Summarize',
                icon: Icons.summarize,
                description: 'Get concise summaries of your notes instantly',
              ),
            ),
            const Gap(16),
            Expanded(
              child: _buildFeatureCard(
                context,
                title: 'Rewrite',
                icon: Icons.autorenew,
                description:
                    'Improve clarity and flow while keeping the meaning',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWritingAssistant(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Writing Assistant'),
        const Gap(16),
        _buildFeatureList(
          context,
          [
            (
              'Tone Adjustment',
              Icons.mood,
              'Adapt your writing to different styles and contexts'
            ),
            (
              'Spell Check',
              Icons.spellcheck,
              'Catch and correct spelling mistakes automatically'
            ),
            (
              'Grammar Check',
              Icons.abc,
              'Ensure grammatical accuracy in your writing'
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmartTools(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Smart Tools'),
        const Gap(16),
        _buildFeatureList(
          context,
          [
            (
              'Make Longer',
              Icons.add_circle_outline,
              'Expand your content with relevant details'
            ),
            (
              'Make Shorter',
              Icons.remove_circle_outline,
              'Create concise versions while keeping key points'
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractiveFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Interactive AI'),
        const Gap(16),
        _buildChatFeature(context),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          const Gap(12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Gap(8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList(
    BuildContext context,
    List<(String, IconData, String)> features,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      separatorBuilder: (context, index) => const Gap(12),
      itemBuilder: (context, index) {
        final (title, icon, description) = features[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Gap(4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatFeature(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const Gap(12),
              Text(
                'Chat with AI',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            'Have interactive conversations with our AI assistant to enhance your notes, get suggestions, and more.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Gap(16),
          ElevatedButton.icon(
            style: ButtonStyle(
              iconColor: const WidgetStatePropertyAll(Colors.white),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              backgroundColor: WidgetStateProperty.all<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: () {
              final Color backgroundColor = Colors.blue[50]!;
              const Color textColor = Colors.black;
              final provider =
                  Provider.of<NoteProvider>(context, listen: false);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Select a Note'),
                      leading: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back)),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: provider.noteslist.length,
                          itemBuilder: (context, index) {
                            final note = provider.noteslist[index];
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              color:
                                  backgroundColor, // Add some elevation for depth

                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  note.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: textColor,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      note.simpletxt,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: textColor.withOpacity(0.8)),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatWithAiPage(note: note),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
// }
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Start Chatting'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
