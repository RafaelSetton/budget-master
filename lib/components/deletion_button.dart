import 'package:flutter/material.dart';

class DeletionButton extends StatelessWidget {
  const DeletionButton({super.key, required this.onDelete});

  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Deseja mesmo deletar?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  onDelete();
                },
                child: const Text("Deletar"),
              ),
            ],
          ),
        );
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
        size: 20,
      ),
    );
  }
}
