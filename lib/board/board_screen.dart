import 'package:flutter/material.dart';
import 'package:task_manager_test/board/widgets/create_task_card_widget.dart';
import 'package:task_manager_test/board/widgets/task_card.dart';
import 'package:task_manager_test/helpers/prefs.dart';
import 'package:task_manager_test/kanban_board/kanban_board.dart';
import 'package:task_manager_test/models/task_group.dart';
import 'package:task_manager_test/providers/board_provider.dart';

class BoardScreen extends StatefulWidget {
  final BoardProvider provider;
  const BoardScreen({super.key, required this.provider});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  void initState() {
    super.initState();

    final boardData = Prefs.instance.getBoardData;
    for (final e in boardData) {
      widget.provider.controller.addGroup(e);
    }
    // for (final e in TaskGroup.tempTaskGroups) {
    //   final group = KanbanGroupData(
    //     id: e.id,
    //     name: e.name,
    //     items: e.taskItems,
    //   );
    //   widget.provider.controller.addGroup(group);
    // }
  }

  @override
  void dispose() {
    widget.provider.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KanbanBoard(
      controller: widget.provider.controller,
      cardBuilder: (context, group, groupItem) {
        return KanbanGroupCard(
          key: ValueKey(groupItem.id),
          child: _buildCard(groupItem),
        );
      },
      boardScrollController: widget.provider.boardController,
      footerBuilder: (context, columnData) {
        return KanbanGroupFooter(
          title: TextButton.icon(
            onPressed: () => createTaskInputBottomSheet(
                context, widget.provider, columnData.id),
            label: const Text('New'),
            icon: const Icon(Icons.add, size: 20),
          ),
          height: 50,
          margin: BoardProvider.config.groupBodyPadding,
          onAddButtonClick: () {
            widget.provider.boardController.scrollToBottom(columnData.id);
          },
        );
      },
      headerBuilder: (context, columnData) {
        return KanbanGroupHeader(
          icon: const Icon(Icons.lightbulb_circle),
          title: Expanded(
            child: TextField(
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              controller: TextEditingController()
                ..text = columnData.headerData.groupName,
              onSubmitted: (val) {
                widget.provider.controller
                    .getGroupController(columnData.headerData.groupId)!
                    .updateGroupName(val);
                Prefs.instance
                    .saveBoardData(widget.provider.controller.groupDatas);
              },
            ),
          ),
          height: 50,
          margin: BoardProvider.config.groupBodyPadding,
        );
      },
      groupConstraints: const BoxConstraints.tightFor(width: 300),
      config: BoardProvider.config,
    );
  }

  Widget _buildCard(KanbanGroupItem item) {
    if (item is Task) return TaskCard(task: item);

    throw UnimplementedError();
  }

  void createTaskInputBottomSheet(
      BuildContext context, BoardProvider provider, String id) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          CreateTaskCardWidget(provider: provider, groupId: id),
    );
  }
}
