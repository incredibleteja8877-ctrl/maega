import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/app_data_provider.dart';
import '../widgets/main_bottom_nav.dart';
import 'placeholder_screen.dart';
import 'earnings_screen.dart';

/// Home screen — matches the assignment screenshot.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOnline = false;

  void _open(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)),
    );
  }

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const MainBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Consumer<AppDataProvider>(
          builder: (context, appData, _) {
            final profile = appData.profile;
            final name = (profile['name'] as String?) ?? '';
            final firstName = name.trim().isEmpty
                ? 'Technician'
                : name.trim().split(RegExp(r'\s+')).first;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(firstName, _initials(name)),
                  const SizedBox(height: 16),
                  _onlineToggle(),
                  if (_isOnline) ...[
                    const SizedBox(height: 16),
                    _statsRow(),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _quickActions(),
                  const SizedBox(height: 22),
                  _newsHeader(),
                  const SizedBox(height: 12),
                  _newsList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header(String firstName, String initials) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey, $firstName! 👋',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _isOnline ? 'Waiting for new job requests' : "You're currently offline",
                style: GoogleFonts.poppins(fontSize: 13, color: kTextGrey),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(color: kRed, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _onlineToggle() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isOnline ? kRed : kTextGrey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _isOnline ? "You're Online" : "You're Offline",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: kTextDark,
            ),
          ),
          const Spacer(),
          Switch(
            value: _isOnline,
            activeColor: Colors.white,
            activeTrackColor: kRed,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFF3A3A3A),
            onChanged: (v) => setState(() => _isOnline = v),
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
              icon: Icons.access_time, label: 'PENDING', value: '0'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
              icon: Icons.inventory_2_outlined,
              label: 'COMPLETED',
              value: '5'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
              icon: Icons.currency_rupee, label: 'EARNINGS', value: '₹2,450'),
        ),
      ],
    );
  }

  Widget _quickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.6,
      children: [
        _QuickAction(
          imagePath: 'assets/images/All orders.png',
          label: 'All Orders',
          onTap: () => _open('All Orders'),
        ),
        _QuickAction(
          icon: Icons.handyman_outlined,
          label: 'Spare Parts',
          onTap: () => _open('Spare Parts'),
        ),
        _QuickAction(
          icon: Icons.trending_up,
          label: 'Earnings',
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const EarningsScreen()),
          ),
        ),
        _QuickAction(
          icon: Icons.calendar_today_outlined,
          label: 'Schedule',
          onTap: () => _open('Schedule'),
        ),
      ],
    );
  }

  Widget _newsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'News & Training',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: kTextDark,
          ),
        ),
        GestureDetector(
          onTap: () => _open('News & Training'),
          child: Text(
            'VIEW ALL',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: kRed,
            ),
          ),
        ),
      ],
    );
  }

  Widget _newsList() {
    return SizedBox(
      height: 190,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _NewsCard(
            tag: 'TRAINING',
            tagColor: kRed,
            title: 'Safety Training 101',
            description: 'Essential on-site safety protocols.',
            showPlay: true,
            imageUrl: 'https://picsum.photos/seed/safety-training/400/200',
            onTap: () => _open('Safety Training 101'),
          ),
          const SizedBox(width: 12),
          _NewsCard(
            tag: 'ADMIN NEWS',
            tagColor: kRed,
            title: 'New Incentive Program',
            description: 'Earn rewards for more th...',
            showPlay: true,
            imageUrl: 'https://picsum.photos/seed/incentive-program/400/200',
            onTap: () => _open('New Incentive Program'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFFBE3E8),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: kRed, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: kTextGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    this.icon,
    this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kDivider),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFFBE3E8),
                shape: BoxShape.circle,
              ),
              child: imagePath != null
                  ? Padding(
                      padding: const EdgeInsets.all(7),
                      child: Image.asset(imagePath!, color: kRed),
                    )
                  : Icon(icon, color: kRed, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kTextDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String tag;
  final Color tagColor;
  final String title;
  final String description;
  final bool showPlay;
  final String imageUrl;
  final VoidCallback onTap;

  const _NewsCard({
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.description,
    required this.showPlay,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kDivider),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 96,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.3),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        tagColor.withOpacity(0.35),
                        BlendMode.darken,
                      ),
                      onError: (_, _) {},
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (showPlay)
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.play_arrow_rounded,
                            color: kRed, size: 26),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.poppins(fontSize: 11, color: kTextGrey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
