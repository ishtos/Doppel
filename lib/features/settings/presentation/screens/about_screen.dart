import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _appVersion = '1.0.0';
  static const _buildNumber = '1';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('アプリについて', style: theme.textTheme.titleLarge),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 32),

          // App icon & name
          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.record_voice_over,
                    size: 44,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Doppel', style: theme.textTheme.displayMedium),
                const SizedBox(height: 4),
                Text(
                  'AIシャドーイングコーチ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'バージョン $_appVersion ($_buildNumber)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Description card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Doppelは、AIを活用した英語シャドーイング練習アプリです。'
                  'TTS音声のお手本再生、録音、音声認識、スコアリング、'
                  'AIコーチによるフィードバックを通じて、'
                  '効率的な発音練習をサポートします。',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Links
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('ライセンス'),
            subtitle: const Text('オープンソースライセンスの一覧'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Doppel',
              applicationVersion: '$_appVersion+$_buildNumber',
              applicationIcon: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.record_voice_over,
                    size: 24,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, indent: 72),

          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('プライバシーポリシー'),
            subtitle: const Text('データの取り扱いについて'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(context, theme),
          ),
          const Divider(height: 1, indent: 72),

          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('利用規約'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTermsOfService(context, theme),
          ),
          const Divider(height: 1, indent: 72),

          const SizedBox(height: 32),

          // Copyright
          Center(
            child: Text(
              '\u00a9 2026 Doppel. All rights reserved.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('プライバシーポリシー'),
        content: const SingleChildScrollView(
          child: Text(
            'Doppelは、お客様のプライバシーを尊重します。\n\n'
            '【収集する情報】\n'
            '・音声データ: 練習時の録音はOpenAI Whisper APIで処理され、'
            'ローカルデバイスに保存されます。\n'
            '・練習履歴: スコアやフィードバックはローカルデバイスにのみ保存されます。\n\n'
            '【外部サービスとの通信】\n'
            '・音声認識にOpenAI Whisper APIを使用します。\n'
            '・AIコーチフィードバックにOpenAI GPT APIを使用します。\n'
            '・送信されたデータはAPIの処理にのみ使用されます。\n\n'
            '【データの保存】\n'
            '・すべてのユーザーデータはデバイスのローカルストレージに保存されます。\n'
            '・外部サーバーにユーザーデータを保存することはありません。\n\n'
            '【データの削除】\n'
            '・設定画面からすべての練習データを削除できます。\n'
            '・アプリをアンインストールすると、すべてのデータが削除されます。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('利用規約'),
        content: const SingleChildScrollView(
          child: Text(
            '【アプリの利用について】\n'
            '・Doppelは英語学習を支援するアプリです。\n'
            '・AIによるフィードバックは参考情報であり、'
            '完全な正確性を保証するものではありません。\n\n'
            '【禁止事項】\n'
            '・アプリの不正利用・リバースエンジニアリング。\n'
            '・他者に不利益を与える行為。\n\n'
            '【免責事項】\n'
            '・本アプリの使用により生じた損害について、'
            '開発者は責任を負いません。\n'
            '・サービスの内容は予告なく変更される場合があります。\n\n'
            '【お問い合わせ】\n'
            '・アプリ内の設定画面よりお問い合わせください。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}
