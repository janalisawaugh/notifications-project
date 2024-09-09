import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_island_notifications/presentation/card_template.dart';
import 'package:love_island_notifications/presentation/filter_bar.dart';
import 'package:love_island_notifications/presentation/images.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(BlocProvider(
      create: (_) => NotificationBloc(cardInfo), child: const MyApp()));
}

final List<Map<String, dynamic>> cardInfo = [
  {
    'dp': Images.aaron,
    'name': 'Aaron',
    // 'description':
    //     'Liar. Cheater. Manipulator. Gaslighter. Villain. Alleged love: Kaylor. Casa love: Daniela. Real love: Rob.',
    'description':
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ',
    'timeStamp': '12:00AM',
    'read': false,
    'deleted': false,
    'category': 'loser1',
    'id': '1userx',
    'dateReceived': DateTime.now()
  },
  {
    'dp': Images.rob,
    'name': 'Rob',
    // 'description':
    //     'Snake catcher. Liar. Whore. PPG opp. Drama king. The overalls ugh. First love: Leah. Lasting relationships: 0. True love: Aaron.',
    'description':
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ',
    'timeStamp': '12:01AM',
    'read': false,
    'deleted': false,
    'category': 'loser2',
    'id': '2usery',
    'dateReceived': DateTime.now().subtract(Duration(minutes: 24))
  },
  {
    'dp': Images.kendall,
    'name': 'Kendall',
    // 'description':
    //     'FAKE. PPG opp. Disappointing. (Leak was sad). Black card: revoked (did he ever get one?). Nicole: not his girl.',
    'description':
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ',
    'timeStamp': '12:02AM',
    'read': false,
    'deleted': false,
    'category': 'loser3',
    'id': '3userz',
    'dateReceived': DateTime.now().subtract(Duration(hours: 4))
  },
  {
    'dp': Images.kendall,
    'name': 'Testing 1',
    'description':
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ',
    'timeStamp': '12:02AM',
    'read': false,
    'deleted': false,
    'category': 'loser3',
    'id': '4usera',
    'dateReceived': DateTime.now().subtract(Duration(days: 4))
  },
  {
    'dp': Images.kendall,
    'name': 'Testing 2',
    'description':
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ',
    'timeStamp': '12:02AM',
    'read': false,
    'deleted': false,
    'category': 'loser3',
    'id': '5userb',
    'dateReceived': DateTime.now().subtract(Duration(days: 8))
  },
  {
    'dp': Images.kendall,
    'name': 'Testing 3',
    'description':
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ',
    'timeStamp': '12:02AM',
    'read': false,
    'deleted': false,
    'category': 'loser3',
    'id': '6userc',
    'dateReceived': DateTime.now().subtract(Duration(days: 14))
  }
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Love Island USA Opps'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void deleteNotif(int index) {
    setState(() {
      cardInfo[index]['deleted'] = true;
    });
  }

  List<String> getDateCategories() {
    return [
      'TODAY',
      'YESTERDAY',
      'THIS WEEK',
      'LAST WEEK',
      'PAST MONTH',
      'OLDER'
    ];
  }

  String getCategoryLabel(DateTime date) {
    final now = DateTime.now();
    if (date.isAfter(now.subtract(Duration(days: 1)))) {
      return 'TODAY';
    } else if (date.isAfter(now.subtract(Duration(days: 2)))) {
      return 'YESTERDAY';
    } else if (date.isAfter(now.subtract(Duration(days: 7)))) {
      return 'THIS WEEK';
    } else if (date.isAfter(now.subtract(Duration(days: 14)))) {
      return 'LAST WEEK';
    } else if (date.isAfter(now.subtract(Duration(days: 30)))) {
      return 'PAST MONTH';
    } else {
      return 'OLDER';
    }
  }

  String getCustomTimeStamp(DateTime dateReceived) {
    final now = DateTime.now();
    final difference = now.difference(dateReceived);

    if (difference.inMinutes < 5) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = (difference.inMinutes ~/ 5) * 5;
      return '$minutes mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return DateFormat.jm().format(dateReceived);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            MultiSliver(
              pushPinnedChildren: true,
              children: [
                SliverPinnedHeader(child: FiltersBar()),
                SliverToBoxAdapter(
                  child: cardInfo.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'No notifications',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        )
                      : null,
                ),
                BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                  final filteredNotifications = cardInfo.where((notification) {
                    final isRead =
                        state.readStates[notification['id']] ?? false;
                    final isDeleted = notification['deleted'] ?? false;
                    if (isDeleted) return false;
                    switch (state.filter) {
                      case Filter.all:
                        return true;
                      case Filter.read:
                        return isRead;
                      case Filter.unread:
                        return !isRead;
                    }
                  }).toList();

                  final categorizedNotifications =
                      <String, List<Map<String, dynamic>>>{};
                  for (var notification in filteredNotifications) {
                    final categoryLabel =
                        getCategoryLabel(notification['dateReceived']);
                    categorizedNotifications[categoryLabel] ??= [];
                    categorizedNotifications[categoryLabel]!.add(notification);
                  }
                  return MultiSliver(
                    children: [
                      for (var category in getDateCategories())
                        if (categorizedNotifications[category]?.isNotEmpty ??
                            false) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final notification =
                                  categorizedNotifications[category]![index];
                              final isRead =
                                  state.readStates[cardInfo[index]['id']] ??
                                      false;
                              print(
                                  "Building card ${cardInfo[index]['id']} read: $isRead");
                              return NotifCard1(
                                dp: notification['dp'],
                                name: notification['name'],
                                description: notification['description'],
                                timeStamp: getCustomTimeStamp(
                                    notification['dateReceived']),
                                read: state.readStates[notification['id']] ??
                                    false,
                                deleted: notification['deleted'] ?? false,
                                category: notification['category'],
                                id: notification['id'],
                                onDelete: () => deleteNotif(index),
                              );
                            },
                            childCount:
                                categorizedNotifications[category]!.length,
                          )),
                        ]
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
