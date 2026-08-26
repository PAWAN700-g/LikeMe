import 'package:flutter/material.dart';
import 'package:likeme/instagramaccount.dart';

class ModelProfileScreen extends StatefulWidget {
  const ModelProfileScreen({super.key, this.isOwner = false});

  final bool isOwner;
  @override
  State<ModelProfileScreen> createState() => _ModelProfileScreenState();
}

class _ModelProfileScreenState extends State<ModelProfileScreen> {
  final List<_Video> _videos = [
    _Video('Monsoon editorial', 'Fashion campaign • 00:28', 4.9, 18, 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=900'),
    _Video('Beauty close-up', 'Beauty campaign • 00:17', 4.8, 12, 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=900'),
    _Video('Runway walk', 'Runway • 00:34', 5.0, 9, 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=900'),
  ];

  double get _videoScore => _videos.fold<double>(0, (a, v) => a + v.rating) / _videos.length;
  double get _trustScore => 4.9 * .45 + _videoScore * .30 + 4.7 * .15 + 5 * .10;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF9F7FB),
    body: CustomScrollView(slivers: [
      SliverAppBar(
        expandedHeight: 350, pinned: true, backgroundColor: const Color(0xFF7B2CBF), foregroundColor: Colors.white,
        flexibleSpace: FlexibleSpaceBar(background: Stack(fit: StackFit.expand, children: [
          Image.network('https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=900', fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black12)),
          const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87]))),
          const Positioned(left: 20, right: 20, bottom: 26, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text('Ananya Sharma', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)), SizedBox(width: 7), Icon(Icons.verified, color: Colors.lightBlueAccent, size: 19)]),
            SizedBox(height: 6), Text('@ananya  •  Mumbai, India', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 10), _HeaderPill('Fashion & commercial'),
          ])),
        ])),
      ),
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            _StatCard(_trustScore.toStringAsFixed(1), 'Trust score', Icons.shield_outlined, const Color(0xFF7B2CBF)), const SizedBox(width: 10),
            const _StatCard('4.9', 'Client rating', Icons.star_rounded, Colors.amber), const SizedBox(width: 10),
            const _StatCard('125K', 'Instagram', Icons.groups_outlined, Colors.pink),
          ]),
          const SizedBox(height: 24), _title('Trust score'), const SizedBox(height: 7),
          const Text('A transparent score based on completed client work, portfolio-video reviews, verified account data, and Instagram engagement.'),
          const SizedBox(height: 14), _TrustCard(videoScore: _videoScore),
          const SizedBox(height: 26), _title('Portfolio videos'), const SizedBox(height: 5),
          Text(widget.isOwner ? 'Ratings from verified clients appear here after completed bookings.' : 'Only verified clients who completed a booking can rate a video.'), const SizedBox(height: 12),
          ..._videos.asMap().entries.map((entry) => _VideoCard(video: entry.value, canRate: !widget.isOwner, onRate: () => _rateVideo(entry.key))),
          const SizedBox(height: 18), _title('Instagram account'), const SizedBox(height: 12), _InstagramCard(onTap: _instagramInfo),
          const SizedBox(height: 26), _title('Client reviews'), const SizedBox(height: 12),
          const _ReviewCard('Studio North', 5, 'Prepared, punctual and excellent on camera. The final campaign performed strongly.'), const SizedBox(height: 10),
          const _ReviewCard('Rahul Verma', 4.8, 'Very professional and easy to work with. Delivered everything on time.'),
          const SizedBox(height: 26), _title('About'), const SizedBox(height: 8),
          const Text('Professional fashion and commercial model available for brand campaigns, beauty shoots and runway work.'),
          const SizedBox(height: 24), const Text('₹15,000 – ₹25,000 / project', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF7B2CBF))),
        ]),
      )),
    ]),
    bottomSheet: widget.isOwner ? null : SafeArea(child: Container(padding: const EdgeInsets.fromLTRB(20, 12, 20, 16), color: Colors.white, child: Row(children: [
      Expanded(child: OutlinedButton(onPressed: () => _notice('Messaging will be connected to the server next.'), child: const Text('Message'))), const SizedBox(width: 12),
      Expanded(flex: 2, child: ElevatedButton(onPressed: _showHireSheet, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B2CBF), foregroundColor: Colors.white), child: const Text('Hire model'))),
    ]))),
  );

  void _notice(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  void _instagramInfo() => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const InstagramAccountScreen()),
      );
  void _showHireSheet() {
    String selectedJob = 'Instagram Brand Campaign';
    final note = TextEditingController();
    showModalBottomSheet(context: context, isScrollControlled: true, showDragHandle: true, builder: (sheetContext) => StatefulBuilder(builder: (_, setSheetState) => Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 24, MediaQuery.viewInsetsOf(sheetContext).bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Hire Ananya', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6), const Text('Choose an open job and send a hiring request.', style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(initialValue: selectedJob, decoration: const InputDecoration(labelText: 'Job'), items: const [DropdownMenuItem(value: 'Instagram Brand Campaign', child: Text('Instagram Brand Campaign')), DropdownMenuItem(value: 'Summer Lookbook Shoot', child: Text('Summer Lookbook Shoot'))], onChanged: (value) => setSheetState(() => selectedJob = value!)),
        const SizedBox(height: 12), TextField(controller: note, maxLines: 3, decoration: const InputDecoration(labelText: 'Note for Ananya (optional)', hintText: 'Share the project brief or next steps.')),
        const SizedBox(height: 20), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { Navigator.pop(sheetContext); _notice('Hiring request sent for $selectedJob.'); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B2CBF), foregroundColor: Colors.white), child: const Text('Send hiring request'))),
      ]),
    )));
  }
  void _rateVideo(int index) {
    double selected = 5;
    final note = TextEditingController();
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (sheetContext) => StatefulBuilder(builder: (_, setSheetState) => Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.viewInsetsOf(sheetContext).bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Rate ${_videos[index].title}', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Rate only work you booked through LikeMe.'), const SizedBox(height: 16),
        Center(child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) => IconButton(onPressed: () => setSheetState(() => selected = i + 1.0), icon: Icon(i < selected ? Icons.star_rounded : Icons.star_outline_rounded, color: Colors.amber, size: 34))))),
        TextField(controller: note, maxLines: 3, decoration: const InputDecoration(labelText: 'Optional review', hintText: 'What stood out about this work?')), const SizedBox(height: 18),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { setState(() => _videos[index] = _videos[index].addRating(selected)); Navigator.pop(sheetContext); _notice('Thanks — your verified video rating was added.'); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B2CBF), foregroundColor: Colors.white), child: const Text('Submit verified rating'))),
      ]),
    )));
  }
}

