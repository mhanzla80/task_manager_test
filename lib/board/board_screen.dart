import 'package:flutter/material.dart';
import 'package:task_manager_test/board/widgets/task_card.dart';
import 'package:task_manager_test/kanban_board/kanban_board.dart';
import 'package:task_manager_test/models/task_group.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final KanbanBoardController controller = KanbanBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
  );

  late KanbanBoardScrollController boardController;

  @override
  void initState() {
    super.initState();
    boardController = KanbanBoardScrollController();
    final group1 = KanbanGroupData(
      id: "To Do",
      name: "To Do",
      items: [
        Task(title: "Card 1"),
        Task(title: "Card 2"),
        Task(title: "Card 3", subtitle: 'Aug 1, 2020 4:05 PM'),
        Task(title: "Card 4"),
        Task(title: "Card 5"),
      ],
    );

    final group2 = KanbanGroupData(
      id: "In Progress",
      name: "In Progress",
      items: [
        Task(title: "Card 6"),
        Task(title: "Card 7", subtitle: 'Aug 1, 2020 4:05 PM'),
        Task(title: "Card 8", subtitle: 'Aug 1, 2020 4:05 PM'),
      ],
    );

    final group3 = KanbanGroupData(
      id: "Pending",
      name: "Pending",
      items: [
        Task(title: "Card 9"),
        Task(title: "Card 10", subtitle: 'Aug 1, 2020 4:05 PM'),
        Task(title: "Card 11"),
        Task(title: "Card 12"),
      ],
    );

    controller.addGroup(group1);
    controller.addGroup(group2);
    controller.addGroup(group3);
  }

  @override
  Widget build(BuildContext context) {
    const config = KanbanBoardConfig(
      groupBackgroundColor: Colors.white,
      stretchGroupHeight: false,
    );
    return KanbanBoard(
      controller: controller,
      cardBuilder: (context, group, groupItem) {
        return KanbanGroupCard(
          key: ValueKey(groupItem.id),
          child: _buildCard(groupItem),
        );
      },
      boardScrollController: boardController,
      footerBuilder: (context, columnData) {
        return KanbanGroupFooter(
          icon: const Icon(Icons.add, size: 20),
          title: const Text('New'),
          height: 50,
          margin: config.groupBodyPadding,
          onAddButtonClick: () {
            boardController.scrollToBottom(columnData.id);
          },
        );
      },
      headerBuilder: (context, columnData) {
        return KanbanGroupHeader(
          icon: const Icon(Icons.lightbulb_circle),
          title: SizedBox(
            width: 60,
            child: TextField(
              controller: TextEditingController()
                ..text = columnData.headerData.groupName,
              onSubmitted: (val) {
                controller
                    .getGroupController(columnData.headerData.groupId)!
                    .updateGroupName(val);
              },
            ),
          ),
          addIcon: const Icon(Icons.add, size: 20),
          moreIcon: const Icon(Icons.more_horiz, size: 20),
          height: 50,
          margin: config.groupBodyPadding,
        );
      },
      groupConstraints: const BoxConstraints.tightFor(width: 240),
      config: config,
    );
  }

  Widget _buildCard(KanbanGroupItem item) {
    // if (item is TextItem) {
    //   return Align(
    //     alignment: Alignment.centerLeft,
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    //       child: Text(item.s),
    //     ),
    //   );
    // }

    if (item is Task) {
      return TaskCard(task: item);
    }

    throw UnimplementedError();
  }
}
