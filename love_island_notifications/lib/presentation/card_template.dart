import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_island_notifications/presentation/loser1.dart';
import 'package:love_island_notifications/presentation/loser2.dart';
import 'package:love_island_notifications/presentation/loser3.dart';

enum Filter { all, read, unread }

abstract class NotificationEvent {}

class MarkAsRead extends NotificationEvent {
  final String id;
  MarkAsRead(this.id);
}

class FilterChanged extends NotificationEvent {
  final Filter filter;
  FilterChanged(this.filter);
}

class NotificationState {
  final Map<String, bool> readStates;
  final Filter filter;
  NotificationState({required this.readStates, required this.filter});

  NotificationState copyWith({Map<String, bool>? readStates, Filter? filter}) {
    return NotificationState(
        readStates: readStates ?? this.readStates,
        filter: filter ?? this.filter);
  }
}

class NotificationInitial extends NotificationState {
  final Map<String, bool> readStates;
  final Filter filter;
  NotificationInitial({
    required this.readStates,
    this.filter = Filter.all,
  }) : super(readStates: readStates, filter: filter);
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(List<Map<String, dynamic>> cardInfo)
      : super(NotificationInitial(
          readStates: {
            for (var notification in cardInfo)
              notification['id']: notification['read']
          },
          filter: Filter.all,
        )) {
    on<MarkAsRead>(_onMarkAsRead);
    on<FilterChanged>(_onFilterChanged);
  }
  void _onMarkAsRead(MarkAsRead event, Emitter<NotificationState> emit) {
    final updatedReadStates = Map<String, bool>.from(state.readStates);
    updatedReadStates[event.id] = true;
    emit(state.copyWith(readStates: updatedReadStates));
  }

  void _onFilterChanged(FilterChanged event, Emitter<NotificationState> emit) {
    emit(state.copyWith(filter: event.filter));
  }
}

class NotifCard1 extends StatefulWidget {
  final String dp;
  final String name;
  final String description;
  final String timeStamp;
  final bool read;
  final bool deleted;
  final String category;
  final String id;
  final VoidCallback onDelete;

  const NotifCard1(
      {super.key,
      required this.dp,
      required this.name,
      required this.description,
      required this.timeStamp,
      required this.read,
      required this.deleted,
      required this.category,
      required this.id,
      required this.onDelete});

  @override
  State<NotifCard1> createState() => _NotifCard1();
}

class _NotifCard1 extends State<NotifCard1> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) {
                widget.onDelete();
              },
              backgroundColor: const Color.fromRGBO(255, 205, 210, 1),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            )
          ]),
      child: Card(
        color: widget.read ? Colors.white : Colors.blue[50],
        elevation: 0,
        shape: const ContinuousRectangleBorder(),
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: widget.read
              ? Image.asset(
                  widget.dp,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                )
              : Badge(
                  smallSize: 15,
                  child: Image.asset(
                    widget.dp,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(widget.name), Text(widget.timeStamp)],
          ),
          subtitle: Text(widget.description),
          onTap: () {
            print("Card tapped: ${widget.id}");
            // try {
            //   final notificationBloc =
            //       BlocProvider.of<NotificationBloc>(context, listen: false);
            //   notificationBloc.add(MarkAsRead(widget.id));
            //   print("MarkAsRead event added for: ${widget.id}");
            // } catch (e) {
            //   print("Error accessing NotificationBloc: $e");
            // }
            final notificationBloc =
                BlocProvider.of<NotificationBloc>(context, listen: false);
            notificationBloc.add(MarkAsRead(widget.id));
            print("MarkAsRead event added for: ${widget.id}");
            switch (widget.category) {
              case 'loser1':
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoserOne()));
                break;
              case 'loser2':
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoserTwo()));
                break;
              case 'loser3':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoserThree()));
                break;
              default:
                break;
            }
          },
        ),
      ),
    );
  }
}