class _Video { const _Video(this.title, this.subtitle, this.rating, this.count, this.imageUrl); final String title, subtitle, imageUrl; final double rating; final int count; _Video addRating(double value) => _Video(title, subtitle, (rating * count + value) / (count + 1), count + 1, imageUrl); }
class _HeaderPill extends StatelessWidget { const _HeaderPill(this.text); final String text; @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)), child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12))); }
class _StatCard extends StatelessWidget { const _StatCard(this.value, this.label, this.icon, this.color); final String value, label; final IconData icon; final Color color; @override Widget build(BuildContext context) => Expanded(child: Container(padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(children: [Icon(icon, color: color), const SizedBox(height: 5), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)), Text(label, style: const TextStyle(color: Colors.black45, fontSize: 11))]))); }
Widget _title(String text) => Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
class _TrustCard extends StatelessWidget { const _TrustCard({required this.videoScore}); final double videoScore; @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(16)), child: Column(children: [_row('Completed-work reviews', 4.9, '45%'), _row('Portfolio video ratings', videoScore, '30%'), _row('Instagram engagement', 4.7, '15%'), _row('Identity & account verification', 5, '10%')])); Widget _row(String label, double score, String weight) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [Expanded(child: Text(label, style: const TextStyle(fontSize: 13))), Text('${score.toStringAsFixed(1)}  ', style: const TextStyle(fontWeight: FontWeight.bold)), Text(weight, style: const TextStyle(color: Colors.black54, fontSize: 12))])); }
class _VideoCard extends StatelessWidget { const _VideoCard({required this.video, required this.canRate, required this.onRate}); final _Video video; final bool canRate; final VoidCallback onRate; @override Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 12), clipBehavior: Clip.antiAlias, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Row(children: [SizedBox(height: 108, width: 120, child: Stack(fit: StackFit.expand, children: [Image.network(video.imageUrl, fit: BoxFit.cover, errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black12)), const Center(child: CircleAvatar(backgroundColor: Colors.white70, child: Icon(Icons.play_arrow_rounded, color: Color(0xFF7B2CBF))))])), Expanded(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(video.title, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(video.subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)), const SizedBox(height: 10), Row(children: [const Icon(Icons.star_rounded, color: Colors.amber, size: 18), Text(' ${video.rating.toStringAsFixed(1)} (${video.count})', style: const TextStyle(fontWeight: FontWeight.bold)), const Spacer(), if (canRate) TextButton(onPressed: onRate, child: const Text('Rate'))])])))])); }
class _InstagramCard extends StatelessWidget { const _InstagramCard({required this.onTap}); final VoidCallback onTap; @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Row(children: [Container(width: 46, height: 46, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: const LinearGradient(colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)])), child: const Icon(Icons.camera_alt_outlined, color: Colors.white)), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text('@ananya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), SizedBox(width: 5), Icon(Icons.verified, color: Colors.blue, size: 17)]), SizedBox(height: 3), Text('125K followers  •  4.7 profile score', style: TextStyle(color: Colors.black54, fontSize: 13)), SizedBox(height: 3), Text('Verified professional account', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12))])), const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF7B2CBF), size: 18)]))); }
class _ReviewCard extends StatelessWidget { const _ReviewCard(this.name, this.rating, this.review); final String name, review; final double rating; @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [CircleAvatar(backgroundColor: const Color(0xFFF3E5F5), child: Text(name[0], style: const TextStyle(color: Color(0xFF7B2CBF)))), const SizedBox(width: 10), Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))), const Icon(Icons.star_rounded, color: Colors.amber, size: 18), Text(' ${rating.toStringAsFixed(1)}')]), const SizedBox(height: 10), Text(review, style: const TextStyle(color: Colors.black54, height: 1.4))])); }
