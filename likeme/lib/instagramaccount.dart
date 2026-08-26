import 'package:flutter/material.dart';

/// A local representation of the Meta connection until the API is wired in.
/// Tokens must be exchanged and stored by the server, never in the app.
class InstagramAccountScreen extends StatefulWidget {
  const InstagramAccountScreen({super.key});

  @override
  State<InstagramAccountScreen> createState() => _InstagramAccountScreenState();
}

class _InstagramAccountScreenState extends State<InstagramAccountScreen> {
  bool _connected = true;
  bool _shareInsights = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FB),
      appBar: AppBar(
        title: const Text('Instagram account'),
        backgroundColor: const Color(0xFFF9F7FB),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          _connectionCard(),
          const SizedBox(height: 24),
          const Text(
            'What clients can see',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your public handle, follower range and LikeMe profile score. '
            'Clients never receive access to your Instagram account.',
            style: TextStyle(color: Colors.black54, height: 1.45),
          ),
          const SizedBox(height: 14),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _shareInsights,
            activeThumbColor: const Color(0xFF7B2CBF),
            title: const Text('Use professional-account insights'),
            subtitle: const Text(
              'Use engagement consistency in your trust score.',
            ),
            onChanged: _connected
                ? (value) => setState(() => _shareInsights = value)
                : null,
          ),
          const Divider(height: 32),
          const Text(
            'Your privacy',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const _PrivacyRow(
            Icons.visibility_outlined,
            'We show only the account information you choose to share.',
          ),
          const _PrivacyRow(
            Icons.lock_outline,
            'Authorization is handled by Meta. LikeMe does not see your password.',
          ),
          const _PrivacyRow(
            Icons.no_accounts_outlined,
            'You can disconnect at any time; this removes synced account data.',
          ),
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: _connected ? _disconnect : _connect,
            icon: Icon(_connected ? Icons.link_off : Icons.link),
            label: Text(_connected ? 'Disconnect account' : 'Connect Instagram'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _connected ? Colors.red.shade700 : const Color(0xFF7B2CBF),
              side: BorderSide(color: _connected ? Colors.red.shade200 : const Color(0xFF7B2CBF)),
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectionCard() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)],
                ),
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _connected
                  ? const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('@ananya', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(height: 3),
                        Text('Professional account · 125K followers', style: TextStyle(color: Colors.black54, fontSize: 13)),
                        SizedBox(height: 5),
                        Text('Verified and synced today', style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    )
                  : const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('No account connected', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(height: 3),
                        Text('Connect a professional account to verify your profile.', style: TextStyle(color: Colors.black54, fontSize: 13)),
                      ],
                    ),
            ),
          ],
        ),
      );

  void _disconnect() {
    setState(() {
      _connected = false;
      _shareInsights = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Instagram account disconnected.')),
    );
  }

  void _connect() {
    setState(() {
      _connected = true;
      _shareInsights = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Instagram account connected and verified.')),
    );
  }
}

class _PrivacyRow extends StatelessWidget {
  const _PrivacyRow(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF7B2CBF), size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(color: Colors.black54, height: 1.4))),
          ],
        ),
      );
}
