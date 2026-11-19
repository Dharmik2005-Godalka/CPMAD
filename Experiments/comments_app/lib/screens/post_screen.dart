import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../services/comment_service.dart';

class PostScreen extends StatefulWidget 
{
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> 
{
  final CommentService _service = CommentService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() 
  {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _postComment() 
  {
    final name = _nameController.text.trim();
    final text = _commentController.text.trim();

    if (name.isEmpty || text.isEmpty) 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your name and a comment')),
      );
      return;
    }

    _service.addComment(name, text);
    _commentController.clear(); // keep the name for the next comment
  }

  String _formatTime(DateTime? time) 
  {
    if (time == null) return 'posting...';
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '${time.day}/${time.month}  $h:$m';
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(title: const Text('Realtime Comments')),
      body: Column(
        children: [
          buildPost(),
          Expanded(
            child: StreamBuilder<List<Comment>>(
              stream: _service.getComments(),
              builder: (context, snapshot) 
              {
                if (snapshot.hasError) 
                {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) 
                {
                  return const Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: comments.isEmpty ? 2 : comments.length + 1,
                  itemBuilder: (context, index) 
                  {
                    if (index == 0) 
                    {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Comments (${comments.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    if (comments.isEmpty) 
                    {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('Be the first to comment')),
                      );
                    }
                    return buildCommentTile(comments[index - 1]);
                  },
                );
              },
            ),
          ),
          buildInputBar(),
        ],
      ),
    );
  }

  Widget buildPost() 
  {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why I love Flutter',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'One codebase for Android, iOS and the web, with hot reload that '
            'makes building UIs fast. What do you like most about it?',
          ),
        ],
      ),
    );
  }

  Widget buildCommentTile(Comment comment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo,
          child: Text(
            comment.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          comment.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(comment.text),
        trailing: Text(
          _formatTime(comment.time),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ),
    );
  }

  Widget buildInputBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Your name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _postComment(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.indigo),
                  onPressed: _postComment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
