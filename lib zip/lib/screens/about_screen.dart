import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/maega_logo.dart';
import '../widgets/section_app_bar.dart';

/// About screen — brand header, description, and footer logo.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _about =
      "Maega Is A Modern Urban Services Company Committed To Making Everyday "
      "Life Easier, Safer, And More Convenient. We Connect Customers With "
      "Trained, Verified, And Reliable Professionals To Deliver High-Quality "
      "Services Right At Their Doorstep. Built For Today's Fast-Paced Urban "
      "Lifestyle, Maega Focuses On Trust, Transparency, And Efficiency. From "
      "Seamless Booking To On-Time Service Delivery, Every Step Is Designed To "
      "Provide A Smooth And Hassle-Free Experience. We Work Only With Skilled "
      "Experts Who Follow Strict Quality And Hygiene Standards To Ensure "
      "Customer Satisfaction Every Time.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: backAppBar('About'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              children: [
                // Brand header card
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kDivider),
                  ),
                  child: Row(
                    children: const [
                      MaegaLogo(width: 70, height: 70),
                      SizedBox(width: 14),
                      Text(
                        'Maega',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kTextDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Description card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kDivider),
                  ),
                  child: const Text(
                    _about,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      color: kTextDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Footer logo + version
          Column(
            children: const [
              MaegaLogo(),
              SizedBox(height: 6),
              Text(
                'Maega V1.0',
                style: TextStyle(color: kTextGrey, fontSize: 13),
              ),
              SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
