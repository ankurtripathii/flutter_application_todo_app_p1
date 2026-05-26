import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_model.dart';
import '../services/auth_service.dart';
import '../services/todo_service.dart';
import '../widgets/todo_card.dart';
import '../widgets/add_edit_todo_sheet.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _todoService = TodoService();
  final _authService = AuthService();
  String _filter = 'all'; // 'all', 'active', 'completed'

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => AddEditTodoSheet(userId: widget.user.uid),
    );
  }

  void _openEditSheet(TodoModel todo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => AddEditTodoSheet(userId: widget.user.uid, todo: todo),
    );
  }

  Future<void> _signOut() async {
    await _authService.signOut();
  }

  Future<void> _clearCompleted() async {
    await _todoService.clearCompleted(widget.user.uid);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completed tasks cleared!')),
      );
    }
  }

  List<TodoModel> _applyFilter(List<TodoModel> todos) {
    switch (_filter) {
      case 'active':
        return todos.where((t) => !t.isCompleted).toList();
      case 'completed':
        return todos.where((t) => t.isCompleted).toList();
      default:
        return todos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildFilterBar(),
            Expanded(
              child: StreamBuilder<List<TodoModel>>(
                stream: _todoService.getTodosStream(widget.user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final allTodos = snapshot.data ?? [];
                  final filtered = _applyFilter(allTodos);
                  final completedCount =
                      allTodos.where((t) => t.isCompleted).length;

                  if (allTodos.isEmpty) return _buildEmptyState();

                  return Column(
                    children: [
                      _buildStats(allTodos.length, completedCount),
                      Expanded(
                        child: filtered.isEmpty
                            ? _buildFilterEmptyState()
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: filtered.length,
                                itemBuilder: (_, i) {
                                  final todo = filtered[i];
                                  return TodoCard(
                                    todo: todo,
                                    onToggle: () => _todoService.toggleTodo(
                                        widget.user.uid,
                                        todo.id,
                                        todo.isCompleted),
                                    onEdit: () => _openEditSheet(todo),
                                    onDelete: () => _todoService.deleteTodo(
                                        widget.user.uid, todo.id),
                                  );
                                },
                              ),
                      ),
                      if (completedCount > 0) _buildClearButton(completedCount),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddSheet,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
    );
  }

  Widget _buildHeader() {
    final name =
        widget.user.displayName ?? widget.user.email?.split('@')[0] ?? 'User';
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, $name! 👋',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const Text("Here's your task list",
                    style: TextStyle(fontSize: 13, color: Colors.black45)),
              ],
            ),
          ),
          PopupMenuButton(
            icon: widget.user.photoURL != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.photoURL!),
                    radius: 20)
                : CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 20,
                    child: Text(
                      name[0].toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (_) => <PopupMenuEntry>[
              PopupMenuItem(
                enabled: false,
                child: Text(widget.user.email ?? '',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black45)),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(children: [
                  Icon(Icons.logout, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Sign out', style: TextStyle(color: Colors.red)),
                ]),
              ),
            ],
            onSelected: (v) {
              if (v == 'logout') _signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStats(int total, int completed) {
    final percent = total == 0 ? 0.0 : completed / total;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$completed of $total tasks done',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
                Text('${(percent * 100).round()}%',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: ['all', 'active', 'completed'].map((f) {
          final isSelected = _filter == f;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _filter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.only(right: f != 'completed' ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepPurple : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? Colors.deepPurple
                        : const Color(0xFFE0E0E0),
                  ),
                ),
                child: Text(
                  f[0].toUpperCase() + f.substring(1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black45,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No tasks yet',
              style: TextStyle(fontSize: 18, color: Colors.black45)),
          const SizedBox(height: 8),
          const Text('Tap + to add your first task',
              style: TextStyle(fontSize: 14, color: Colors.black38)),
        ],
      ),
    );
  }

  Widget _buildFilterEmptyState() {
    return Center(
      child: Text(
        _filter == 'active' ? 'No active tasks!' : 'No completed tasks yet.',
        style: const TextStyle(fontSize: 15, color: Colors.black38),
      ),
    );
  }

  Widget _buildClearButton(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: TextButton.icon(
        onPressed: _clearCompleted,
        icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
        label: Text('Clear $count completed task${count > 1 ? 's' : ''}',
            style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}
