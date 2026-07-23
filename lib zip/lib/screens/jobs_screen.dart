import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../widgets/main_bottom_nav.dart';

/// Active Jobs tab — tabs for Assigned / In Progress / Job History, a
/// booking-id search field, and a list of job cards.
class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _Job {
  final String bookingId;
  final String title;
  final String customer;
  final String location;
  final String schedule;
  final String price;
  final String status;

  const _Job({
    required this.bookingId,
    required this.title,
    required this.customer,
    required this.location,
    required this.schedule,
    required this.price,
    required this.status,
  });
}

class _JobsScreenState extends State<JobsScreen> {
  int _tabIndex = 0;
  final _searchController = TextEditingController();
  String _query = '';

  static const _tabs = ['Assigned', 'In Progress', 'Job History'];

  static const _assignedJobs = [
    _Job(
      bookingId: '#BK-8821',
      title: 'Deep Cleaning',
      customer: 'Mrs. Ananya Gupta',
      location: 'HSR Layout, Sector 2, Bengaluru',
      schedule: 'Today • 10:00 AM - 12:00 PM',
      price: '₹1,250',
      status: 'ASSIGNED',
    ),
    _Job(
      bookingId: '#BK-8845',
      title: 'AC Service - Repair',
      customer: 'Vikram Singh',
      location: 'Koramangala 4th Block',
      schedule: 'Today • 02:30 PM - 04:00 PM',
      price: '₹850',
      status: 'ASSIGNED',
    ),
    _Job(
      bookingId: '#BK-8890',
      title: 'Plumbing Leakage',
      customer: 'Sandeep Reddy',
      location: 'Indiranagar 80ft Road',
      schedule: 'Today • 05:00 PM - 06:00 PM',
      price: '₹450',
      status: 'ASSIGNED',
    ),
  ];

  List<_Job> get _currentJobs {
    final jobs = _tabIndex == 0 ? _assignedJobs : const <_Job>[];
    if (_query.isEmpty) return jobs;
    return jobs
        .where((j) => j.bookingId.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startJob(_Job job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting ${job.title} (${job.bookingId})')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      bottomNavigationBar: const MainBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _tabBar(),
            _searchField(),
            Expanded(
              child: _currentJobs.isEmpty
                  ? Center(
                      child: Text(
                        'No jobs here yet',
                        style: GoogleFonts.poppins(
                          color: kTextGrey,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                      itemCount: _currentJobs.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, i) => _JobCard(
                        job: _currentJobs[i],
                        onStart: () => _startJob(_currentJobs[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Active Jobs',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: kTextDark,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFEFEFEF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune, color: kTextDark, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          for (var i = 0; i < _tabs.length; i++) ...[
            GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _tabIndex == i ? kRed : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  _tabs[i],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _tabIndex == i ? kRed : kTextGrey,
                  ),
                ),
              ),
            ),
            if (i != _tabs.length - 1) const SizedBox(width: 24),
          ],
        ],
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v),
          style: GoogleFonts.poppins(fontSize: 14, color: kTextDark),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: kTextGrey, size: 20),
            hintText: 'Search Booking ID',
            hintStyle: GoogleFonts.poppins(color: kTextGrey, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final _Job job;
  final VoidCallback onStart;

  const _JobCard({required this.job, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BOOKING ID: ${job.bookingId}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: kTextGrey,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kTextDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      job.customer,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    job.price,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kRed,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      job.status,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: kTextDark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: kTextGrey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  job.location,
                  style: GoogleFonts.poppins(fontSize: 12.5, color: kTextGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 15, color: kTextGrey),
              const SizedBox(width: 6),
              Text(
                job.schedule,
                style: GoogleFonts.poppins(fontSize: 12.5, color: kTextGrey),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Start Job',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
