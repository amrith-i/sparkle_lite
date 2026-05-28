import '../../../../../../core_import.dart';

class DeskPainSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const DeskPainSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: HomeColors.primaryRed,
              inactiveTrackColor: const Color(0xFFEEE5F5),
              thumbColor: HomeColors.primaryRed,
              overlayColor: HomeColors.primaryRed.withOpacity(0.1),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(11, (i) {
                return Text(
                  '$i',
                  style: TextStyle(
                    fontSize: 11,
                    color: value.round() == i
                        ? HomeColors.primaryRed
                        : const Color(0xFFB0A0C0),
                    fontWeight: value.round() == i
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Text(
                'No pain',
                style: TextStyle(fontSize: 11, color: Color(0xFFB0A0C0)),
              ),
              Spacer(),
              Text(
                'Severe',
                style: TextStyle(fontSize: 11, color: Color(0xFFB0A0C0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
