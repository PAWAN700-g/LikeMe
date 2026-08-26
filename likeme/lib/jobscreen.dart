import 'package:flutter/material.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String selectedCategory = 'All';

  final List<ModelJob> jobs = [
    ModelJob(
      title: 'Fashion Brand Photoshoot',
      company: 'Urban Vogue',
      category: 'Fashion',
      location: 'Mumbai',
      budget: 25000,
      date: '15 Sep 2026',
      duration: '6 Hours',
      applicants: 8,
      verified: true,
    ),
    ModelJob(
      title: 'Instagram Brand Campaign',
      company: 'Glow Cosmetics',
      category: 'Beauty',
      location: 'Delhi',
      budget: 18000,
      date: '22 Sep 2026',
      duration: '4 Hours',
      applicants: 12,
      verified: true,
    ),
    ModelJob(
      title: 'Fitness Product Shoot',
      company: 'FitPro India',
      category: 'Fitness',
      location: 'Bangalore',
      budget: 30000,
      date: '05 Oct 2026',
      duration: '8 Hours',
      applicants: 5,
      verified: true,
    ),
    ModelJob(
      title: 'New Clothing Collection',
      company: 'StyleHub',
      category: 'Fashion',
      location: 'Pune',
      budget: 22000,
      date: '12 Oct 2026',
      duration: '5 Hours',
      applicants: 15,
      verified: false,
    ),
  ];

  List<ModelJob> get filteredJobs {
    if (selectedCategory == 'All') {
      return jobs;
    }

    return jobs
        .where((job) => job.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Find Jobs',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search jobs...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 45,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                'All',
                'Fashion',
                'Beauty',
                'Fitness',
                'Commercial',
              ].map((category) {
                final selected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: const Color(0xFF7B2CBF),
                    labelStyle: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide.none,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: filteredJobs.isEmpty
                ? const Center(
                    child: Text(
                      'No jobs found',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      5,
                      20,
                      30,
                    ),
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: ModelJobCard(
                          job: job,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ModelJobDetailsScreen(
                                  job: job,
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
// JOB CARD
// ============================================================

class ModelJobCard extends StatelessWidget {
  final ModelJob job;
  final VoidCallback onTap;

  const ModelJobCard({
    super.key,
    required this.job,
    required this.onTap,
  });

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E5F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.business_center_outlined,
                    color: Color(0xFF7B2CBF),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              job.company,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (job.verified) ...[
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.title,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.bookmark_border,
                  color: Colors.black45,
                ),
              ],
            ),

            const SizedBox(height: 17),

            Text(
              job.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.black45,
                ),
                const SizedBox(width: 4),
                Text(
                  job.location,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(width: 14),

                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Colors.black45,
                ),
                const SizedBox(width: 4),
                Text(
                  job.date,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                _InfoChip(
                  icon: Icons.schedule,
                  text: job.duration,
                ),
                const SizedBox(width: 7),
                _InfoChip(
                  icon: Icons.people_outline,
                  text: '${job.applicants} applied',
                ),
              ],
            ),

            const SizedBox(height: 17),

            Row(
              children: [
                Text(
                  '₹${job.budget}',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B2CBF),
                  ),
                ),

                const Text(
                  ' / project',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                const Text(
                  'View Job',
                  style: TextStyle(
                    color: Color(0xFF7B2CBF),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(width: 5),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
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
// JOB DETAILS
// ============================================================

class ModelJobDetailsScreen extends StatelessWidget {
  final ModelJob job;

  const ModelJobDetailsScreen({
    super.key,
    required this.job,
  });

  void apply(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) {
        return const ApplicationSheet();
      },
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
          'Job Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E5F5),
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.business,
                          color: Color(0xFF7B2CBF),
                          size: 28,
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
                                Text(
                                  job.company,
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (job.verified) ...[
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.verified,
                                    size: 17,
                                    color: Colors.blue,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              job.location,
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

                  const SizedBox(height: 22),

                  Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _Tag(text: job.category),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Details
            Row(
              children: [
                Expanded(
                  child: _DetailCard(
                    icon: Icons.currency_rupee,
                    title: 'Budget',
                    value: '₹${job.budget}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DetailCard(
                    icon: Icons.schedule,
                    title: 'Duration',
                    value: job.duration,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _DetailCard(
                    icon: Icons.calendar_today_outlined,
                    title: 'Date',
                    value: job.date,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DetailCard(
                    icon: Icons.people_outline,
                    title: 'Applicants',
                    value: '${job.applicants}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              'About the Project',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'We are looking for talented and professional models '
              'for an upcoming campaign. The selected model will '
              'work with our creative team during the photoshoot.',
              style: TextStyle(
                color: Colors.black54,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Requirements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const _Requirement(
              icon: Icons.check_circle_outline,
              text: 'Professional modelling experience',
            ),
            const _Requirement(
              icon: Icons.check_circle_outline,
              text: 'Good communication skills',
            ),
            const _Requirement(
              icon: Icons.check_circle_outline,
              text: 'Available on the shoot date',
            ),
            const _Requirement(
              icon: Icons.check_circle_outline,
              text: 'Portfolio required',
            ),

            const SizedBox(height: 25),

            const Text(
              'About Client',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 27,
                    backgroundColor: Color(0xFFF3E5F5),
                    child: Icon(
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
                        Row(
                          children: [
                            Text(
                              job.company,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (job.verified)
                              const Icon(
                                Icons.verified,
                                size: 16,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '98% payment completion',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
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
            ),
          ],
        ),
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 53,
          child: ElevatedButton(
            onPressed: () => apply(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B2CBF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Apply for this Job',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// APPLICATION SHEET
// ============================================================

class ApplicationSheet extends StatefulWidget {
  const ApplicationSheet({super.key});

  @override
  State<ApplicationSheet> createState() =>
      _ApplicationSheetState();
}

class _ApplicationSheetState
    extends State<ApplicationSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Write a short introduction first.',
          ),
        ),
      );
      return;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Application submitted successfully!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        10,
        24,
        MediaQuery.of(context).viewInsets.bottom + 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Apply for Job',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Introduce yourself to the client.',
            style: TextStyle(
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText:
                  'Tell the client why you are a good fit...',
              filled: true,
              fillColor: const Color(0xFFF9F7FB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF7B2CBF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Submit Application',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SMALL WIDGETS
// ============================================================

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.black45,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF7B2CBF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF7B2CBF),
            size: 20,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _Requirement extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Requirement({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 19,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DATA MODEL
// ============================================================

class ModelJob {
  final String title;
  final String company;
  final String category;
  final String location;
  final int budget;
  final String date;
  final String duration;
  final int applicants;
  final bool verified;

  ModelJob({
    required this.title,
    required this.company,
    required this.category,
    required this.location,
    required this.budget,
    required this.date,
    required this.duration,
    required this.applicants,
    required this.verified,
  });
}