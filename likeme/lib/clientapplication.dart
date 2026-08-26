import 'package:flutter/material.dart';

class ClientApplicationsScreen extends StatefulWidget {
  final String jobTitle;

  const ClientApplicationsScreen({
    super.key,
    this.jobTitle = 'Fashion Brand Photoshoot',
  });

  @override
  State<ClientApplicationsScreen> createState() =>
      _ClientApplicationsScreenState();
}

class _ClientApplicationsScreenState
    extends State<ClientApplicationsScreen> {
  String selectedFilter = 'All';

  final List<ModelApplication> applications = [
    ModelApplication(
      name: 'Ananya Sharma',
      username: '@ananya.model',
      location: 'Mumbai',
      rating: 4.8,
      aiScore: 94,
      experience: '4 years',
      followers: '128K',
      category: 'Fashion',
      status: ApplicationStatus.applied,
      verified: true,
    ),
    ModelApplication(
      name: 'Riya Kapoor',
      username: '@riya.k',
      location: 'Delhi',
      rating: 4.6,
      aiScore: 89,
      experience: '3 years',
      followers: '87K',
      category: 'Fashion',
      status: ApplicationStatus.shortlisted,
      verified: true,
    ),
    ModelApplication(
      name: 'Meera Singh',
      username: '@meera.singh',
      location: 'Pune',
      rating: 4.9,
      aiScore: 96,
      experience: '5 years',
      followers: '215K',
      category: 'Commercial',
      status: ApplicationStatus.applied,
      verified: true,
    ),
    ModelApplication(
      name: 'Sara Khan',
      username: '@sarakhan',
      location: 'Bangalore',
      rating: 4.2,
      aiScore: 78,
      experience: '2 years',
      followers: '42K',
      category: 'Fashion',
      status: ApplicationStatus.rejected,
      verified: false,
    ),
  ];

  List<ModelApplication> get filteredApplications {
    if (selectedFilter == 'All') {
      return applications;
    }

    return applications.where((application) {
      return application.status.label == selectedFilter;
    }).toList();
  }

  void updateStatus(
    ModelApplication application,
    ApplicationStatus status,
  ) {
    setState(() {
      application.status = status;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${application.name} is now ${status.label.toLowerCase()}.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shortlisted = applications
        .where(
          (a) => a.status == ApplicationStatus.shortlisted,
        )
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'Applicants',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7B2CBF),
                    Color(0xFFE056FD),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Applicants for',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.jobTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      _HeaderStat(
                        value: '${applications.length}',
                        label: 'Applicants',
                      ),
                      const SizedBox(width: 30),
                      _HeaderStat(
                        value: '$shortlisted',
                        label: 'Shortlisted',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Filters
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20),
              children: [
                'All',
                'Applied',
                'Shortlisted',
                'Hired',
                'Rejected',
              ].map((filter) {
                final selected =
                    selectedFilter == filter;

                return Padding(
                  padding:
                      const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor:
                        const Color(0xFF7B2CBF),
                    backgroundColor: Colors.white,
                    side: BorderSide.none,
                    labelStyle: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                30,
              ),
              itemCount: filteredApplications.length,
              itemBuilder: (context, index) {
                final application =
                    filteredApplications[index];

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 14),
                  child: ApplicantCard(
                    application: application,
                    onView: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ModelApplicantDetailsScreen(
                            application: application,
                            onStatusChanged: (status) {
                              updateStatus(
                                application,
                                status,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// APPLICANT CARD
// ============================================================

class ApplicantCard extends StatelessWidget {
  final ModelApplication application;
  final VoidCallback onView;

  const ApplicantCard({
    super.key,
    required this.application,
    required this.onView,
  });

  Color get statusColor {
    switch (application.status) {
      case ApplicationStatus.applied:
        return Colors.blue;
      case ApplicationStatus.shortlisted:
        return Colors.orange;
      case ApplicationStatus.hired:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onView,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7B2CBF),
                        Color(0xFFE056FD),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              application.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (application.verified) ...[
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        application.username,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        application.location,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        statusColor.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Text(
                    application.status.label,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _ApplicantStat(
                    title: 'Rating',
                    value:
                        '${application.rating}',
                    icon: Icons.star,
                  ),
                ),
                Expanded(
                  child: _ApplicantStat(
                    title: 'AI Score',
                    value:
                        '${application.aiScore}/100',
                    icon: Icons.auto_awesome,
                  ),
                ),
                Expanded(
                  child: _ApplicantStat(
                    title: 'Experience',
                    value:
                        application.experience,
                    icon: Icons.work_outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Text(
                  '${application.followers} followers',
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                const Text(
                  'View Profile',
                  style: TextStyle(
                    color: Color(0xFF7B2CBF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 10,
                  color: Color(0xFF7B2CBF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MODEL DETAILS
// ============================================================

class ModelApplicantDetailsScreen
    extends StatelessWidget {
  final ModelApplication application;
  final Function(ApplicationStatus) onStatusChanged;

  const ModelApplicantDetailsScreen({
    super.key,
    required this.application,
    required this.onStatusChanged,
  });

  void confirmAction(
    BuildContext context,
    ApplicationStatus status,
  ) {
    final title = status == ApplicationStatus.hired
        ? 'Hire ${application.name}?'
        : status == ApplicationStatus.shortlisted
            ? 'Shortlist ${application.name}?'
            : 'Reject application?';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(
          'This will update the application status.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onStatusChanged(status);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF7B2CBF),
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'Model Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          5,
          20,
          120,
        ),
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Container(
                    width: 95,
                    height: 95,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF7B2CBF),
                          Color(0xFFE056FD),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        application.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (application.verified) ...[
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.verified,
                          color: Colors.blue,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    application.username,
                    style: const TextStyle(
                      color: Colors.black45,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [
                      _ProfileStat(
                        value:
                            '${application.rating}',
                        label: 'Rating',
                      ),
                      _ProfileStat(
                        value:
                            application.followers,
                        label: 'Followers',
                      ),
                      _ProfileStat(
                        value:
                            application.experience,
                        label: 'Experience',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // AI score
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFF3E5F5),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color:
                              Color(0xFF7B2CBF),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'LikeMe AI Score',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      '${application.aiScore}',
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color:
                            Color(0xFF7B2CBF),
                      ),
                    ),
                  ),

                  const Center(
                    child: Text(
                      'out of 100',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _ScoreBar(
                    title: 'Portfolio',
                    score: application.aiScore - 2,
                  ),
                  _ScoreBar(
                    title: 'Engagement',
                    score: application.aiScore - 5,
                  ),
                  _ScoreBar(
                    title: 'Consistency',
                    score: application.aiScore - 1,
                  ),
                  _ScoreBar(
                    title: 'Professionalism',
                    score: application.aiScore,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Portfolio
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Portfolio',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Expanded(
                        child: Container(
                          height: 105,
                          margin: EdgeInsets.only(
                            right:
                                index == 2 ? 0 : 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFF3E5F5),
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                          child: const Icon(
                            Icons.image_outlined,
                            color:
                                Color(0xFF7B2CBF),
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Actions
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(
          15,
          12,
          15,
          20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => confirmAction(
                  context,
                  ApplicationStatus.rejected,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                  minimumSize:
                      const Size(0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                ),
                child: const Text('Reject'),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: OutlinedButton(
                onPressed: () => confirmAction(
                  context,
                  ApplicationStatus.shortlisted,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(0xFF7B2CBF),
                  side: const BorderSide(
                    color: Color(0xFF7B2CBF),
                  ),
                  minimumSize:
                      const Size(0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                ),
                child: const Text('Shortlist'),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: ElevatedButton(
                onPressed: () => confirmAction(
                  context,
                  ApplicationStatus.hired,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF7B2CBF),
                  foregroundColor: Colors.white,
                  minimumSize:
                      const Size(0, 50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                ),
                child: const Text('Hire'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SMALL WIDGETS
// ============================================================

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeaderStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _ApplicantStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ApplicantStat({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 17,
          color: const Color(0xFF7B2CBF),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black38,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final String title;
  final int score;

  const _ScoreBar({
    required this.title,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final safeScore = score.clamp(0, 100);

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              Text(
                '$safeScore',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: safeScore / 100,
              minHeight: 7,
              backgroundColor:
                  Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation(
                Color(0xFF7B2CBF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DATA
// ============================================================

enum ApplicationStatus {
  applied,
  shortlisted,
  hired,
  rejected,
}

extension ApplicationStatusExtension
    on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.hired:
        return 'Hired';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }
}

class ModelApplication {
  final String name;
  final String username;
  final String location;
  final double rating;
  final int aiScore;
  final String experience;
  final String followers;
  final String category;
  final bool verified;
  ApplicationStatus status;

  ModelApplication({
    required this.name,
    required this.username,
    required this.location,
    required this.rating,
    required this.aiScore,
    required this.experience,
    required this.followers,
    required this.category,
    required this.status,
    required this.verified,
  });
}