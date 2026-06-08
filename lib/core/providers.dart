import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/ai_coach/ai_coach_repository.dart';
import 'package:oneformind/core/services/ai_service.dart';

final aiCoachRepositoryProvider = Provider<AiCoachRepository>((ref) => AiCoachRepository());
final aiServiceProvider = Provider<AiService>((ref) => AiService());
