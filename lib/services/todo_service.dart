import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference scoped to user
  CollectionReference _userTodos(String userId) {
    return _firestore.collection('users').doc(userId).collection('todos');
  }

  // Real-time stream of user's todos
  Stream<List<TodoModel>> getTodosStream(String userId) {
    return _userTodos(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TodoModel.fromFirestore(doc))
            .toList());
  }

  // Add new todo
  Future<void> addTodo({
    required String userId,
    required String title,
    required String description,
    required String priority,
  }) async {
    final todo = TodoModel(
      id: '',
      title: title,
      description: description,
      isCompleted: false,
      priority: priority,
      createdAt: DateTime.now(),
      userId: userId,
    );
    await _userTodos(userId).add(todo.toMap());
  }

  // Toggle completion
  Future<void> toggleTodo(String userId, String todoId, bool current) async {
    await _userTodos(userId).doc(todoId).update({'isCompleted': !current});
  }

  // Update todo
  Future<void> updateTodo({
    required String userId,
    required String todoId,
    required String title,
    required String description,
    required String priority,
  }) async {
    await _userTodos(userId).doc(todoId).update({
      'title': title,
      'description': description,
      'priority': priority,
    });
  }

  // Delete todo
  Future<void> deleteTodo(String userId, String todoId) async {
    await _userTodos(userId).doc(todoId).delete();
  }

  // Delete all completed todos
  Future<void> clearCompleted(String userId) async {
    final snapshot = await _userTodos(userId)
        .where('isCompleted', isEqualTo: true)
        .get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
