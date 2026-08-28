import 'package:flutter/material.dart';
import 'package:likeme/services/api_service.dart';

class ClientJobsScreen extends StatefulWidget {
  const ClientJobsScreen({super.key});

  @override
  State<ClientJobsScreen> createState() => _ClientJobsScreenState();
}

class _ClientJobsScreenState extends State<ClientJobsScreen> {
  final List<JobData> jobs = [
    JobData(
      title: 'Fashion Brand Photoshoot',
      category: 'Fashion',
      location: 'Mumbai',
      budget: 25000,
      date: '15 Sep 2026',
      applications: 8,
      status: 'Open',
    ),
    JobData(
      title: 'Instagram Campaign',
      category: 'Commercial',
      location: 'Delhi',
      budget: 18000,
      date: '22 Sep 2026',
      applications: 5,
      status: 'Open',
    ),
    JobData(
      title: 'Fitness Product Campaign',
      category: 'Fitness',
      location: 'Bangalore',
      budget: 30000,
      date: '05 Oct 2026',
      applications: 12,
      status: 'Completed',
    ),
  ];

  void createJob() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return const CreateJobSheet();
      },
    );
  }

  void openJob(JobData job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailsScreen(job: job),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final openJobs =
        jobs.where((job) => job.status == 'Open').toList();

    final completedJobs =
        jobs.where((job) => job.status == 'Completed').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Jobs',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: createJob,
            icon: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFF7B2CBF),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          // Summary
          Row(
            children: [
              _SummaryCard(
                value: '${openJobs.length}',
                label: 'Open Jobs',
                icon: Icons.work_outline,
              ),
              const SizedBox(width: 12),
              _SummaryCard(
                value: '25',
                label: 'Applications',
                icon: Icons.people_outline,
              ),
              const SizedBox(width: 12),
              _SummaryCard(
                value: '${completedJobs.length}',
                label: 'Completed',
                icon: Icons.check_circle_outline,
              ),
            ],
          ),

          const SizedBox(height: 28),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Jobs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: createJob,
                child: const Text('Create New'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (openJobs.isEmpty)
            const _EmptyJobs()
          else
            ...openJobs.map(
              (job) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: JobCard(
                  job: job,
                  onTap: () => openJob(job),
                ),
              ),
            ),

          const SizedBox(height: 20),

          const Text(
            'Completed Jobs',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (completedJobs.isEmpty)
            const Text(
              'No completed jobs yet.',
              style: TextStyle(
                color: Colors.black45,
              ),
            )
          else
            ...completedJobs.map(
              (job) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: JobCard(
                  job: job,
                  onTap: () => openJob(job),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// JOB CARD
// ------------------------------------------------------------

class JobCard extends StatelessWidget {
  final JobData job;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = job.status == 'Open';

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
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
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E5F5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.work_outline,
                    color: Color(0xFF7B2CBF),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isOpen
                        ? const Color(0xFFE8F5E9)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    job.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isOpen
                          ? Colors.green.shade700
                          : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

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
                  ),
                ),

                const SizedBox(width: 15),

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
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E5F5),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    job.category,
                    style: const TextStyle(
                      color: Color(0xFF7B2CBF),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  '₹${job.budget}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  size: 17,
                  color: Colors.black45,
                ),
                const SizedBox(width: 5),
                Text(
                  '${job.applications} applications',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),

                const Spacer(),

                const Text(
                  'View Details',
                  style: TextStyle(
                    color: Color(0xFF7B2CBF),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(width: 3),

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

// ------------------------------------------------------------
// CREATE JOB
// ------------------------------------------------------------

class CreateJobSheet extends StatefulWidget {
  const CreateJobSheet({super.key});

  @override
  State<CreateJobSheet> createState() => _CreateJobSheetState();
}

class _CreateJobSheetState extends State<CreateJobSheet> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final budgetController = TextEditingController();

  String category = 'Fashion';
  String modelsNeeded = '1 Model';

  final categories = [
    'Fashion',
    'Commercial',
    'Runway',
    'Fitness',
    'Beauty',
  ];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  Future<void> submitJob() async {
    if (titleController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        budgetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields.'),
        ),
      );
      return;
    }

    try {
      await ApiService.instance.createJob(
        title: titleController.text.trim(),
        category: category,
        location: locationController.text.trim(),
        date: DateTime.now().toIso8601String(),
        durationHours: 6,
        budget: int.tryParse(budgetController.text.trim()) ?? 10000,
        description: descriptionController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job published successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not publish job: ${e.toString().replaceAll('Exception: ', '')}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 25,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New Job',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Tell models what you are looking for.',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 25),

            _InputField(
              controller: titleController,
              label: 'Job Title *',
              hint: 'e.g. Fashion Brand Photoshoot',
              icon: Icons.title,
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: _inputDecoration(
                'Category',
                Icons.category_outlined,
              ),
              items: categories
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 14),

            _InputField(
              controller: locationController,
              label: 'Location *',
              hint: 'Mumbai',
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 14),

            _InputField(
              controller: budgetController,
              label: 'Budget *',
              hint: '25000',
              icon: Icons.currency_rupee,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: modelsNeeded,
              decoration: _inputDecoration(
                'Models Required',
                Icons.people_outline,
              ),
              items: const [
                DropdownMenuItem(
                  value: '1 Model',
                  child: Text('1 Model'),
                ),
                DropdownMenuItem(
                  value: '2 Models',
                  child: Text('2 Models'),
                ),
                DropdownMenuItem(
                  value: '3 Models',
                  child: Text('3 Models'),
                ),
                DropdownMenuItem(
                  value: '5+ Models',
                  child: Text('5+ Models'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  modelsNeeded = value!;
                });
              },
            ),

            const SizedBox(height: 14),

            _InputField(
              controller: descriptionController,
              label: 'Description',
              hint: 'Describe your project...',
              icon: Icons.description_outlined,
              maxLines: 4,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 53,
              child: ElevatedButton(
                onPressed: submitJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B2CBF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Publish Job',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

// ------------------------------------------------------------
// JOB DETAILS
// ------------------------------------------------------------

class JobDetailsScreen extends StatelessWidget {
  final JobData job;

  const JobDetailsScreen({
    super.key,
    required this.job,
  });

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
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                _Tag(
                  text: job.category,
                ),
                const SizedBox(width: 8),
                _Tag(
                  text: job.status,
                ),
              ],
            ),

            const SizedBox(height: 25),

            _DetailBox(
              icon: Icons.location_on_outlined,
              title: 'Location',
              value: job.location,
            ),

            _DetailBox(
              icon: Icons.calendar_today_outlined,
              title: 'Date',
              value: job.date,
            ),

            _DetailBox(
              icon: Icons.currency_rupee,
              title: 'Budget',
              value: '₹${job.budget}',
            ),

            _DetailBox(
              icon: Icons.people_outline,
              title: 'Applications',
              value: '${job.applications} models',
            ),

            const SizedBox(height: 25),

            const Text(
              'Project Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'We are looking for professional models for an upcoming '
              'campaign. Candidates should have experience in fashion '
              'and commercial photoshoots and be comfortable working '
              'with a creative production team.',
              style: TextStyle(
                color: Colors.black54,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Applications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${job.applications}',
                  style: const TextStyle(
                    color: Color(0xFF7B2CBF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            const ApplicantCard(
              name: 'Ananya Sharma',
              rating: '4.9',
              aiScore: '94',
              experience: '4 years',
              imageUrl:
                  'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300',
            ),

            const SizedBox(height: 12),

            const ApplicantCard(
              name: 'Priya Singh',
              rating: '4.8',
              aiScore: '91',
              experience: '3 years',
              imageUrl:
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// APPLICANT CARD
// ------------------------------------------------------------

class ApplicantCard extends StatelessWidget {
  final String name;
  final String rating;
  final String aiScore;
  final String experience;
  final String imageUrl;

  const ApplicantCard({
    super.key,
    required this.name,
    required this.rating,
    required this.aiScore,
    required this.experience,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imageUrl,
              width: 65,
              height: 65,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return Container(
                  width: 65,
                  height: 65,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.person),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 15,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 3),
                    Text(rating),
                    const SizedBox(width: 10),
                    Text(
                      '$experience experience',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  'AI Score $aiScore',
                  style: const TextStyle(
                    color: Color(0xFF7B2CBF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              _showHireDialog(context, name);
            },
            icon: const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF7B2CBF),
            ),
          ),
        ],
      ),
    );
  }

  void _showHireDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hire $name?'),
          content: Text(
            'This will send a hiring confirmation to $name.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$name has been selected for the job!',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B2CBF),
                foregroundColor: Colors.white,
              ),
              child: const Text('Hire'),
            ),
          ],
        );
      },
    );
  }
}

// ------------------------------------------------------------
// HELPERS
// ------------------------------------------------------------

class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF7B2CBF),
              size: 21,
            ),
            const SizedBox(height: 7),
            Text(
              value,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black45,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyJobs extends StatelessWidget {
  const _EmptyJobs();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.work_off_outlined,
            size: 50,
            color: Colors.black26,
          ),
          SizedBox(height: 10),
          Text(
            'No active jobs',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Create your first job to start finding models.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 13,
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

class _DetailBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailBox({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF7B2CBF),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: _inputDecoration(label, icon).copyWith(
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }
}

InputDecoration _inputDecoration(
  String label,
  IconData icon,
) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: const Color(0xFFF9F7FB),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );
}

// ------------------------------------------------------------
// MODEL
// ------------------------------------------------------------

class JobData {
  final String title;
  final String category;
  final String location;
  final int budget;
  final String date;
  final int applications;
  final String status;

  JobData({
    required this.title,
    required this.category,
    required this.location,
    required this.budget,
    required this.date,
    required this.applications,
    required this.status,
  });
}