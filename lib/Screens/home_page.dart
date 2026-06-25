import 'package:flutter/material.dart';

import '../Widgets/subject_card.dart';
import '../theme/app_theme.dart';
import '../providers/attendance_provider.dart';
import '../providers/subject_provider.dart';
import 'attendence_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final subjectController = TextEditingController();

  @override
  void dispose() {
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubjectProvider>();
    final attendanceProvider = context.watch<AttendanceProvider>();
    final subjects = provider.subjects;

    // Compute overall stats
    int overallAttended = 0;
    int overallTotal = 0;
    for (final s in subjects) {
      final t = attendanceProvider.totalsFor(s.id);
      overallAttended += t.attended;
      overallTotal += t.total;
    }
    final double overallPercent =
        overallTotal == 0 ? 0 : (overallAttended / overallTotal * 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Manager'),
      ),
      body: provider.isLoading && subjects.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : subjects.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school_outlined,
                          size: 80,
                          color: AppColors.primaryLight
                              .withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      const Text(
                        'No subjects added yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.onSurfaceLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to add your first subject',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceLight
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Overall Attendance Summary
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primaryLight,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Overall percentage circle
                          SizedBox(
                            height: 56,
                            width: 56,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: overallPercent / 100,
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.3),
                                  color: Colors.white,
                                  strokeWidth: 5,
                                ),
                                Text(
                                  '${overallPercent.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Overall Attendance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$overallAttended / $overallTotal sessions  •  ${subjects.length} subjects',
                                  style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.85),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Subject list
                    Expanded(
                      child: ListView.builder(
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          final s = subjects[index];
                          final totals =
                              attendanceProvider.totalsFor(s.id);
                          return Dismissible(
                            key: ValueKey(s.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              padding: const EdgeInsets.only(right: 24),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete_outline,
                                  color: Colors.white, size: 28),
                            ),
                            confirmDismiss: (_) async {
                              return await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title:
                                          const Text('Delete Subject'),
                                      content: Text(
                                          'Delete "${s.name}" and all its attendance records?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          style:
                                              ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.error,
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                            },
                            onDismissed: (_) {
                              context
                                  .read<SubjectProvider>()
                                  .deleteSubject(s.id);
                            },
                            child: GestureDetector(
                              onLongPress: () => _showSubjectOptionsSheet(
                                  context, s.id, s.name, s.targetPercentage),
                              child: SubjectCard(
                                subjectName: s.name,
                                attended: totals.attended,
                                total: totals.total,
                                targetPercentage: s.targetPercentage,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AttendanceScreen(
                                        subjectId: s.id,
                                        subjectName: s.name,
                                        targetPercentage:
                                            s.targetPercentage,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              subjectController.clear();

              return AlertDialog(
                title: const Text(
                  'Add New Subject',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: subjectController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.book_outlined),
                            labelText: 'Subject Name',
                            hintText: 'e.g. Maths',
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                actionsPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final subjectName = subjectController.text.trim();

                      if (subjectName.isEmpty) {
                        _showErrorDialog(
                          context,
                          'Please fill field correctly before saving.',
                        );
                        return;
                      }

                      debugPrint('Added: $subjectName');
                      Navigator.pop(context);

                      final provider = context.read<SubjectProvider>();
                      await provider.addSubject(subjectName);
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSubjectOptionsSheet(
      BuildContext context, int subjectId, String currentName, int currentTarget) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        int tempTarget = currentTarget;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Target Percentage Slider
                  Row(
                    children: [
                      const Icon(Icons.track_changes, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text('Required Attendance',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      const Spacer(),
                      Text(
                        '$tempTarget%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: tempTarget.toDouble(),
                    min: 50,
                    max: 100,
                    divisions: 50,
                    activeColor: AppColors.primary,
                    label: '$tempTarget%',
                    onChanged: (v) {
                      setSheetState(() => tempTarget = v.round());
                    },
                  ),
                  const SizedBox(height: 8),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showRenameDialog(context, subjectId, currentName);
                          },
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Rename'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (tempTarget != currentTarget) {
                              context
                                  .read<SubjectProvider>()
                                  .updateTargetPercentage(
                                      subjectId, tempTarget);
                            }
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showRenameDialog(
      BuildContext context, int subjectId, String currentName) {
    final renameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Subject',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: renameController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'New Name',
            prefixIcon: Icon(Icons.edit_outlined),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = renameController.text.trim();
              if (newName.isEmpty || newName == currentName) {
                Navigator.pop(ctx);
                return;
              }
              context
                  .read<SubjectProvider>()
                  .updateSubject(subjectId, newName);
              Navigator.pop(ctx);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    ).then((_) => renameController.dispose());
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Invalid Input',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
