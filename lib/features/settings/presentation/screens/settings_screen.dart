import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../../../shared/services/purchase_service.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final purchase = ref.watch(purchaseControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'ホームに戻る',
          // Settings is reached via context.go (a replace), so there is no
          // route to pop back to — navigate home explicitly, like the other
          // root-level screens (feedback / lesson).
          onPressed: () => context.go('/home'),
        ),
        title: Text('設定', style: theme.textTheme.titleLarge),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // Plan / premium section (freemium: 1 lesson/day for free)
          _SectionHeader(title: 'プラン', theme: theme),
          if (settings.isPremium)
            ListTile(
              leading: Icon(Icons.workspace_premium,
                  color: theme.colorScheme.tertiary),
              title: const Text('プレミアム会員'),
              subtitle: const Text('レッスン練習は無制限です'),
            )
          else
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: const Text('プレミアムにアップグレード'),
              subtitle: Text(
                purchase.priceLabel != null
                    ? '${purchase.priceLabel} ・ レッスン練習が無制限に'
                    : '無料プラン: 1日1レッスンまで練習できます',
              ),
              trailing: purchase.purchasePending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: purchase.product == null
                  ? null
                  : () => ref.read(purchaseControllerProvider.notifier).buy(),
            ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('購入を復元'),
            onTap: () =>
                ref.read(purchaseControllerProvider.notifier).restore(),
          ),
          const Divider(height: 1, indent: 72),

          // Theme section
          _SectionHeader(title: '外観', theme: theme),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('テーマ'),
            subtitle: Text(_themeModeLabel(settings.themeMode)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context, settings.themeMode, notifier),
          ),
          const Divider(height: 1, indent: 72),

          // TTS section
          _SectionHeader(title: '音声', theme: theme),
          ListTile(
            leading: const Icon(Icons.speed),
            title: const Text('TTS再生速度（デフォルト）'),
            subtitle: Text('${settings.ttsSpeed.toStringAsFixed(1)}x'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72),
            child: Row(
              children: [
                const Text('0.5x'),
                Expanded(
                  child: Slider(
                    value: settings.ttsSpeed,
                    min: 0.5,
                    max: 1.5,
                    divisions: 4,
                    label: '${settings.ttsSpeed.toStringAsFixed(1)}x',
                    onChanged: (v) => notifier.setTtsSpeed(v),
                  ),
                ),
                const Text('1.5x'),
              ],
            ),
          ),
          const Divider(height: 1, indent: 72),

          // Daily goal section
          _SectionHeader(title: '目標', theme: theme),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('1日の練習目標'),
            subtitle: Text('${settings.dailyGoal}回 / 日'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('1回')),
                ButtonSegment(value: 2, label: Text('2回')),
                ButtonSegment(value: 3, label: Text('3回')),
                ButtonSegment(value: 5, label: Text('5回')),
              ],
              selected: {settings.dailyGoal},
              onSelectionChanged: (v) => notifier.setDailyGoal(v.first),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, indent: 72),

          // Notification section
          _SectionHeader(title: '通知', theme: theme),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('練習リマインダー'),
            subtitle: Text(
              settings.isReminderEnabled
                  ? '毎日 ${settings.reminderTimeLabel} に通知'
                  : 'オフ',
            ),
            value: settings.isReminderEnabled,
            onChanged: (v) => notifier.setReminderEnabled(v),
          ),
          if (settings.isReminderEnabled)
            ListTile(
              leading: const SizedBox(width: 24),
              title: const Text('通知時刻'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    settings.reminderTimeLabel,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => _showTimePicker(context, settings, notifier),
            ),
          const Divider(height: 1, indent: 72),

          // Privacy / cloud-analysis consent (opt-in, default off)
          _SectionHeader(title: 'プライバシー', theme: theme),
          SwitchListTile(
            secondary: Icon(
              settings.cloudAnalysisConsent
                  ? Icons.cloud_done_outlined
                  : Icons.cloud_off_outlined,
            ),
            title: const Text('クラウド音声解析'),
            subtitle: const Text(
              'オンにすると録音音声をOpenAIに送信し、音声認識とAIコーチを利用します。'
              'オフの場合はデバイス内で簡易採点し、音声やデータを外部に送信しません。',
            ),
            value: settings.cloudAnalysisConsent,
            onChanged: (v) => notifier.setCloudAnalysisConsent(v),
          ),
          SwitchListTile(
            secondary: Icon(
              settings.productAnalyticsConsent
                  ? Icons.insights_outlined
                  : Icons.insights,
            ),
            title: const Text('利用状況の匿名分析'),
            subtitle: const Text(
              'アプリ改善のため、匿名の利用状況（機能の使用回数など）を送信します。'
              '音声や個人情報は含みません。オフにできます。',
            ),
            value: settings.productAnalyticsConsent,
            onChanged: (v) => notifier.setProductAnalyticsConsent(v),
          ),
          const Divider(height: 1, indent: 72),

          // Data section
          _SectionHeader(title: 'データ', theme: theme),
          ListTile(
            leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            title: Text(
              '練習データをリセット',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            subtitle: const Text('フィードバック・進捗データを全て削除します'),
            onTap: () => _confirmReset(context),
          ),
          const Divider(height: 1, indent: 72),

          // App info // FIXED: About画面・ライセンスへのナビゲーション追加
          _SectionHeader(title: 'アプリ情報', theme: theme),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Doppelについて'),
            subtitle: const Text('バージョン 1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/about'),
          ),
          const Divider(height: 1, indent: 72),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('ライセンス'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'Doppel',
              applicationVersion: '1.0.0+1',
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
        ],
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'システム設定に従う';
      case ThemeMode.light:
        return 'ライト';
      case ThemeMode.dark:
        return 'ダーク';
    }
  }

  void _showThemePicker(
    BuildContext context,
    ThemeMode current,
    SettingsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('テーマを選択'),
        children: [
          RadioGroup<ThemeMode>(
            groupValue: current,
            onChanged: (v) {
              if (v != null) notifier.setThemeMode(v);
              Navigator.of(ctx).pop();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ThemeMode.values.map((mode) {
                return RadioListTile<ThemeMode>(
                  title: Text(_themeModeLabel(mode)),
                  value: mode,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePicker(
    BuildContext context,
    SettingsState settings,
    SettingsNotifier notifier,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.reminderHour,
        minute: settings.reminderMinute,
      ),
      helpText: 'リマインダー時刻を選択',
    );
    if (picked != null) {
      await notifier.setReminderTime(picked.hour, picked.minute);
    }
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('データリセット'),
        content: const Text(
          'フィードバックと進捗データを全て削除します。\nこの操作は取り消せません。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('リセット'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await Hive.box<Map>('feedbacks').clear();
      await Hive.box<Map>('progress').clear();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('データをリセットしました')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.theme});

  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
