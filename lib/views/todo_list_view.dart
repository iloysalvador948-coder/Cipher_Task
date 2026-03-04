import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cypher_task_app/viewmodels/auth_viewmodel.dart';
import 'package:cypher_task_app/viewmodels/todo_viewmodel.dart';
import 'package:cypher_task_app/views/widgets/secure_widgets.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({Key? key}) : super(key: key);

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  late TodoViewModel _todoVM;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _todoVM = context.read<TodoViewModel>();
      _loadTodos();
    });
  }

  Future<void> _loadTodos() async {
    await _todoVM.loadTodos();
  }

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dueDateController = TextEditingController();
    int selectedPriority = 3;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SecureTextField(
                  label: 'Task Title',
                  controller: titleController,
                  onChanged: () {
                    _todoVM.onUserInteraction();
                  },
                ),
                const SizedBox(height: 12),
                SecureTextField(
                  label: 'Description (Optional)',
                  controller: descriptionController,
                  onChanged: () {
                    _todoVM.onUserInteraction();
                  },
                ),
                const SizedBox(height: 12),
                SecureTextField(
                  label: 'Due Date (Optional)',
                  controller: dueDateController,
                  onChanged: () {
                    _todoVM.onUserInteraction();
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority: ${_getPriorityLabel(selectedPriority)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: selectedPriority.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value.toInt();
                        });
                        _todoVM.onUserInteraction();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a task title'),
                            ),
                          );
                          return;
                        }

                        DateTime? dueDate;
                        try {
                          if (dueDateController.text.isNotEmpty) {
                            dueDate = DateTime.parse(dueDateController.text);
                          }
                        } catch (e) {
                          // Invalid date format, skip
                        }

                        final success = await _todoVM.addTodo(
                          title: titleController.text,
                          description: descriptionController.text.isEmpty
                              ? null
                              : descriptionController.text,
                          dueDate: dueDate,
                          priority: selectedPriority,
                        );

                        if (success && mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task added successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      child: const Text('Add Task'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 5:
        return 'Critical';
      case 4:
        return 'High';
      case 3:
        return 'Medium';
      case 2:
        return 'Low';
      case 1:
        return 'Minimal';
      default:
        return 'Medium';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<TodoViewModel>().onUserInteraction();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CipherTask - Secure Tasks'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
        body: Consumer2<AuthViewModel, TodoViewModel>(
          builder: (context, authVM, todoVM, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${authVM.currentUser?.fullName ?? 'User'}!',
                        style:
                            Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${todoVM.getIncompleteTodos().length} tasks remaining',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                if (todoVM.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SecureErrorWidget(
                      errorMessage: todoVM.errorMessage,
                    ),
                  ),
                Expanded(
                  child: todoVM.todos.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No tasks yet',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create your first task to get started',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: todoVM.todos.length,
                          itemBuilder: (context, index) {
                            final todo = todoVM.todos[index];
                            return TodoItemWidget(
                              title: todo.title,
                              isCompleted: todo.isCompleted,
                              priority: todo.priority,
                              dueDate: todo.dueDate,
                              onTap: () {
                                _showTodoDetailsDialog(context, todo, todoVM);
                              },
                              onDelete: () {
                                _showDeleteConfirmation(
                                  context,
                                  todo.id,
                                  todoVM,
                                );
                              },
                              onToggle: () {
                                todoVM.toggleTodoCompletion(todo.id);
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<TodoViewModel>().onUserInteraction();
            _showAddTodoDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showTodoDetailsDialog(
    BuildContext context,
    dynamic todo,
    TodoViewModel todoVM,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: FutureBuilder(
          future: todoVM.getDecryptedDescription(todo.id),
          builder: (context, snapshot) {
            String description = 'No description';
            if (snapshot.hasData && snapshot.data != null) {
              description = snapshot.data as String;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                  const SizedBox(height: 16),
                  Text(
                    'Priority: ${_getPriorityLabel(todo.priority)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (todo.dueDate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Due: ${todo.dueDate}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${todo.isCompleted ? "Completed" : "Pending"}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String todoId,
    TodoViewModel todoVM,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              todoVM.deleteTodo(todoId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<AuthViewModel>().logout();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
