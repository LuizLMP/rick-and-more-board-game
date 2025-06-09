import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final VoidCallback onClear;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Buscar Personagem',
        border: InputBorder.none,
      ),
      onChanged: widget.onChanged,
    );
  }
}
