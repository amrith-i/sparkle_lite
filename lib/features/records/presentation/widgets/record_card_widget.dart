import '../../../../core_import.dart';

class RecordCardWidget extends StatelessWidget {
  final HealthRecordEntity record;
  final VoidCallback onDelete;

  const RecordCardWidget({
    super.key,
    required this.record,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: RecordsPaddings.cardPadding(context),
      decoration: RecordsDecorations.card(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon ──────────────────────────────────────────────────
          Container(
            width: context.w(mobile: 44),
            height: context.w(mobile: 44),
            decoration: RecordsDecorations.iconContainer(context),
            child: Center(
              child: Text(
                _iconForType(record.recordType),
                style: TextStyle(fontSize: context.sp(mobile: 22)),
              ),
            ),
          ),

          SizedBox(width: context.w(mobile: 12)),

          // ── Content ───────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(record.title, style: RecordsTextStyles.cardTitle(context)),

                SizedBox(height: context.h(mobile: 4)),

                // Date · Doctor
                Text(
                  _buildMeta(record),
                  style: RecordsTextStyles.cardMeta(context),
                ),

                // Notes
                if (record.notes != null && record.notes!.isNotEmpty) ...[
                  SizedBox(height: context.h(mobile: 4)),
                  Text(
                    '"${record.notes}"',
                    style: RecordsTextStyles.cardNotes(context),
                  ),
                ],

                SizedBox(height: context.h(mobile: 10)),

                // ── Bottom Row: Tag + Delete ───────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RecordTypeTag(recordType: record.recordType),
                    _DeleteButton(onTap: onDelete, context: context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildMeta(HealthRecordEntity record) {
    final datePart = _formatDate(record.date);
    if (record.doctorName != null && record.doctorName!.isNotEmpty) {
      return '$datePart · ${record.doctorName}';
    }
    return datePart;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _iconForType(String type) {
    switch (type) {
      case 'Lab Report':
        return RecordsIcons.labReport;
      case 'Prescription':
        return RecordsIcons.prescription;
      case 'Scan Report':
        return RecordsIcons.scanReport;
      case 'Doctor Visit Note':
        return RecordsIcons.doctorVisitNote;
      default:
        return RecordsIcons.other;
    }
  }
}

// ─── Record Type Tag ──────────────────────────────────────────────────────────

class _RecordTypeTag extends StatelessWidget {
  final String recordType;

  const _RecordTypeTag({required this.recordType});

  @override
  Widget build(BuildContext context) {
    final bg = _bg(recordType);
    final textColor = _textColor(recordType);

    return Container(
      padding: RecordsPaddings.tagPadding(context),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.r(mobile: 20)),
      ),
      child: Text(
        recordType,
        style: RecordsTextStyles.tagText(context).copyWith(color: textColor),
      ),
    );
  }

  Color _bg(String type) {
    switch (type) {
      case 'Lab Report':
        return RecordsColors.labReportBg;
      case 'Prescription':
        return RecordsColors.prescriptionBg;
      case 'Scan Report':
        return RecordsColors.scanReportBg;
      case 'Doctor Visit Note':
        return RecordsColors.doctorVisitNoteBg;
      default:
        return RecordsColors.otherBg;
    }
  }

  Color _textColor(String type) {
    switch (type) {
      case 'Lab Report':
        return RecordsColors.labReportText;
      case 'Prescription':
        return RecordsColors.prescriptionText;
      case 'Scan Report':
        return RecordsColors.scanReportText;
      case 'Doctor Visit Note':
        return RecordsColors.doctorVisitNoteText;
      default:
        return RecordsColors.otherText;
    }
  }
}

// ─── Delete Button ────────────────────────────────────────────────────────────

class _DeleteButton extends StatelessWidget {
  final VoidCallback onTap;
  final BuildContext context;

  const _DeleteButton({required this.onTap, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(mobile: 20),
          vertical: context.h(mobile: 8),
        ),
        decoration: BoxDecoration(
          color: RecordsColors.white,
          borderRadius: BorderRadius.circular(context.r(mobile: 20)),
          border: Border.all(color: RecordsColors.deleteBtnBorder),
        ),
        child: Text('Delete', style: RecordsTextStyles.deleteBtn(context)),
      ),
    );
  }
}
