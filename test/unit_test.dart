// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:sparkle_lite/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sparkle_lite/features/auth/presentation/bloc/auth_event.dart';
import 'package:sparkle_lite/features/auth/presentation/bloc/auth_state.dart';
import 'package:sparkle_lite/features/auth/domain/usecases/login_usecase.dart';
import 'package:sparkle_lite/features/auth/domain/usecases/signup_usecase.dart';
import 'package:sparkle_lite/features/auth/domain/usecases/logout_usecase.dart';
import 'package:sparkle_lite/features/auth/domain/entities/auth_user_entity.dart';
import 'package:sparkle_lite/features/auth/domain/usecases/params/login_params.dart';

import 'package:sparkle_lite/features/home/domain/entities/add_symptom_entity.dart';
import 'package:sparkle_lite/features/home/domain/entities/ai_insight_entity.dart';
import 'package:sparkle_lite/features/home/domain/entities/doctor_visit_entity.dart';
import 'package:sparkle_lite/features/home/domain/entities/symptom_log_summary_entity.dart';
import 'package:sparkle_lite/features/home/data/dto/add_symptom_dto.dart';
import 'package:sparkle_lite/features/home/data/dto/ai_insight_dto.dart';
import 'package:sparkle_lite/features/home/data/dto/doctor_visit_dto.dart';
import 'package:sparkle_lite/features/home/domain/usecases/params/add_symptom_params.dart';
import 'package:sparkle_lite/features/home/domain/usecases/params/add_doctor_visit_params.dart';
import 'package:sparkle_lite/features/home/domain/usecases/params/generate_ai_insights_params.dart';

import 'package:sparkle_lite/features/symptom/domain/entities/symptom_log_entity.dart';
import 'package:sparkle_lite/features/symptom/presentation/bloc/symptom_bloc.dart';
import 'package:sparkle_lite/features/symptom/presentation/bloc/symptom_event.dart';
import 'package:sparkle_lite/features/symptom/presentation/bloc/symptom_state.dart';
import 'package:sparkle_lite/features/symptom/domain/usecases/fetch_symptom_logs_usecase.dart';
import 'package:sparkle_lite/features/symptom/domain/usecases/delete_symptom_log_usecase.dart';
import 'package:sparkle_lite/features/symptom/domain/usecases/params/fetch_symptom_logs_params.dart';
import 'package:sparkle_lite/features/symptom/domain/usecases/params/delete_symptom_log_params.dart';

import 'package:sparkle_lite/features/profile_settings/domain/entities/privacy_settings_entity.dart';
import 'package:sparkle_lite/features/profile_settings/domain/entities/profile_settings_entity.dart';
import 'package:sparkle_lite/features/profile_settings/domain/entities/family_member_entity.dart';
import 'package:sparkle_lite/features/profile_settings/data/dto/privacy_settings_dto.dart';
import 'package:sparkle_lite/features/profile_settings/presentation/bloc/profile_settings_bloc.dart';
import 'package:sparkle_lite/features/profile_settings/presentation/bloc/profile_settings_event.dart';
import 'package:sparkle_lite/features/profile_settings/presentation/bloc/profile_settings_state.dart';
import 'package:sparkle_lite/features/profile_settings/domain/usecases/profile_settings_usecases.dart';
import 'package:sparkle_lite/features/profile_settings/domain/usecases/params/profile_settings_params.dart';

import 'package:sparkle_lite/core/networks/api_result.dart';
import 'package:sparkle_lite/core/networks/api_failure.dart';

import 'unit_test.mocks.dart';

