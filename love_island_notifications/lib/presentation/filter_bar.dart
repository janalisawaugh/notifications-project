import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_island_notifications/presentation/card_template.dart';

class FiltersBar extends StatefulWidget {
  State<FiltersBar> createState() => _FiltersBar();
}

class _FiltersBar extends State<FiltersBar> {
  List<String> tabs = [];
  List<bool> chipSelected = [];

  @override
  void initState() {
    super.initState();
    tabs = ['All', 'Read', 'Unread'];
    chipSelected = List.generate(tabs.length, (index) => index == 0);
  }

  void onButtonPressed(int index) {
    setState(() {
      for (int i = 0; i < chipSelected.length; i++) {
        chipSelected[i] = i == index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(tabs.length, (index) {
              return FilterChip(
                label: Text(
                  tabs[index],
                  style: TextStyle(
                      color: chipSelected[index] ? Colors.white : Colors.black),
                ),
                selected: chipSelected[index],
                onSelected: (selected) {
                  setState(() {
                    for (int i = 0; i < chipSelected.length; i++) {
                      chipSelected[i] = i == index;
                    }
                  });
                  final selectedFilter = index == 0
                      ? Filter.all
                      : (index == 1 ? Filter.read : Filter.unread);
                  context
                      .read<NotificationBloc>()
                      .add(FilterChanged(selectedFilter));
                },
                selectedColor: Colors.purple,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: BorderSide.none,
                showCheckmark: false,
              );
            })));
  }
}
