import 'package:flutter_test/flutter_test.dart';
import 'package:mobatech_app/core/utils/validators.dart';
import 'package:mobatech_app/core/constants/strings/error_strings.dart';

void main() {
  group('Validators Email Tests', () {
    test('valid emails from trusted providers pass', () {
      final valid = [
        'pasien@gmail.com',
        'dokter@herminahospitals.com',
        'admin@outlook.com',
        'user@yahoo.co.id',
        'staff@kemkes.go.id',
        'user@icloud.com',
        'user@proton.me',
      ];
      for (final email in valid) {
        expect(Validators.validateEmail(email), isNull, reason: 'Failed on $email');
      }
    });

    test('typo domains like .co or gmial are blocked', () {
      expect(
        Validators.validateEmail('pasien@gmail.co'),
        ErrorStrings.errEmailTypo,
      );
      expect(
        Validators.validateEmail('user@yahoo.co'),
        ErrorStrings.errEmailTypo,
      );
      expect(
        Validators.validateEmail('user@gmial.com'),
        ErrorStrings.errEmailTypo,
      );
    });

    test('invalid formats fail with errEmailInvalid', () {
      expect(Validators.validateEmail('plainaddress'), ErrorStrings.errEmailInvalid);
      expect(Validators.validateEmail('@nodomain.com'), ErrorStrings.errEmailInvalid);
      expect(Validators.validateEmail('user@.com'), ErrorStrings.errEmailInvalid);
    });
  });

  group('Validators Name Tests', () {
    test('valid names pass', () {
      final valid = [
        'Budi Santoso',
        'dr. Siti Aminah, Sp.A',
        "John O'Connor",
        'Jean-Luc Picard',
      ];
      for (final name in valid) {
        expect(Validators.validateName(name, 'Nama'), isNull, reason: 'Failed on $name');
      }
    });

    test('names with numbers or symbols fail', () {
      expect(Validators.validateName('Budi123', 'Nama'), ErrorStrings.errInvalidName);
      expect(Validators.validateName('User @Name', 'Nama'), ErrorStrings.errInvalidName);
      expect(Validators.validateName('A', 'Nama'), ErrorStrings.errInvalidName);
    });
  });

  group('Validators Phone Tests', () {
    test('valid Indonesian phones pass', () {
      final valid = [
        '081234567890',
        '+6281234567890',
        '6281234567890',
        '085712345678',
      ];
      for (final phone in valid) {
        expect(Validators.validatePhone(phone), isNull, reason: 'Failed on $phone');
      }
    });

    test('invalid phones fail', () {
      expect(Validators.validatePhone('0812'), ErrorStrings.errInvalidPhone);
      expect(Validators.validatePhone('081234567890123456'), ErrorStrings.errInvalidPhone);
      expect(Validators.validatePhone('0812345abc'), ErrorStrings.errInvalidPhone);
      expect(Validators.validatePhone('021123456'), ErrorStrings.errInvalidPhone);
    });
  });

  group('Validators Password Tests', () {
    test('strong passwords pass', () {
      expect(Validators.validatePassword('Password123'), isNull);
      expect(Validators.validatePassword('HerminaAdmin2026!'), isNull);
    });

    test('weak passwords fail', () {
      expect(Validators.validatePassword('short1A'), ErrorStrings.errWeakPassword);
      expect(Validators.validatePassword('alllowercase123'), ErrorStrings.errWeakPassword);
      expect(Validators.validatePassword('ALLUPPERCASE123'), ErrorStrings.errWeakPassword);
      expect(Validators.validatePassword('NoDigitsHerePassword'), ErrorStrings.errWeakPassword);
    });
  });
}
