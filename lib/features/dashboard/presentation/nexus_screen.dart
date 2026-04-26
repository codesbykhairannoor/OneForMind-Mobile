import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class NexusScreen extends StatelessWidget {
  const NexusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'The Nexus',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
              ),
              Text(
                'Unified Life Systems',
                style: const TextStyle(fontSize: 16, color: AppTheme.slate500, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              _buildNexusGrid(context),
              const SizedBox(height: 32),
              _buildProfileCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNexusGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        _buildNexusItem(Icons.auto_awesome, 'Habits', 'Atomic System', const Color(0xFF4F46E5)),
        _buildNexusItem(Icons.track_changes, 'Goals', 'Manifestation', const Color(0xFF10B981)),
        _buildNexusItem(Icons.business_center, 'Jobs', 'Career Pipeline', const Color(0xFFF59E0B)),
        _buildNexusItem(Icons.calendar_month, 'Calendar', 'Time Mastery', const Color(0xFF8B5CF6)),
      ],
    );
  }

  Widget _buildNexusItem(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.slate100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          Text(subtitle, style: const TextStyle(color: AppTheme.slate400, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 28, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User Architect', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Quantum Tier Active', style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.white60)),
        ],
      ),
    );
  }
}
