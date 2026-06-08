import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/ai_coach/ai_coach_repository.dart';

final aiCoachRepositoryProvider = Provider<AiCoachRepository>((ref) => AiCoachRepository());
