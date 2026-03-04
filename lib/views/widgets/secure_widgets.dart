import 'package:flutter/material.dart';

class SecureTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Function()? onChanged;

  const SecureTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SecureTextField> createState() => _SecureTextFieldState();
}

class _SecureTextFieldState extends State<SecureTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: (_) => widget.onChanged?.call(),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: 'Enter ${widget.label.toLowerCase()}',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}

class SecureButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;

  const SecureButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}

class SecureErrorWidget extends StatelessWidget {
  final String? errorMessage;

  const SecureErrorWidget({
    Key? key,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null || errorMessage!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItemWidget extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final int priority;
  final DateTime? dueDate;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TodoItemWidget({
    Key? key,
    required this.title,
    required this.isCompleted,
    required this.priority,
    this.dueDate,
    required this.onTap,
    required this.onDelete,
    required this.onToggle,
  }) : super(key: key);

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

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 5:
        return Colors.red;
      case 4:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 2:
        return Colors.blue;
      case 1:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: dueDate != null
            ? Text('Due: ${dueDate!.toString().split(' ')[0]}')
            : null,
        leading: Checkbox(
          value: isCompleted,
          onChanged: (_) => onToggle(),
        ),
        trailing: Chip(
          label: Text(
            _getPriorityLabel(priority),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: _getPriorityColor(priority),
        ),
        onTap: onTap,
        onLongPress: onDelete,
      ),
    );
  }
}
