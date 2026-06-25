import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SubjectCard extends StatelessWidget {
  final String subjectName;
  final int attended;
  final int total;
  final int targetPercentage;
  final VoidCallback? onTap;

  const SubjectCard({
    super.key,
    required this.subjectName,
    required this.attended,
    required this.total,
    this.targetPercentage = 75,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage =
        total == 0 ? 0 : (attended / total * 100).clamp(0, 100);
    final double target = targetPercentage / 100;

    // Safe leaves: how many more classes you can skip and still meet target
    final int safeLeaves = total == 0
        ? 0
        : ((attended / target).floor() - total).clamp(0, total);

    // Health Status Logic
    String statusLabel;
    String statusTip;
    IconData statusIcon;
    Color healthColor;

    if (total == 0) {
      statusLabel = 'No Data';
      statusTip = 'Add attendance to see status';
      statusIcon = Icons.help_outline_rounded;
      healthColor = AppColors.onSurfaceLight;
    } else if (percentage >= targetPercentage) {
      healthColor = AppColors.success;
      if (safeLeaves > 0) {
        statusLabel = 'Safe';
        statusTip = 'You can skip $safeLeaves session${safeLeaves > 1 ? 's' : ''}';
        statusIcon = Icons.check_circle_outline_rounded;
      } else {
        statusLabel = 'On Track';
        statusTip = 'Don\'t miss the next class';
        statusIcon = Icons.trending_up_rounded;
      }
    } else {
      if (percentage >= (targetPercentage - 10)) {
        statusLabel = 'Caution';
        statusTip = 'Prioritize attending next classes';
        statusIcon = Icons.warning_amber_rounded;
        healthColor = AppColors.warning;
      } else {
        statusLabel = 'Below Target';
        statusTip = 'Consistent attendance required';
        statusIcon = Icons.error_outline_rounded;
        healthColor = AppColors.error;
      }
    }

    return SizedBox(
      height: 155,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular Percentage Indicator
                SizedBox(
                  height: 70,
                  width: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        constraints: const BoxConstraints(
                          minHeight: 60,
                          minWidth: 60,
                        ),
                        value: percentage / 100,
                        backgroundColor: Colors.grey.shade300,
                        color: healthColor,
                        strokeWidth: 7,
                      ),
                      Text(
                        '${percentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 18),

                // Subject Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subjectName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Attended: $attended / $total',
                        style: const TextStyle(
                          color: AppColors.onSurfaceLight,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Health Status Badge/Row
                      Row(
                        children: [
                          Icon(
                            statusIcon,
                            color: healthColor,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  statusLabel,
                                  style: TextStyle(
                                    color: healthColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  statusTip,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.onSurfaceLight.withValues(alpha: 0.8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
