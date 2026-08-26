import 'package:flutter/material.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() =>
      _MyApplicationsScreenState();
}

class _MyApplicationsScreenState
    extends State<MyApplicationsScreen> {
  String selectedFilter = 'All';

  final List<Application> applications = [
    Application(
      jobTitle: 'Fashion Brand Photoshoot',
      company: 'Urban Vogue',
      location: 'Mumbai',
      budget: 25000,
      date: '15 Sep 2026',
      status: ApplicationStatus.applied,
    ),
    Application(
      jobTitle: 'Instagram Brand Campaign',
      company: 'Glow Cosmetics',
      location: 'Delhi',
      budget: 18000,
      date: '22 Sep 2026',
      status: ApplicationStatus.shortlisted,
    ),
    Application(
      jobTitle: 'Fitness Product Shoot',
      company: 'FitPro India',
      location: 'Bangalore',
      budget: 30000,
      date: '05 Oct 2026',
      status: ApplicationStatus.interview,
    ),
    Application(
      jobTitle: 'New Clothing Collection',
      company: 'StyleHub',
      location: 'Pune',
      budget: 22000,
      date: '12 Oct 2026',
      status: ApplicationStatus.hired,
    ),
  ];

  List<Application> get filteredApplications {
    if (selectedFilter == 'All') {
      return applications;
    }

    return applications.where((application) {
      return application.status.label == selectedFilter;
    }).toList();
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
          'My Applications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filters
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                'All',
                'Applied',
                'Shortlisted',
                'Interview',
                'Hired',
              ].map((filter) {
                final selected = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor: const Color(0xFF7B2CBF),
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
            child: filteredApplications.isEmpty
                ? const Center(
                    child: Text('No applications found'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      5,
                      20,
                      30,
                    ),
                    itemCount: filteredApplications.length,
                    itemBuilder: (context, index) {
                      final application =
                          filteredApplications[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: 15),
                        child: ApplicationCard(
                          application: application,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ApplicationDetailsScreen(
                                  application: application,
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
// APPLICATION CARD
// ============================================================

class ApplicationCard extends StatelessWidget {
  final Application application;
  final VoidCallback onTap;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onTap,
  });

  Color get statusColor {
    switch (application.status) {
      case ApplicationStatus.applied:
        return Colors.blue;
      case ApplicationStatus.shortlisted:
        return Colors.orange;
      case ApplicationStatus.interview:
        return Colors.purple;
      case ApplicationStatus.hired:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(17),
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
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E5F5),
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: Color(0xFF7B2CBF),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.company,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        application.jobTitle,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.black38,
                ),
              ],
            ),

            const SizedBox(height: 17),

            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.black45,
                ),
                const SizedBox(width: 4),
                Text(
                  application.location,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(width: 15),

                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Colors.black45,
                ),
                const SizedBox(width: 4),
                Text(
                  application.date,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Text(
                  '₹${application.budget}',
                  style: const TextStyle(
                    color: Color(0xFF7B2CBF),
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: Text(
                    application.status.label,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
// DETAILS SCREEN
// ============================================================

class ApplicationDetailsScreen extends StatelessWidget {
  final Application application;

  const ApplicationDetailsScreen({
    super.key,
    required this.application,
  });

  int get currentStep {
    switch (application.status) {
      case ApplicationStatus.applied:
        return 0;
      case ApplicationStatus.shortlisted:
        return 1;
      case ApplicationStatus.interview:
        return 2;
      case ApplicationStatus.hired:
        return 3;
      case ApplicationStatus.rejected:
        return 0;
    }
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
          'Application',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Job information
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
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFF3E5F5),
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.business,
                          color: Color(0xFF7B2CBF),
                          size: 27,
                        ),
                      ),

                      const SizedBox(width: 13),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              application.company,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              application.jobTitle,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 17,
                        color: Colors.black45,
                      ),
                      const SizedBox(width: 5),
                      Text(application.location),

                      const Spacer(),

                      Text(
                        '₹${application.budget}',
                        style: const TextStyle(
                          color: Color(0xFF7B2CBF),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Application Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),

            const SizedBox(height: 18),

            // Timeline
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  StatusStep(
                    title: 'Application Submitted',
                    subtitle:
                        'Your application has been sent to the client.',
                    active: currentStep >= 0,
                    completed: currentStep > 0,
                    isLast: false,
                  ),
                  StatusStep(
                    title: 'Shortlisted',
                    subtitle:
                        'The client shortlisted your profile.',
                    active: currentStep >= 1,
                    completed: currentStep > 1,
                    isLast: false,
                  ),
                  StatusStep(
                    title: 'Interview',
                    subtitle:
                        'Client may contact you for an interview.',
                    active: currentStep >= 2,
                    completed: currentStep > 2,
                    isLast: false,
                  ),
                  StatusStep(
                    title: 'Hired',
                    subtitle:
                        'Congratulations! You got the job.',
                    active: currentStep >= 3,
                    completed: false,
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Important',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5),
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFF7B2CBF),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Never make payments to a client to get selected. '
                      'All payments should be handled through verified '
                      'LikeMe processes.',
                      style: TextStyle(
                        color: Colors.black54,
                        height: 1.5,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            if (application.status ==
                ApplicationStatus.hired)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Opening chat with client...',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text(
                    'Message Client',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF7B2CBF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// STATUS STEP
// ============================================================

class StatusStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool active;
  final bool completed;
  final bool isLast;

  const StatusStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.active,
    required this.completed,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? const Color(0xFF7B2CBF)
                      : Colors.grey.shade200,
                ),
                child: Icon(
                  completed
                      ? Icons.check
                      : Icons.circle,
                  size: completed ? 18 : 9,
                  color: active
                      ? Colors.white
                      : Colors.grey.shade400,
                ),
              ),

              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: active
                        ? const Color(0xFF7B2CBF)
                            .withValues(alpha: 0.3)
                        : Colors.grey.shade200,
                  ),
                ),
            ],
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 28),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: active
                          ? Colors.black
                          : Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: active
                          ? Colors.black54
                          : Colors.black26,
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

// ============================================================
// DATA
// ============================================================

enum ApplicationStatus {
  applied,
  shortlisted,
  interview,
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
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.hired:
        return 'Hired';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }
}

class Application {
  final String jobTitle;
  final String company;
  final String location;
  final int budget;
  final String date;
  final ApplicationStatus status;

  Application({
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.budget,
    required this.date,
    required this.status,
  });
}