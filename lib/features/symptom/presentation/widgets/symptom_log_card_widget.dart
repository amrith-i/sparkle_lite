import '../../../../core_import.dart';

class SymptomLogCardWidget extends StatelessWidget {
  final SymptomLogEntity log;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SymptomLogCardWidget({
    super.key,
    required this.log,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final painColor = _painColor(log.painLevel);

    return Container(
      width: double.infinity,
      padding: SymptomPaddings.cardPadding(context),
      decoration: SymptomDecorations.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Date + Mood ────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(log.date),
                style: SymptomTextStyles.cardDate(context),
              ),
              Row(
                children: [
                  Text(
                    _moodEmoji(log.mood),
                    style: TextStyle(fontSize: context.sp(mobile: 18)),
                  ),
                  SizedBox(width: context.w(mobile: 4)),
                  Text(log.mood, style: SymptomTextStyles.moodLabel(context)),
                ],
              ),
            ],
          ),

          SizedBox(height: context.h(mobile: 10)),

          // ── Tags ───────────────────────────────────────────────────
          Wrap(
            spacing: context.w(mobile: 6),
            runSpacing: context.h(mobile: 6),
            children: [
              _PeriodStatusTag(status: log.periodStatus),
              if (log.flowLevel != 'None') _FlowTag(flow: log.flowLevel),
              ...log.symptoms.map((s) => _SymptomTag(label: s)),
            ],
          ),

          SizedBox(height: context.h(mobile: 12)),

          // ── Pain Level Bar ─────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.r(mobile: 4)),
                  child: LinearProgressIndicator(
                    value: log.painLevel / 10,
                    minHeight: context.h(mobile: 6),
                    backgroundColor: SymptomColors.progressTrack,
                    valueColor: AlwaysStoppedAnimation<Color>(painColor),
                  ),
                ),
              ),
              SizedBox(width: context.w(mobile: 8)),
              Text(
                '${log.painLevel}/10',
                style: SymptomTextStyles.painScore(context, painColor),
              ),
            ],
          ),

          // ── Notes ──────────────────────────────────────────────────
          if (log.notes != null && log.notes!.isNotEmpty) ...[
            SizedBox(height: context.h(mobile: 10)),
            Text('"${log.notes}"', style: SymptomTextStyles.notes(context)),
          ],

          SizedBox(height: context.h(mobile: 12)),

          // ── Action Buttons ─────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionButton(
                label: 'Edit',
                onTap: onEdit,
                borderColor: SymptomColors.editBtnBorder,
                textColor: SymptomColors.editBtnText,
              ),
              SizedBox(width: context.w(mobile: 8)),
              _ActionButton(
                label: 'Delete',
                onTap: onDelete,
                borderColor: SymptomColors.deleteBtnBorder,
                textColor: SymptomColors.deleteBtnText,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _painColor(int level) {
    if (level <= 3) return SymptomColors.painLow;
    if (level <= 6) return SymptomColors.painMid;
    return SymptomColors.painHigh;
  }

  String _moodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
        return '😊';
      case 'anxious':
        return '😟';
      case 'tired':
        return '😴';
      case 'irritable':
        return '😤';
      case 'happy':
        return '😄';
      case 'sad':
        return '😢';
      default:
        return '😐';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ─── Period Status Tag ────────────────────────────────────────────────────────

class _PeriodStatusTag extends StatelessWidget {
  final String status;
  const _PeriodStatusTag({required this.status});

  @override
  Widget build(BuildContext context) {
    final bg = _bg(status);
    final text = _text(status);
    return _Tag(label: status, bg: bg, textColor: text);
  }

  Color _bg(String s) {
    switch (s) {
      case 'Period ongoing':
        return SymptomColors.periodOngoingBg;
      case 'Period started':
        return SymptomColors.periodStartedBg;
      case 'Period ended':
        return SymptomColors.periodEndedBg;
      default:
        return SymptomColors.noPeriodBg;
    }
  }

  Color _text(String s) {
    switch (s) {
      case 'Period ongoing':
        return SymptomColors.periodOngoingText;
      case 'Period started':
        return SymptomColors.periodStartedText;
      case 'Period ended':
        return SymptomColors.periodEndedText;
      default:
        return SymptomColors.noPeriodText;
    }
  }
}

// ─── Flow Tag ─────────────────────────────────────────────────────────────────

class _FlowTag extends StatelessWidget {
  final String flow;
  const _FlowTag({required this.flow});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    switch (flow) {
      case 'Light':
        bg = SymptomColors.flowLightBg;
        text = SymptomColors.flowLightText;
        break;
      case 'Medium':
        bg = SymptomColors.flowMediumBg;
        text = SymptomColors.flowMediumText;
        break;
      case 'Heavy':
        bg = SymptomColors.flowHeavyBg;
        text = SymptomColors.flowHeavyText;
        break;
      default:
        bg = SymptomColors.flowNoneBg;
        text = SymptomColors.flowNoneText;
    }
    return _Tag(label: 'Flow: $flow', bg: bg, textColor: text);
  }
}

// ─── Symptom Tag ──────────────────────────────────────────────────────────────

class _SymptomTag extends StatelessWidget {
  final String label;
  const _SymptomTag({required this.label});

  @override
  Widget build(BuildContext context) => _Tag(
    label: label,
    bg: SymptomColors.symptomTagBg,
    textColor: SymptomColors.symptomTagText,
  );
}

// ─── Generic Tag ──────────────────────────────────────────────────────────────

class _Tag extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;
  const _Tag({required this.label, required this.bg, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(mobile: 10),
        vertical: context.h(mobile: 4),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.r(mobile: 20)),
      ),
      child: Text(
        label,
        style: SymptomTextStyles.tagText(context).copyWith(color: textColor),
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color borderColor;
  final Color textColor;

  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(mobile: 20),
          vertical: context.h(mobile: 8),
        ),
        decoration: BoxDecoration(
          color: SymptomColors.white,
          borderRadius: BorderRadius.circular(context.r(mobile: 20)),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: SymptomTextStyles.actionBtn(
            context,
          ).copyWith(color: textColor),
        ),
      ),
    );
  }
}
