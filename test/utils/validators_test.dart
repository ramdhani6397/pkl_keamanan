import 'package:flutter_test/flutter_test.dart';
import 'package:pkl_keamanan/utils/validators.dart';

void main() {
  group('isValidEmail', () {
    test('menerima email dengan format valid', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
      expect(Validators.isValidEmail('nama.belakang@amikom.ac.id'), isTrue);
    });

    test('menolak email tanpa simbol @', () {
      expect(Validators.isValidEmail('userexample.com'), isFalse);
    });

    test('menolak email tanpa bagian nama sebelum @', () {
      expect(Validators.isValidEmail('@example.com'), isFalse);
    });

    test('menolak email tanpa domain setelah @', () {
      expect(Validators.isValidEmail('user@'), isFalse);
    });

    test('menolak email tanpa titik pada domain', () {
      expect(Validators.isValidEmail('user@example'), isFalse);
    });

    test('menolak email dengan dua simbol @', () {
      expect(Validators.isValidEmail('user@@example.com'), isFalse);
    });

    test('menolak string kosong', () {
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('sanitize', () {
    test('mengganti tag HTML dengan entity', () {
      expect(
        Validators.sanitize('<script>alert("x")</script>'),
        '&lt;script&gt;alert(&quot;x&quot;)&lt;/script&gt;',
      );
    });

    test('mengganti tanda kutip tunggal', () {
      expect(Validators.sanitize("it's"), 'it&#39;s');
    });

    test('mengganti karakter ampersand', () {
      expect(Validators.sanitize('a & b'), 'a &amp; b');
    });

    test('menghapus spasi di awal dan akhir', () {
      expect(Validators.sanitize('  hello  '), 'hello');
    });

    test('tidak mengubah teks yang aman', () {
      expect(Validators.sanitize('Halo Dunia 123'), 'Halo Dunia 123');
    });

    test('hasil sanitasi tidak lagi mengandung karakter < dan >', () {
      final result = Validators.sanitize('<img src=x onerror=alert(1)>');
      expect(result.contains('<'), isFalse);
      expect(result.contains('>'), isFalse);
    });
  });

  group('validateText', () {
    test('menolak null', () {
      expect(Validators.validateText(null), 'Field tidak boleh kosong');
    });

    test('menolak string kosong dan hanya spasi', () {
      expect(Validators.validateText(''), 'Field tidak boleh kosong');
      expect(Validators.validateText('   '), 'Field tidak boleh kosong');
    });

    test('memakai nama field pada pesan error', () {
      expect(
        Validators.validateText('', fieldName: 'Nama'),
        'Nama tidak boleh kosong',
      );
    });

    test('menerima teks dengan panjang normal', () {
      expect(Validators.validateText('abc'), isNull);
    });

    test('menerima teks tepat 100 karakter (batas atas)', () {
      expect(Validators.validateText('a' * 100), isNull);
    });

    test('menolak teks 101 karakter', () {
      expect(
        Validators.validateText('a' * 101),
        'Field harus antara 1-100 karakter',
      );
    });

    test('menolak teks lebih pendek dari minLength', () {
      expect(
        Validators.validateText('ab', minLength: 3),
        'Field harus antara 3-100 karakter',
      );
    });

    test('menerima teks tepat sepanjang minLength', () {
      expect(Validators.validateText('abc', minLength: 3), isNull);
    });
  });

  group('isNotEmpty dan hasValidLength', () {
    test('isNotEmpty', () {
      expect(Validators.isNotEmpty('a'), isTrue);
      expect(Validators.isNotEmpty('   '), isFalse);
      expect(Validators.isNotEmpty(null), isFalse);
    });

    test('hasValidLength memakai panjang setelah trim', () {
      expect(Validators.hasValidLength('  a  '), isTrue);
      expect(Validators.hasValidLength('a' * 101), isFalse);
    });
  });

  group('validateEmail', () {
    test('null jika valid', () {
      expect(Validators.validateEmail('user@example.com'), isNull);
    });

    test('pesan error jika kosong atau format salah', () {
      expect(Validators.validateEmail(''), 'Email tidak boleh kosong');
      expect(Validators.validateEmail('abc'), 'Format email tidak valid');
    });
  });

  // Bonus: validasi dari Latihan 3
  group('validatePhone', () {
    test('menerima 10 sampai 13 digit angka', () {
      expect(Validators.validatePhone('0812345678'), isNull);
      expect(Validators.validatePhone('081234567890'), isNull);
      expect(Validators.validatePhone('0812345678901'), isNull);
    });

    test('menolak kurang dari 10 digit', () {
      expect(
        Validators.validatePhone('081234567'),
        'Nomor telepon harus berupa angka 10-13 digit',
      );
    });

    test('menolak lebih dari 13 digit', () {
      expect(
        Validators.validatePhone('08123456789012'),
        'Nomor telepon harus berupa angka 10-13 digit',
      );
    });

    test('menolak karakter non-angka', () {
      expect(
        Validators.validatePhone('0812abc7890'),
        'Nomor telepon harus berupa angka 10-13 digit',
      );
    });

    test('menolak kosong', () {
      expect(Validators.validatePhone(''), 'Nomor telepon tidak boleh kosong');
    });
  });

  group('validateUrl', () {
    test('menerima http dan https', () {
      expect(Validators.validateUrl('https://amikom.ac.id'), isNull);
      expect(Validators.validateUrl('http://localhost:8080'), isNull);
    });

    test('menolak URL tanpa skema', () {
      expect(
        Validators.validateUrl('amikom.ac.id'),
        'URL harus diawali http:// atau https://',
      );
    });

    test('menolak skema selain http dan https', () {
      expect(
        Validators.validateUrl('ftp://amikom.ac.id'),
        'URL harus diawali http:// atau https://',
      );
    });

    test('menolak kosong', () {
      expect(Validators.validateUrl(null), 'URL tidak boleh kosong');
    });
  });

  group('validatePassword', () {
    test('menerima password yang memenuhi semua syarat', () {
      expect(Validators.validatePassword('Abcdef1!'), isNull);
    });

    test('menolak kosong', () {
      expect(Validators.validatePassword(''), 'Password tidak boleh kosong');
    });

    test('menolak kurang dari 8 karakter', () {
      expect(
        Validators.validatePassword('Ab1!'),
        'Password minimal 8 karakter',
      );
    });

    test('menolak tanpa huruf kapital', () {
      expect(
        Validators.validatePassword('abcdefg1!'),
        'Password harus mengandung huruf kapital',
      );
    });

    test('menolak tanpa angka', () {
      expect(
        Validators.validatePassword('Abcdefgh!'),
        'Password harus mengandung angka',
      );
    });

    test('menolak tanpa simbol', () {
      expect(
        Validators.validatePassword('Abcdefg1'),
        'Password harus mengandung simbol',
      );
    });
  });
}
