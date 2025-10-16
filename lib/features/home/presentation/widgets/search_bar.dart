import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animals_tasks/features/home/presentation/cubit/search_dogs_cubit.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String)? onSearch;
  final VoidCallback? onFilterTap;

  const SearchBarWidget({super.key, this.onSearch, this.onFilterTap});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Debounce search - only trigger after user stops typing
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      if (_controller.text == query && query.isNotEmpty) {
        context.read<SearchDogsCubit>().searchDogs(query);
        widget.onSearch?.call(query);
      } else if (query.isEmpty) {
        context.read<SearchDogsCubit>().clearSearch();
        widget.onSearch?.call('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  context.read<SearchDogsCubit>().clearSearch();
                  widget.onSearch?.call('');
                  setState(() {});
                },
              )
            : IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                onPressed: widget.onFilterTap,
              ),
        hintText: 'Search breeds...',
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
