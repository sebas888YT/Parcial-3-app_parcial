import 'package:app_parcial/auth/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('emailValidator', () {
    test('requires an email and rejects malformed addresses', () {
      expect(emailValidator('   '), 'Este campo es obligatorio.');
      expect(emailValidator('correo-invalido'), isNotNull);
      expect(emailValidator('persona@example.com'), isNull);
    });
  });

  group('password validators', () {
    test('requires at least six characters', () {
      expect(passwordValidator('12345'), isNotNull);
      expect(passwordValidator('123456'), isNull);
    });

    test('requires matching confirmation', () {
      expect(confirmPasswordValidator('', 'clave123'), isNotNull);
      expect(confirmPasswordValidator('otra123', 'clave123'), isNotNull);
      expect(confirmPasswordValidator('clave123', 'clave123'), isNull);
    });
  });
}
