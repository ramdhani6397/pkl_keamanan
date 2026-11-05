import 'lib/utils/validators.dart';

void main() {
  print(Validators.validatePhone('081234567890')); // null (valid)
  print(Validators.validatePhone('0812abc')); // pesan error
  print(Validators.validateUrl('https://amikom.ac.id')); // null (valid)
  print(Validators.validateUrl('amikom.ac.id')); // pesan error
  print(Validators.validatePassword('Abcdef1!')); // null (valid)
  print(Validators.validatePassword('abcdefgh')); // harus mengandung kapital
}
