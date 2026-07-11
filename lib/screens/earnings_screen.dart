import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../widgets/main_bottom_nav.dart';
import 'placeholder_screen.dart';

/// Earnings & Wallet screen — balance card, today/week/month stats, a
/// weekly/monthly earnings-vs-jobs chart, and withdrawal history entry point.
class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  bool _weekly = true;

  static const _weeklyLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _weeklyEarnings = [1500.0, 3000.0, 3800.0, 2200.0, 4800.0, 4200.0, 1800.0];
  static const _weeklyJobs = [2.0, 3.0, 6.0, 2.0, 5.0, 3.0, 7.0];

  static const _monthlyLabels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
  static const _monthlyEarnings = [7200.0, 9400.0, 8100.0, 9380.0];
  static const _monthlyJobs = [14.0, 19.0, 16.0, 18.0];

  void _open(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      bottomNavigationBar: const MainBottomNav(currentIndex: 2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 16),
              _balanceCard(),
              const SizedBox(height: 14),
              _statsRow(),
              const SizedBox(height: 18),
              _analyticsCard(),
              const SizedBox(height: 18),
              _withdrawalHistoryHeader(),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Top bar: title + wallet icon ----
  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Earnings & Wallet',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kTextDark,
          ),
        ),
        InkWell(
          onTap: () => _open('Wallet'),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kRed),
            ),
            child: const Icon(Icons.credit_card, color: kRed, size: 20),
          ),
        ),
      ],
    );
  }

  // ---- Wallet balance card ----
  Widget _balanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFE23553), kRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Balance',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₹24,850',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () => _open('Withdraw Money'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: kRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.account_balance, size: 18),
              label: Text(
                'Withdraw Money',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Today / This Week / This Month ----
  Widget _statsRow() {
    return const Row(
      children: [
        Expanded(child: _StatTile(label: 'TODAY', value: '₹1,240')),
        SizedBox(width: 10),
        Expanded(child: _StatTile(label: 'THIS WEEK', value: '₹8,580')),
        SizedBox(width: 10),
        Expanded(child: _StatTile(label: 'THIS MONTH', value: '₹34,120')),
      ],
    );
  }

  // ---- Earnings & Jobs Analytics card ----
  Widget _analyticsCard() {
    final labels = _weekly ? _weeklyLabels : _monthlyLabels;
    final earnings = _weekly ? _weeklyEarnings : _monthlyEarnings;
    final jobs = _weekly ? _weeklyJobs : _monthlyJobs;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Earnings & Jobs Analytics',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kTextDark,
                  ),
                ),
              ),
              _periodToggle(),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 190,
            child: _EarningsChart(labels: labels, earnings: earnings, jobs: jobs),
          ),
          const SizedBox(height: 14),
          _chartLegend(),
        ],
      ),
    );
  }

  Widget _periodToggle() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _periodButton('Weekly', true),
          _periodButton('Monthly', false),
        ],
      ),
    );
  }

  Widget _periodButton(String label, bool value) {
    final selected = _weekly == value;
    return GestureDetector(
      onTap: () => setState(() => _weekly = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: selected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4)]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? kTextDark : kTextGrey,
          ),
        ),
      ),
    );
  }

  Widget _chartLegend() {
    return Row(
      children: [
        _legendDot(kRed, 'Earnings (₹)'),
        const SizedBox(width: 18),
        _legendDot(const Color(0xFFD9D9D9), 'Job Count'),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: kTextGrey)),
      ],
    );
  }

  // ---- Withdrawal History header ----
  Widget _withdrawalHistoryHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Withdrawal History',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
          InkWell(
            onTap: () => _open('Withdrawal History'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View all',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kRed,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: kRed, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single TODAY / THIS WEEK / THIS MONTH tile: small grey uppercase label
/// above a bold amount, in a white rounded box.
class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: kTextGrey,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Combo bar (job count) + line (earnings) chart, hand-drawn with
/// CustomPainter so it matches the design exactly without a chart
/// dependency.
class _EarningsChart extends StatelessWidget {
  final List<String> labels;
  final List<double> earnings;
  final List<double> jobs;

  const _EarningsChart({required this.labels, required this.earnings, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ChartPainter(labels: labels, earnings: earnings, jobs: jobs),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<String> labels;
  final List<double> earnings;
  final List<double> jobs;

  _ChartPainter({required this.labels, required this.earnings, required this.jobs});

  @override
  void paint(Canvas canvas, Size size) {
    const leftAxisWidth = 36.0;
    const bottomLabelHeight = 20.0;
    final chartRect = Rect.fromLTWH(
      leftAxisWidth,
      0,
      size.width - leftAxisWidth,
      size.height - bottomLabelHeight,
    );

    final maxEarnings = earnings.reduce((a, b) => a > b ? a : b);
    final earningsCeil = (((maxEarnings / 2500).ceil() * 2500).toDouble()).clamp(2500.0, double.infinity);
    final maxJobs = jobs.reduce((a, b) => a > b ? a : b);

    _drawGrid(canvas, chartRect, earningsCeil);
    _drawBars(canvas, chartRect, maxJobs);
    _drawLine(canvas, chartRect, earningsCeil);
    _drawXLabels(canvas, chartRect, size);
  }

  void _drawGrid(Canvas canvas, Rect chartRect, double earningsCeil) {
    final gridPaint = Paint()
      ..color = kDivider.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    final textStyle = TextStyle(fontSize: 10, color: kTextGrey);

    for (final fraction in [1.0, 0.5]) {
      final y = chartRect.top + chartRect.height * (1 - fraction);
      canvas.drawLine(Offset(chartRect.left, y), Offset(chartRect.right, y), gridPaint);

      final value = earningsCeil * fraction;
      final label = value >= 1000 ? '₹${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k' : '₹${value.toStringAsFixed(0)}';
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(chartRect.left - tp.width - 6, y - tp.height / 2));
    }
  }

  void _drawBars(Canvas canvas, Rect chartRect, double maxJobs) {
    final barPaint = Paint()..color = const Color(0xFFD9D9D9);
    final n = jobs.length;
    final slot = chartRect.width / n;
    final barWidth = slot * 0.4;

    for (var i = 0; i < n; i++) {
      final centerX = chartRect.left + slot * (i + 0.5);
      final h = maxJobs == 0 ? 0.0 : (jobs[i] / maxJobs) * chartRect.height * 0.85;
      final rect = Rect.fromLTWH(centerX - barWidth / 2, chartRect.bottom - h, barWidth, h);
      canvas.drawRRect(
        RRect.fromRectAndCorners(rect, topLeft: const Radius.circular(3), topRight: const Radius.circular(3)),
        barPaint,
      );
    }
  }

  void _drawLine(Canvas canvas, Rect chartRect, double earningsCeil) {
    final linePaint = Paint()
      ..color = kRed
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final dotPaint = Paint()..color = kRed;

    final n = earnings.length;
    final slot = chartRect.width / n;
    final points = <Offset>[];
    for (var i = 0; i < n; i++) {
      final centerX = chartRect.left + slot * (i + 0.5);
      final y = chartRect.bottom - (earnings[i] / earningsCeil) * chartRect.height;
      points.add(Offset(centerX, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, linePaint);

    for (final p in points) {
      canvas.drawCircle(p, 3.5, dotPaint);
      canvas.drawCircle(p, 3.5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }
  }

  void _drawXLabels(Canvas canvas, Rect chartRect, Size size) {
    final textStyle = TextStyle(fontSize: 10, color: kTextGrey);
    final n = labels.length;
    final slot = chartRect.width / n;
    for (var i = 0; i < n; i++) {
      final centerX = chartRect.left + slot * (i + 0.5);
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(centerX - tp.width / 2, size.height - bottomLabelHeightConst + 4));
    }
  }

  static const bottomLabelHeightConst = 20.0;

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      oldDelegate.labels != labels || oldDelegate.earnings != earnings || oldDelegate.jobs != jobs;
}
