import '../../services/cache_service.dart';

/// 表达设置页交互过程中的瞬时 UI 状态。
class SettingsState {
  const SettingsState({
    this.isSendingFeedback = false,
    this.isClearingCache = false,
    this.lastCacheCleanupResult,
  });

  final bool isSendingFeedback;
  final bool isClearingCache;
  final CacheCleanupResult? lastCacheCleanupResult;

  SettingsState copyWith({
    bool? isSendingFeedback,
    bool? isClearingCache,
    CacheCleanupResult? lastCacheCleanupResult,
  }) {
    return SettingsState(
      isSendingFeedback: isSendingFeedback ?? this.isSendingFeedback,
      isClearingCache: isClearingCache ?? this.isClearingCache,
      lastCacheCleanupResult:
          lastCacheCleanupResult ?? this.lastCacheCleanupResult,
    );
  }
}
