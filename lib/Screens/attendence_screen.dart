import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:provider/provider.dart';
import '../providers/attendance_provider.dart';
import '../theme/app_theme.dart';

class AttendanceScreen extends StatefulWidget {
  final int subjectId;
  final String subjectName;
  final int targetPercentage;

  const AttendanceScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
    this.targetPercentage = 75,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _animateChart = false;

  @override
  void initState() {
    super.initState();
    // Tell the provider to start watching this subject's entries
    context.read<AttendanceProvider>().loadSubject(widget.subjectId);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _animateChart = true);
    });
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = _dateOnly(selectedDay);
      _focusedDay = focusedDay;
    });
    _showEditAttendanceSheet(selectedDay);
  }

  Future<void> _showEditAttendanceSheet(DateTime forDay) async {
    final provider = context.read<AttendanceProvider>();
    final existing = provider.entryForDate(forDay);
    int attended = existing?.attendedSessions ?? 0;
    int total = existing?.totalSessions ?? 0;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Update Attendance — ${forDay.day}/${forDay.month}/${forDay.year}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _counterCard(
                            label: "Attended",
                            value: attended,
                            color: AppColors.accent,
                            onChanged: (v) =>
                                setSheetState(() => attended = v),
                          ),
                          const SizedBox(width: 12),
                          _counterCard(
                            label: "Total",
                            value: total,
                            color: AppColors.primary,
                            onChanged: (v) =>
                                setSheetState(() => total = v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (attended > total) {
                            _showFloatingError(context,
                                "Attended cannot exceed total sessions.");
                            return;
                          }
                          await provider.saveAttendance(
                            date: _dateOnly(forDay),
                            attended: attended,
                            total: total,
                          );
                          if (context.mounted) Navigator.pop(context);
                        },
                        icon: const Icon(Icons.save_outlined),
                        label: const Text("Save"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _counterCard({
    required String label,
    required int value,
    required Color color,
    required ValueChanged<int> onChanged,
  }) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.08),
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (value > 0) onChanged(value - 1);
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.error,
                  ),
                  Text('$value',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => onChanged(value + 1),
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.success,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFloatingError(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }



  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();
    final totalAttended = provider.totalAttended;
    final totalSessions = provider.totalSessions;
    final missed = totalSessions - totalAttended;
    final overallPercent = provider.overallPercent;
    final double targetPercentDecimal = widget.targetPercentage / 100;
    final attendanceByDate = provider.attendanceByDate;

    // Health Status Logic (Reusable)
    final double percentage = overallPercent * 100;
    final int safeLeaves = totalSessions == 0
        ? 0
        : ((totalAttended / targetPercentDecimal).floor() - totalSessions).clamp(0, totalSessions);

    String statusLabel;
    String statusTip;
    IconData statusIcon;
    Color healthColor;

    if (totalSessions == 0) {
      statusLabel = 'No Data';
      statusTip = 'Add attendance';
      statusIcon = Icons.help_outline_rounded;
      healthColor = AppColors.onSurfaceLight;
    } else if (percentage >= widget.targetPercentage) {
      healthColor = AppColors.success;
      if (safeLeaves > 0) {
        statusLabel = 'Safe';
        statusTip = 'You can miss $safeLeaves sessions';
        statusIcon = Icons.check_circle_outline_rounded;
      } else {
        statusLabel = 'On Track';
        statusTip = 'Margin is tight';
        statusIcon = Icons.trending_up_rounded;
      }
    } else {
      if (percentage >= (widget.targetPercentage - 10)) {
        statusLabel = 'Caution';
        statusTip = 'Focus on next classes';
        statusIcon = Icons.warning_amber_rounded;
        healthColor = AppColors.warning;
      } else {
        statusLabel = 'Below Target';
        statusTip = 'Consistency required';
        statusIcon = Icons.error_outline_rounded;
        healthColor = AppColors.error;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.subjectName,
          style: const TextStyle(
              color: AppColors.onPrimary, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onPrimary),
            tooltip: 'Replay Animation',
            onPressed: () {
              setState(() {
                _animateChart = false;
              });
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) setState(() => _animateChart = true);
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _summaryCard(
                          title: 'Overall Attendance',
                          value: '${percentage.toStringAsFixed(1)}%',
                          sub: '$totalAttended / $totalSessions',
                          color: AppColors.accent,
                          icon: Icons.pie_chart_rounded,
                        ),
                        const SizedBox(width: 10),
                        _summaryCard(
                          title: 'Target Status',
                          value: statusLabel,
                          sub: statusTip,
                          color: healthColor,
                          icon: statusIcon,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Calendar with markers
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              _selectedDay != null &&
                              _dateOnly(day) == _dateOnly(_selectedDay!),
                          onDaySelected: _onDaySelected,
                          onPageChanged: (focused) => _focusedDay = focused,
                          headerStyle: const HeaderStyle(
                            titleCentered: true,
                            formatButtonVisible: false,
                            titleTextStyle: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          calendarStyle: const CalendarStyle(
                            todayDecoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle),
                          ),
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, _) {
                              final d = _dateOnly(date);
                              final rec = attendanceByDate[d];
                              if (rec == null) return null;
                              final a = rec.attended;
                              final t = rec.total;
                              if (t == 0) return null;
                              final percent = a / t;
                              final color = (percent * 100) >= widget.targetPercentage
                                  ? AppColors.success
                                  : AppColors.error;
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Pie Chart
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 12),
                        child: Column(
                          children: [
                            const Text(
                              'Attendance Breakdown',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 17),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: AnimatedOpacity(
                                opacity: _animateChart ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 700),
                                child: AspectRatio(
                                  aspectRatio: 1.2,
                                  child: totalSessions == 0
                                      ? Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.pie_chart_outline,
                                                  size: 60,
                                                  color: AppColors.shimmer),
                                              const SizedBox(height: 12),
                                              Text('No data yet',
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .onSurfaceLight)),
                                            ],
                                          ),
                                        )
                                      : Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            PieChart(
                                              PieChartData(
                                                centerSpaceRadius: 75,
                                                sectionsSpace: 4,
                                                startDegreeOffset: -90,
                                                sections: [
                                                  PieChartSectionData(
                                                    color: AppColors.accent,
                                                    value: totalAttended
                                                        .toDouble(),
                                                    radius: 25,
                                                    showTitle: false,
                                                  ),
                                                  PieChartSectionData(
                                                    color: AppColors.error,
                                                    value: missed <= 0
                                                        ? 0
                                                        : missed.toDouble(),
                                                    radius: 20,
                                                    showTitle: false,
                                                  ),
                                                ],
                                              ),
                                              swapAnimationDuration:
                                                  const Duration(
                                                      milliseconds: 1000),
                                              swapAnimationCurve:
                                                  Curves.easeOutCirc,
                                            ),
                                            // Center info
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(statusIcon, color: healthColor, size: 28),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${percentage.toStringAsFixed(1)}%',
                                                  style: TextStyle(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                    color: healthColor,
                                                  ),
                                                ),
                                                Text(
                                                  'Target: ${widget.targetPercentage}%',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.onSurfaceLight.withValues(alpha: 0.7),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Wrap(
                              spacing: 24,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                _legendItem('Attended ($totalAttended)', AppColors.accent),
                                _legendItem('Missed ($missed)', AppColors.error),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required String sub,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.08),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 8),
              Text(title,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(height: 4),
              Text(sub,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
