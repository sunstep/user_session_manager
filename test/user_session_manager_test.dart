import 'package:flutter_test/flutter_test.dart';
import 'package:user_session_manager/src/application/user_session_service.dart';
import 'package:user_session_manager/user_session_manager.dart';

import 'fake_user.dart';
import 'mock_session_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('UserSessionManager (in-memory)', () {
    late UserSessionManager<FakeUser> sessionManager;

    setUp(() async {
      final repo = InMemorySessionRepository<FakeUser>();
      final service = UserSessionService.forTesting(repo);
      sessionManager = UserSessionManager.forTesting(service);
    });

    test('Initially not logged in', () async {
      expect(await sessionManager.isLoggedIn(), isFalse);
    });

    test('Login + Get', () async {
      final user = FakeUser(1, 'Alice');
      await sessionManager.login(user);
      expect(await sessionManager.getUser(), equals(user));
    });

    test('Logout clears session', () async {
      await sessionManager.login(FakeUser(1, 'Alice'));
      await sessionManager.logout();
      expect(await sessionManager.getUser(), isNull);
    });
  });
}