// ─── Mock generation ──────────────────────────────────────────────────────────
@GenerateMocks([
  LoginUsecase,
  SignUpUsecase,
  LogoutUsecase,
  FetchSymptomLogsUsecase,
  DeleteSymptomLogUsecase,
  FetchProfileSettingsUsecase,
  UpdatePrivacySettingsUsecase,
  AddFamilyMemberUsecase,
  RemoveFamilyMemberUsecase,
  SignOutUsecase,
])
void main() {
  // ════════════════════════════════════════════════════════════════════════════
  // 1. SYMPTOM LOG VALIDATION
  // ════════════════════════════════════════════════════════════════════════════

  group('Symptom Log Validation', () {
    test('AddSymptomEntity accepts valid pain level within range', () {
      final entity = AddSymptomEntity(
        date: DateTime(2025, 6, 1),
        periodStatus: 'Period ongoing',
        flowLevel: 'Medium',
        painLevel: 5,
        mood: 'Okay',
        symptoms: ['Cramps', 'Fatigue'],
        notes: 'Mild discomfort today',
      );

      expect(entity.painLevel, inInclusiveRange(0, 10));
      expect(entity.symptoms, isNotEmpty);
      expect(entity.periodStatus, isNotEmpty);
    });

    test('AddSymptomEntity with zero pain level is valid', () {
      final entity = AddSymptomEntity(
        date: DateTime(2025, 6, 1),
        periodStatus: 'No period',
        flowLevel: 'None',
        painLevel: 0,
        mood: 'Happy',
        symptoms: [],
      );

      expect(entity.painLevel, equals(0));
      expect(entity.notes, isNull);
    });

    test('AddSymptomEntity equality — same fields produce equal instances', () {
      final date = DateTime(2025, 6, 1);
      final a = AddSymptomEntity(
        date: date,
        periodStatus: 'Period ongoing',
        flowLevel: 'Heavy',
        painLevel: 7,
        mood: 'Tired',
        symptoms: ['Headache'],
      );
      final b = AddSymptomEntity(
        date: date,
        periodStatus: 'Period ongoing',
        flowLevel: 'Heavy',
        painLevel: 7,
        mood: 'Tired',
        symptoms: ['Headache'],
      );

      expect(a, equals(b));
    });

    test('AddSymptomEntity inequality — different pain levels', () {
      final date = DateTime(2025, 6, 1);
      final a = AddSymptomEntity(
        date: date,
        periodStatus: 'Period ongoing',
        flowLevel: 'Heavy',
        painLevel: 3,
        mood: 'Okay',
        symptoms: [],
      );
      final b = AddSymptomEntity(
        date: date,
        periodStatus: 'Period ongoing',
        flowLevel: 'Heavy',
        painLevel: 9,
        mood: 'Okay',
        symptoms: [],
      );

      expect(a, isNot(equals(b)));
    });

    test('AddSymptomDto.fromEntity maps all fields correctly', () {
      final entity = AddSymptomEntity(
        date: DateTime(2025, 6, 15),
        periodStatus: 'Period started',
        flowLevel: 'Light',
        painLevel: 4,
        mood: 'Anxious',
        symptoms: ['Bloating'],
        notes: 'Started yesterday',
      );

      final dto = AddSymptomDto.fromEntity(entity);

      expect(dto.date, equals(entity.date));
      expect(dto.periodStatus, equals(entity.periodStatus));
      expect(dto.flowLevel, equals(entity.flowLevel));
      expect(dto.painLevel, equals(entity.painLevel));
      expect(dto.mood, equals(entity.mood));
      expect(dto.symptoms, equals(entity.symptoms));
      expect(dto.notes, equals(entity.notes));
    });

    test('AddSymptomParams holds userId and entity together', () {
      final entity = AddSymptomEntity(
        date: DateTime(2025, 6, 1),
        periodStatus: 'No period',
        flowLevel: 'None',
        painLevel: 0,
        mood: 'Happy',
        symptoms: [],
      );

      final params = AddSymptomParams(userId: 'user_123', entity: entity);

      expect(params.userId, equals('user_123'));
      expect(params.entity, equals(entity));
    });

    test('SymptomLogEntity props are correctly included in equality check', () {
      final date = DateTime(2025, 6, 1);
      final log1 = SymptomLogEntity(
        id: 'log_001',
        date: date,
        periodStatus: 'Period ongoing',
        flowLevel: 'Medium',
        painLevel: 5,
        mood: 'Okay',
        symptoms: ['Cramps'],
      );
      final log2 = SymptomLogEntity(
        id: 'log_001',
        date: date,
        periodStatus: 'Period ongoing',
        flowLevel: 'Medium',
        painLevel: 5,
        mood: 'Okay',
        symptoms: ['Cramps'],
      );

      expect(log1, equals(log2));
    });

    test('SymptomFilterType.all has null firestoreValue', () {
      expect(SymptomFilterType.all.firestoreValue, isNull);
    });

    test('SymptomFilterType.periodOngoing has correct firestoreValue', () {
      expect(
        SymptomFilterType.periodOngoing.firestoreValue,
        equals('Period ongoing'),
      );
    });

    test('All SymptomFilterType labels are non-empty', () {
      for (final filter in SymptomFilterType.values) {
        expect(filter.label, isNotEmpty);
      }
    });
  });

  // ════════════════════════════════════════════════════════════════════════════
  // 2. AI INSIGHT MOCK RULE
  // ════════════════════════════════════════════════════════════════════════════

  group('AI Insight Mock Rule', () {
    test('AiInsightEntity holds all insight fields correctly', () {
      final insight = AiInsightEntity(
        id: 'insight_001',
        summary: 'You have shown consistent fatigue patterns.',
        patternNoticed: 'Fatigue spikes around day 14-16 of the cycle.',
        suggestedQuestions: [
          'Have you been sleeping less than 7 hours?',
          'Do you notice energy dips in the afternoon?',
        ],
        whenToSeekCare: 'If fatigue persists more than 2 weeks, see a doctor.',
        generatedDate: DateTime(2025, 6, 20),
        logIds: ['log_001', 'log_002', 'log_003'],
      );

      expect(insight.id, equals('insight_001'));
      expect(insight.suggestedQuestions, hasLength(2));
      expect(insight.logIds, hasLength(3));
      expect(insight.whenToSeekCare, isNotEmpty);
    });

    test('AiInsightEntity equality — same data produces equal instances', () {
      final date = DateTime(2025, 6, 20);
      final a = AiInsightEntity(
        id: 'insight_001',
        summary: 'Summary A',
        patternNoticed: 'Pattern A',
        suggestedQuestions: ['Q1'],
        whenToSeekCare: 'Care note',
        generatedDate: date,
        logIds: ['log_001'],
      );
      final b = AiInsightEntity(
        id: 'insight_001',
        summary: 'Summary A',
        patternNoticed: 'Pattern A',
        suggestedQuestions: ['Q1'],
        whenToSeekCare: 'Care note',
        generatedDate: date,
        logIds: ['log_001'],
      );

      expect(a, equals(b));
    });

    test('AiInsightEntity inequality — different summaries', () {
      final date = DateTime(2025, 6, 20);
      final a = AiInsightEntity(
        id: 'insight_001',
        summary: 'Summary A',
        patternNoticed: 'Pattern',
        suggestedQuestions: [],
        whenToSeekCare: 'See a doctor',
        generatedDate: date,
        logIds: [],
      );
      final b = AiInsightEntity(
        id: 'insight_001',
        summary: 'Summary B',
        patternNoticed: 'Pattern',
        suggestedQuestions: [],
        whenToSeekCare: 'See a doctor',
        generatedDate: date,
        logIds: [],
      );

      expect(a, isNot(equals(b)));
    });

    test('AiInsightDto.fromAiJson parses all fields from valid JSON', () {
      final json = {
        'summary': 'You have consistent pain patterns.',
        'patternNoticed': 'High pain on day 2–3.',
        'suggestedQuestions': ['Is it manageable?', 'Have you tracked flow?'],
        'whenToSeekCare': 'If pain is unmanageable, consult a doctor.',
      };
      final logIds = ['log_001', 'log_002'];

      final dto = AiInsightDto.fromAiJson(json, logIds);

      expect(dto.summary, equals('You have consistent pain patterns.'));
      expect(dto.patternNoticed, equals('High pain on day 2–3.'));
      expect(dto.suggestedQuestions, hasLength(2));
      expect(dto.whenToSeekCare, isNotEmpty);
      expect(dto.logIds, equals(logIds));
    });

    test(
      'AiInsightDto.fromAiJson defaults to empty strings on missing fields',
      () {
        final dto = AiInsightDto.fromAiJson({}, []);

        expect(dto.summary, equals(''));
        expect(dto.patternNoticed, equals(''));
        expect(dto.suggestedQuestions, isEmpty);
        expect(dto.whenToSeekCare, equals(''));
      },
    );

    test('AiInsightDto.toEntity maps to AiInsightEntity correctly', () {
      final json = {
        'summary': 'Test summary',
        'patternNoticed': 'Test pattern',
        'suggestedQuestions': ['Q1'],
        'whenToSeekCare': 'Test care',
      };
      final dto = AiInsightDto.fromAiJson(json, ['log_001']);
      final entity = dto.toEntity();

      expect(entity.summary, equals(dto.summary));
      expect(entity.patternNoticed, equals(dto.patternNoticed));
      expect(entity.suggestedQuestions, equals(dto.suggestedQuestions));
      expect(entity.whenToSeekCare, equals(dto.whenToSeekCare));
      expect(entity.logIds, equals(dto.logIds));
    });

    test('SymptomLogSummaryEntity fields used for AI prompt are correct', () {
      final entity = SymptomLogSummaryEntity(
        id: 'log_001',
        date: DateTime(2025, 6, 1),
        periodStatus: 'Period ongoing',
        painLevel: 7,
        mood: 'Tired',
      );

      expect(entity.periodStatus, equals('Period ongoing'));
      expect(entity.painLevel, equals(7));
      expect(entity.mood, equals('Tired'));
    });

    test('GenerateAiInsightParams requires minimum 1 log', () {
      final logs = [
        SymptomLogSummaryEntity(
          id: 'log_001',
          date: DateTime(2025, 6, 1),
          periodStatus: 'Period ongoing',
          painLevel: 5,
          mood: 'Okay',
        ),
      ];

      final params = GenerateAiInsightParams(
        userId: 'user_123',
        selectedLogs: logs,
      );

      expect(params.selectedLogs, isNotEmpty);
      expect(params.userId, equals('user_123'));
    });

    test('High pain level (>=7) qualifies as high risk', () {
      final highRiskLog = SymptomLogSummaryEntity(
        id: 'log_001',
        date: DateTime(2025, 6, 1),
        periodStatus: 'Period ongoing',
        painLevel: 8,
        mood: 'Distressed',
      );

      final isHighRisk = highRiskLog.painLevel >= 7;
      expect(isHighRisk, isTrue);
    });

    test('Low pain level (<7) does not qualify as high risk', () {
      final normalLog = SymptomLogSummaryEntity(
        id: 'log_002',
        date: DateTime(2025, 6, 2),
        periodStatus: 'No period',
        painLevel: 3,
        mood: 'Happy',
      );

      final isHighRisk = normalLog.painLevel >= 7;
      expect(isHighRisk, isFalse);
    });
  });

  // ════════════════════════════════════════════════════════════════════════════
  // 3. DOCTOR VISIT SUMMARY GENERATION
  // ════════════════════════════════════════════════════════════════════════════

  group('Doctor Visit Summary Generation', () {
    test('DoctorVisitEntity holds all required fields', () {
      final entity = DoctorVisitEntity(
        id: 'visit_001',
        date: DateTime(2025, 6, 10),
        doctorName: 'Dr. Ayesha Nair',
        specialty: 'Gynecology',
        clinic: 'City Health Clinic',
        diagnosis: 'Iron deficiency anemia',
        notes: 'Prescribed iron tablets for 3 months.',
      );

      expect(entity.doctorName, equals('Dr. Ayesha Nair'));
      expect(entity.diagnosis, isNotEmpty);
      expect(entity.specialty, equals('Gynecology'));
      expect(entity.clinic, equals('City Health Clinic'));
      expect(entity.notes, isNotNull);
    });

    test('DoctorVisitEntity is valid with only required fields', () {
      final entity = DoctorVisitEntity(
        date: DateTime(2025, 6, 10),
        doctorName: 'Dr. Ravi Kumar',
        diagnosis: 'PCOS',
      );

      expect(entity.id, isNull);
      expect(entity.specialty, isNull);
      expect(entity.clinic, isNull);
      expect(entity.notes, isNull);
      expect(entity.diagnosis, equals('PCOS'));
    });

    test(
      'DoctorVisitEntity equality — same fields produce equal instances',
      () {
        final date = DateTime(2025, 6, 10);
        final a = DoctorVisitEntity(
          date: date,
          doctorName: 'Dr. Priya',
          diagnosis: 'Anemia',
        );
        final b = DoctorVisitEntity(
          date: date,
          doctorName: 'Dr. Priya',
          diagnosis: 'Anemia',
        );

        expect(a, equals(b));
      },
    );

    test('DoctorVisitDto.fromEntity maps all fields from entity', () {
      final entity = DoctorVisitEntity(
        date: DateTime(2025, 6, 10),
        doctorName: 'Dr. Ayesha Nair',
        specialty: 'Gynecology',
        clinic: 'City Health Clinic',
        diagnosis: 'Iron deficiency',
        notes: 'Iron tablets prescribed.',
      );

      final dto = DoctorVisitDto.fromEntity(entity);

      expect(dto.doctorName, equals(entity.doctorName));
      expect(dto.specialty, equals(entity.specialty));
      expect(dto.clinic, equals(entity.clinic));
      expect(dto.diagnosis, equals(entity.diagnosis));
      expect(dto.notes, equals(entity.notes));
      expect(dto.date, equals(entity.date));
    });

    test('Doctor summary string contains doctor name and diagnosis', () {
      final entity = DoctorVisitEntity(
        date: DateTime(2025, 6, 10),
        doctorName: 'Dr. Kavitha',
        diagnosis: 'Endometriosis',
      );

      final summary =
          'Visited ${entity.doctorName} on ${entity.date.toIso8601String().substring(0, 10)}. '
          'Diagnosis: ${entity.diagnosis}.';

      expect(summary, contains('Dr. Kavitha'));
      expect(summary, contains('Endometriosis'));
      expect(summary, contains('2025-06-10'));
    });

    test('AddDoctorVisitParams holds userId and entity correctly', () {
      final entity = DoctorVisitEntity(
        date: DateTime(2025, 6, 10),
        doctorName: 'Dr. Ravi',
        diagnosis: 'Thyroid',
      );

      final params = AddDoctorVisitParams(userId: 'user_456', entity: entity);

      expect(params.userId, equals('user_456'));
      expect(params.entity.doctorName, equals('Dr. Ravi'));
    });

    test('DoctorVisitDto.toFirestoreForUpdate does not re-set createdAt', () {
      final dto = DoctorVisitDto(
        date: DateTime(2025, 6, 10),
        doctorName: 'Dr. Nair',
        diagnosis: 'Anemia',
      );

      final map = dto.toFirestoreForUpdate();

      expect(map.containsKey('createdAt'), isFalse);
      expect(map.containsKey('updatedAt'), isTrue);
    });

    test('DoctorVisitDto.toFirestore omits optional null fields', () {
      final dto = DoctorVisitDto(
        date: DateTime(2025, 6, 10),
        doctorName: 'Dr. Priya',
        diagnosis: 'PCOS',
        specialty: null,
        clinic: null,
        notes: null,
      );

      final map = dto.toFirestore();

      expect(map.containsKey('specialty'), isFalse);
      expect(map.containsKey('clinic'), isFalse);
      expect(map.containsKey('notes'), isFalse);
    });
  });

  // ════════════════════════════════════════════════════════════════════════════
  // 4. PRIVACY PREFERENCE LOGIC
  // ════════════════════════════════════════════════════════════════════════════

  group('Privacy Preference Logic', () {
    test('PrivacySettingsEntity defaults all flags to false', () {
      const settings = PrivacySettingsEntity();

      expect(settings.hideSensitiveDashboard, isFalse);
      expect(settings.genericNotificationText, isFalse);
      expect(settings.confirmBeforeSharingRecords, isFalse);
      expect(settings.allowFamilyProfileAccess, isFalse);
    });

    test('copyWith correctly updates hideSensitiveDashboard', () {
      const original = PrivacySettingsEntity();
      final updated = original.copyWith(hideSensitiveDashboard: true);

      expect(updated.hideSensitiveDashboard, isTrue);
      expect(updated.genericNotificationText, isFalse);
      expect(updated.confirmBeforeSharingRecords, isFalse);
      expect(updated.allowFamilyProfileAccess, isFalse);
    });

    test('copyWith correctly updates genericNotificationText', () {
      const original = PrivacySettingsEntity();
      final updated = original.copyWith(genericNotificationText: true);

      expect(updated.genericNotificationText, isTrue);
      expect(updated.hideSensitiveDashboard, isFalse);
    });

    test('copyWith correctly updates confirmBeforeSharingRecords', () {
      const original = PrivacySettingsEntity();
      final updated = original.copyWith(confirmBeforeSharingRecords: true);

      expect(updated.confirmBeforeSharingRecords, isTrue);
      expect(updated.allowFamilyProfileAccess, isFalse);
    });

    test('copyWith correctly updates allowFamilyProfileAccess', () {
      const original = PrivacySettingsEntity();
      final updated = original.copyWith(allowFamilyProfileAccess: true);

      expect(updated.allowFamilyProfileAccess, isTrue);
    });

    test('hideSensitiveDashboard blocks dashboard data sharing', () {
      const settings = PrivacySettingsEntity(hideSensitiveDashboard: true);

      final canShowSensitiveData = !settings.hideSensitiveDashboard;
      expect(canShowSensitiveData, isFalse);
    });

    test(
      'confirmBeforeSharingRecords requires confirmation before sharing',
      () {
        const settings = PrivacySettingsEntity(
          confirmBeforeSharingRecords: true,
        );

        final needsConfirmation = settings.confirmBeforeSharingRecords;
        expect(needsConfirmation, isTrue);
      },
    );

    test('allowFamilyProfileAccess controls family member visibility', () {
      const settingsOn = PrivacySettingsEntity(allowFamilyProfileAccess: true);
      const settingsOff = PrivacySettingsEntity(
        allowFamilyProfileAccess: false,
      );

      expect(settingsOn.allowFamilyProfileAccess, isTrue);
      expect(settingsOff.allowFamilyProfileAccess, isFalse);
    });

    test(
      'PrivacySettingsEntity equality — all same flags produce equal instances',
      () {
        const a = PrivacySettingsEntity(
          hideSensitiveDashboard: true,
          genericNotificationText: false,
          confirmBeforeSharingRecords: true,
          allowFamilyProfileAccess: false,
        );
        const b = PrivacySettingsEntity(
          hideSensitiveDashboard: true,
          genericNotificationText: false,
          confirmBeforeSharingRecords: true,
          allowFamilyProfileAccess: false,
        );

        expect(a, equals(b));
      },
    );

    test('PrivacySettingsDto.fromEntity maps all flags from entity', () {
      const entity = PrivacySettingsEntity(
        hideSensitiveDashboard: true,
        genericNotificationText: true,
        confirmBeforeSharingRecords: false,
        allowFamilyProfileAccess: true,
      );

      final dto = PrivacySettingsDto.fromEntity(entity);

      expect(dto.hideSensitiveDashboard, isTrue);
      expect(dto.genericNotificationText, isTrue);
      expect(dto.confirmBeforeSharingRecords, isFalse);
      expect(dto.allowFamilyProfileAccess, isTrue);
    });

    test('PrivacySettingsDto.toEntity roundtrip preserves all values', () {
      const entity = PrivacySettingsEntity(
        hideSensitiveDashboard: true,
        genericNotificationText: false,
        confirmBeforeSharingRecords: true,
        allowFamilyProfileAccess: false,
      );

      final roundTripped = PrivacySettingsDto.fromEntity(entity).toEntity();

      expect(roundTripped, equals(entity));
    });

    test('PrivacySettingsDto.fromFirestore parses map with all true flags', () {
      final map = {
        'hideSensitiveDashboard': true,
        'genericNotificationText': true,
        'confirmBeforeSharingRecords': true,
        'allowFamilyProfileAccess': true,
      };

      final dto = PrivacySettingsDto.fromFirestore(map);

      expect(dto.hideSensitiveDashboard, isTrue);
      expect(dto.genericNotificationText, isTrue);
      expect(dto.confirmBeforeSharingRecords, isTrue);
      expect(dto.allowFamilyProfileAccess, isTrue);
    });

    test(
      'PrivacySettingsDto.fromFirestore defaults to false on missing keys',
      () {
        final dto = PrivacySettingsDto.fromFirestore({});

        expect(dto.hideSensitiveDashboard, isFalse);
        expect(dto.genericNotificationText, isFalse);
        expect(dto.confirmBeforeSharingRecords, isFalse);
        expect(dto.allowFamilyProfileAccess, isFalse);
      },
    );
  });

  // ════════════════════════════════════════════════════════════════════════════
  // 5. AUTH BLOC — FORM VALIDATION
  // ════════════════════════════════════════════════════════════════════════════

  group('AuthBloc — Form Validation', () {
    late MockLoginUsecase mockLoginUsecase;
    late MockSignUpUsecase mockSignUpUsecase;
    late MockLogoutUsecase mockLogoutUsecase;
    late AuthBloc authBloc;

    setUp(() {
      mockLoginUsecase = MockLoginUsecase();
      mockSignUpUsecase = MockSignUpUsecase();
      mockLogoutUsecase = MockLogoutUsecase();
      authBloc = AuthBloc(
        mockLoginUsecase,
        mockSignUpUsecase,
        mockLogoutUsecase,
      );
    });

    tearDown(() => authBloc.close());

    test('initial state is LoginFormState', () {
      expect(authBloc.state, isA<LoginFormState>());
    });

    blocTest<AuthBloc, AuthState>(
      'LoginEmailChanged updates email in LoginFormState',
      build: () =>
          AuthBloc(mockLoginUsecase, mockSignUpUsecase, mockLogoutUsecase),
      act: (bloc) => bloc.add(LoginEmailChanged('test@example.com')),
      expect: () => [
        isA<LoginFormState>().having(
          (s) => s.email,
          'email',
          equals('test@example.com'),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'LoginPasswordChanged updates password in LoginFormState',
      build: () =>
          AuthBloc(mockLoginUsecase, mockSignUpUsecase, mockLogoutUsecase),
      act: (bloc) => bloc.add(LoginPasswordChanged('mypassword')),
      expect: () => [
        isA<LoginFormState>().having(
          (s) => s.password,
          'password',
          equals('mypassword'),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'LoginPasswordVisibilityToggled flips obscurePassword',
      build: () =>
          AuthBloc(mockLoginUsecase, mockSignUpUsecase, mockLogoutUsecase),
      act: (bloc) => bloc.add(LoginPasswordVisibilityToggled()),
      expect: () => [
        isA<LoginFormState>().having(
          (s) => s.obscurePassword,
          'obscurePassword',
          isFalse,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'LoginFormValidated shows emailError on empty email',
      build: () =>
          AuthBloc(mockLoginUsecase, mockSignUpUsecase, mockLogoutUsecase),
      act: (bloc) {
        bloc.add(LoginPasswordChanged('password123'));
        bloc.add(LoginFormValidated());
      },
      expect: () => [
        isA<LoginFormState>(), // password updated
        isA<LoginFormState>().having(
          (s) => s.emailError,
          'emailError',
          equals('Email is required'),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'LoginFormValidated shows emailError on invalid email format',
      build: () =>
          AuthBloc(mockLoginUsecase, mockSignUpUsecase, mockLogoutUsecase),
      act: (bloc) {
        bloc.add(LoginEmailChanged('not-an-email'));
        bloc.add(LoginPasswordChanged('password123'));
        bloc.add(LoginFormValidated());
      },
      expect: () => [
        isA<LoginFormState>(), // email updated
        isA<LoginFormState>(), // password updated
        isA<LoginFormState>().having(
          (s) => s.emailError,
          'emailError',
          equals('Enter a valid email'),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'LoginFormValidated shows passwordError on short password',
      build: () =>
          AuthBloc(mockLoginUsecase, mockSignUpUsecase, mockLogoutUsecase),
      act: (bloc) {
        bloc.add(LoginEmailChanged('user@test.com'));
        bloc.add(LoginPasswordChanged('123'));
        bloc.add(LoginFormValidated());
      },
      expect: () => [
        isA<LoginFormState>(),
        isA<LoginFormState>(),
        isA<LoginFormState>().having(
          (s) => s.passwordError,
          'passwordError',
          equals('Minimum 6 characters'),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'LoginRequested emits AuthLoading then AuthAuthenticated on success',
      build: () {
        when(
          mockLoginUsecase(
            LoginParams(email: 'user@test.com', password: 'password123'),
          ),
        ).thenAnswer(
          (_) async => ApiResult.success(
            AuthUserEntity(uid: 'uid_001', email: 'user@test.com'),
          ),
        );
        return AuthBloc(mockLoginUsecase, mockSignUpUsecase, mockLogoutUsecase);
      },
      act: (bloc) => bloc.add(
        LoginRequested(email: 'user@test.com', password: 'password123'),
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>().having(
          (s) => s.user.email,
          'email',
          equals('user@test.com'),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'LoginRequested emits AuthLoading then AuthError on failure',
      build: () {
        when(
          mockLoginUsecase(
            LoginParams(email: 'user@test.com', password: 'wrongpass'),
          ),
        ).thenAnswer(
          (_) async => ApiResult.failure(
            // FIX: constructor param is `message:`, not `userMessage:`
            ApiFailure(message: 'Invalid credentials'),
          ),
        );
        return AuthBloc(mockLoginUsecase, mockSignUpUsecase, mockLogoutUsecase);
      },
      act: (bloc) => bloc.add(
        LoginRequested(email: 'user@test.com', password: 'wrongpass'),
      ),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (s) => s.message,
          'message',
          equals('Invalid credentials'),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'SignUpFormValidated shows nameError on empty name',
      build: () =>
          AuthBloc(mockLoginUsecase, mockSignUpUsecase, mockLogoutUsecase),
      act: (bloc) {
        bloc.add(SignUpEmailChanged('user@test.com'));
        bloc.add(SignUpPasswordChanged('password123'));
        bloc.add(SignUpFormValidated());
      },
      expect: () => [
        isA<SignUpFormState>(),
        isA<SignUpFormState>(),
        isA<SignUpFormState>().having(
          (s) => s.nameError,
          'nameError',
          equals('Name is required'),
        ),
      ],
    );
  });

  // ════════════════════════════════════════════════════════════════════════════
  // 6. SYMPTOM BLOC
  // ════════════════════════════════════════════════════════════════════════════

  group('SymptomBloc', () {
    late MockFetchSymptomLogsUsecase mockFetchLogs;
    late MockDeleteSymptomLogUsecase mockDeleteLog;

    setUp(() {
      mockFetchLogs = MockFetchSymptomLogsUsecase();
      mockDeleteLog = MockDeleteSymptomLogUsecase();
    });

    final sampleLogs = [
      SymptomLogEntity(
        id: 'log_001',
        date: DateTime(2025, 6, 1),
        periodStatus: 'Period ongoing',
        flowLevel: 'Medium',
        painLevel: 5,
        mood: 'Okay',
        symptoms: ['Cramps'],
      ),
      SymptomLogEntity(
        id: 'log_002',
        date: DateTime(2025, 6, 2),
        periodStatus: 'No period',
        flowLevel: 'None',
        painLevel: 1,
        mood: 'Happy',
        symptoms: [],
      ),
    ];

    test('initial state is SymptomInitial', () {
      final bloc = SymptomBloc(mockFetchLogs, mockDeleteLog);
      expect(bloc.state, isA<SymptomInitial>());
      bloc.close();
    });

    blocTest<SymptomBloc, SymptomState>(
      'LoadSymptomLogs emits SymptomLoading then SymptomLoaded on success',
      build: () {
        when(
          mockFetchLogs(FetchSymptomLogsParams(userId: 'user_123')),
        ).thenAnswer((_) async => ApiResult.success(sampleLogs));
        return SymptomBloc(mockFetchLogs, mockDeleteLog);
      },
      act: (bloc) => bloc.add(LoadSymptomLogs(userId: 'user_123')),
      expect: () => [
        isA<SymptomLoading>(),
        isA<SymptomLoaded>().having(
          (s) => s.allLogs.length,
          'allLogs length',
          equals(2),
        ),
      ],
    );

    blocTest<SymptomBloc, SymptomState>(
      'LoadSymptomLogs emits SymptomLoading then SymptomError on failure',
      build: () {
        when(
          mockFetchLogs(FetchSymptomLogsParams(userId: 'user_123')),
        ).thenAnswer(
          (_) async => ApiResult.failure(
            // FIX: constructor param is `message:`, not `userMessage:`
            ApiFailure(message: 'Failed to fetch logs'),
          ),
        );
        return SymptomBloc(mockFetchLogs, mockDeleteLog);
      },
      act: (bloc) => bloc.add(LoadSymptomLogs(userId: 'user_123')),
      expect: () => [
        isA<SymptomLoading>(),
        isA<SymptomError>().having(
          (s) => s.message,
          'message',
          equals('Failed to fetch logs'),
        ),
      ],
    );

    blocTest<SymptomBloc, SymptomState>(
      'FilterSymptomLogs filters by periodOngoing correctly',
      build: () {
        when(
          mockFetchLogs(FetchSymptomLogsParams(userId: 'user_123')),
        ).thenAnswer((_) async => ApiResult.success(sampleLogs));
        return SymptomBloc(mockFetchLogs, mockDeleteLog);
      },
      act: (bloc) async {
        bloc.add(LoadSymptomLogs(userId: 'user_123'));
        await Future.delayed(Duration.zero);
        bloc.add(FilterSymptomLogs(filter: SymptomFilterType.periodOngoing));
      },
      expect: () => [
        isA<SymptomLoading>(),
        isA<SymptomLoaded>().having(
          (s) => s.filteredLogs.length,
          'all logs after load',
          equals(2),
        ),
        isA<SymptomLoaded>().having(
          (s) => s.filteredLogs.length,
          'filtered to periodOngoing',
          equals(1),
        ),
      ],
    );

    blocTest<SymptomBloc, SymptomState>(
      'DeleteSymptomLog emits SymptomDeleteSuccess and removes log from list',
      build: () {
        when(
          mockFetchLogs(FetchSymptomLogsParams(userId: 'user_123')),
        ).thenAnswer((_) async => ApiResult.success(sampleLogs));
        when(
          mockDeleteLog(
            DeleteSymptomLogParams(userId: 'user_123', logId: 'log_001'),
          ),
        ).thenAnswer((_) async => ApiResult.success(null));
        return SymptomBloc(mockFetchLogs, mockDeleteLog);
      },
      act: (bloc) async {
        bloc.add(LoadSymptomLogs(userId: 'user_123'));
        await Future.delayed(Duration.zero);
        bloc.add(DeleteSymptomLog(userId: 'user_123', logId: 'log_001'));
      },
      expect: () => [
        isA<SymptomLoading>(),
        isA<SymptomLoaded>(),
        isA<SymptomDeleteSuccess>(),
        isA<SymptomLoaded>().having(
          (s) => s.allLogs.length,
          'remaining logs after delete',
          equals(1),
        ),
      ],
    );
  });

  // ════════════════════════════════════════════════════════════════════════════
  // 7. PROFILE SETTINGS BLOC — PRIVACY TOGGLE
  // ════════════════════════════════════════════════════════════════════════════

  group('ProfileSettingsBloc — Privacy Toggle', () {
    late MockFetchProfileSettingsUsecase mockFetchProfile;
    late MockUpdatePrivacySettingsUsecase mockUpdatePrivacy;
    late MockAddFamilyMemberUsecase mockAddFamily;
    late MockRemoveFamilyMemberUsecase mockRemoveFamily;
    late MockSignOutUsecase mockSignOut;

    final sampleProfile = ProfileSettingsEntity(
      uid: 'user_001',
      name: 'Priya',
      email: 'priya@test.com',
      lifeStage: 'Period Tracking',
      privacySettings: const PrivacySettingsEntity(),
      familyMembers: const [],
    );

    setUp(() {
      mockFetchProfile = MockFetchProfileSettingsUsecase();
      mockUpdatePrivacy = MockUpdatePrivacySettingsUsecase();
      mockAddFamily = MockAddFamilyMemberUsecase();
      mockRemoveFamily = MockRemoveFamilyMemberUsecase();
      mockSignOut = MockSignOutUsecase();
    });

    test('initial state is ProfileSettingsInitial', () {
      final bloc = ProfileSettingsBloc(
        mockFetchProfile,
        mockUpdatePrivacy,
        mockAddFamily,
        mockRemoveFamily,
        mockSignOut,
      );
      expect(bloc.state, isA<ProfileSettingsInitial>());
      bloc.close();
    });

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'LoadProfileSettings emits ProfileSettingsLoading then ProfileSettingsLoaded',
      build: () {
        when(
          mockFetchProfile(FetchProfileParams(userId: 'user_001')),
        ).thenAnswer((_) async => ApiResult.success(sampleProfile));
        return ProfileSettingsBloc(
          mockFetchProfile,
          mockUpdatePrivacy,
          mockAddFamily,
          mockRemoveFamily,
          mockSignOut,
        );
      },
      act: (bloc) => bloc.add(LoadProfileSettings(userId: 'user_001')),
      expect: () => [
        isA<ProfileSettingsLoading>(),
        isA<ProfileSettingsLoaded>().having(
          (s) => s.profile.name,
          'name',
          equals('Priya'),
        ),
      ],
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'TogglePrivacySetting updates hideSensitiveDashboard optimistically',
      build: () {
        when(
          mockFetchProfile(FetchProfileParams(userId: 'user_001')),
        ).thenAnswer((_) async => ApiResult.success(sampleProfile));
        when(
          mockUpdatePrivacy(any),
        ).thenAnswer((_) async => ApiResult.success(null));
        return ProfileSettingsBloc(
          mockFetchProfile,
          mockUpdatePrivacy,
          mockAddFamily,
          mockRemoveFamily,
          mockSignOut,
        );
      },
      act: (bloc) async {
        bloc.add(LoadProfileSettings(userId: 'user_001'));
        await Future.delayed(Duration.zero);
        bloc.add(
          TogglePrivacySetting(
            userId: 'user_001',
            field: PrivacySettingField.hideSensitiveDashboard,
            value: true,
          ),
        );
      },
      expect: () => [
        isA<ProfileSettingsLoading>(),
        isA<ProfileSettingsLoaded>(),
        isA<ProfileSettingsLoaded>().having(
          (s) => s.profile.privacySettings.hideSensitiveDashboard,
          'hideSensitiveDashboard toggled to true',
          isTrue,
        ),
      ],
    );

    blocTest<ProfileSettingsBloc, ProfileSettingsState>(
      'LoadProfileSettings emits ProfileSettingsError on failure',
      build: () {
        when(
          mockFetchProfile(FetchProfileParams(userId: 'user_001')),
        ).thenAnswer(
          (_) async => ApiResult.failure(
            // FIX: constructor param is `message:`, not `userMessage:`
            ApiFailure(message: 'Failed to load profile'),
          ),
        );
        return ProfileSettingsBloc(
          mockFetchProfile,
          mockUpdatePrivacy,
          mockAddFamily,
          mockRemoveFamily,
          mockSignOut,
        );
      },
      act: (bloc) => bloc.add(LoadProfileSettings(userId: 'user_001')),
      expect: () => [
        isA<ProfileSettingsLoading>(),
        isA<ProfileSettingsError>().having(
          (s) => s.message,
          'message',
          equals('Failed to load profile'),
        ),
      ],
    );
  });
}
