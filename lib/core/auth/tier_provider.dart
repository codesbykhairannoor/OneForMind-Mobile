import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/data/auth_api.dart';

part 'tier_provider.g.dart';

enum UserTier { explorer, architect, quantum, legendary, trial }

@riverpod
class UserTierNotifier extends _$UserTierNotifier {
  @override
  Future<UserTier> build() async {
    final response = await ref.read(authApiProvider).getUser();
    final data = response.data['data'];
    final plan = data['plan_type'] as String;
    
    switch (plan) {
      case 'architect': return UserTier.architect;
      case 'quantum': return UserTier.quantum;
      case 'legendary': return UserTier.legendary;
      case 'trial': return UserTier.trial;
      default: return UserTier.explorer;
    }
  }

  bool canUse(String feature) {
    final tier = state.value ?? UserTier.explorer;
    
    const freeFeatures = ['habits', 'finance', 'planner', 'dashboard'];
    const architectFeatures = ['journal', 'calendar', 'jobs', 'goals'];
    const quantumFeatures = ['ai_coach', 'neural_os'];

    if (freeFeatures.contains(feature)) return true;
    
    if (architectFeatures.contains(feature)) {
      return tier != UserTier.explorer;
    }

    if (quantumFeatures.contains(feature)) {
      return tier == UserTier.quantum || tier == UserTier.legendary;
    }

    return false;
  }
}
