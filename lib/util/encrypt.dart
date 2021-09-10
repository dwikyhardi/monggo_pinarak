import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Encrypt {
  final int keySize = 256;
  final String salt = r'cWzFTEf9HAZeQ9zpgZZG';
  final String key = r'asf1t3QqsPySdssEj-sU';
  var iteration = pow(2, 16);

  Uint8List aesCbcEncrypt(
      Uint8List key, Uint8List iv, Uint8List paddedPlaintext) {
    if (![128, 192, 256].contains(key.length * 8)) {
      throw ArgumentError.value(key, 'key', 'invalid key length for AES');
    }
    if (iv.length * 8 != 128) {
      throw ArgumentError.value(iv, 'iv', 'invalid IV length for AES');
    }
    if (paddedPlaintext.length * 8 % 128 != 0) {
      throw ArgumentError.value(
          paddedPlaintext, 'paddedPlaintext', 'invalid length for AES');
    }

    // Create a CBC block cipher with AES, and initialize with key and IV

    final cbc = BlockCipher('AES/CBC')
      ..init(true, ParametersWithIV(KeyParameter(key), iv)); // true=encrypt

    // Encrypt the plaintext block-by-block

    final cipherText = Uint8List(paddedPlaintext.length); // allocate space

    var offset = 0;
    while (offset < paddedPlaintext.length) {
      offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
    }
    assert(offset == paddedPlaintext.length);

    return cipherText;
  }

//----------------------------------------------------------------

  Uint8List aesCbcDecrypt(Uint8List key, Uint8List iv, Uint8List cipherText) {
    if (![128, 192, 256].contains(key.length * 8)) {
      throw ArgumentError.value(key, 'key', 'invalid key length for AES');
    }
    if (iv.length * 8 != 128) {
      throw ArgumentError.value(iv, 'iv', 'invalid IV length for AES');
    }
    if (cipherText.length * 8 % 128 != 0) {
      throw ArgumentError.value(
          cipherText, 'cipherText', 'invalid length for AES');
    }

    final cbc = BlockCipher('AES/CBC')
      ..init(false, ParametersWithIV(KeyParameter(key), iv)); // false=decrypt

    final paddedPlainText = Uint8List(cipherText.length); // allocate space

    var offset = 0;
    while (offset < cipherText.length) {
      offset += cbc.processBlock(cipherText, offset, paddedPlainText, offset);
    }
    assert(offset == cipherText.length);

    return paddedPlainText;
  }

//----------------------------------------------------------------
  /// Added padding
  Uint8List pad(Uint8List bytes, int blockSize) {
    final padLength = blockSize - (bytes.length % blockSize);

    final padded = Uint8List(bytes.length + padLength)..setAll(0, bytes);
    Padding('PKCS7').addPadding(padded, bytes.length);

    return padded;
  }

//----------------------------------------------------------------
  /// Remove padding
  Uint8List unpad(Uint8List padded) =>
      padded.sublist(0, padded.length - Padding('PKCS7').padCount(padded));

//----------------------------------------------------------------
  /// Derive a key from a passphrase.
  ///
  /// The [passPhrase] is an arbitrary length secret string.
  ///
  /// The [bitLength] is the length of key produced. It determines whether
  /// AES-128, AES-192, or AES-256 will be used. It must be one of those values.
  Uint8List passphraseToKey(String passPhrase,
      {String salt = '', int iterations = 30000, int bitLength = 0}) {
    if (![128, 192, 256].contains(bitLength)) {
      throw ArgumentError.value(bitLength, 'bitLength', 'invalid for AES');
    }
    final numBytes = bitLength ~/ 8;

    // final kd = KeyDerivator('SHA-256/HMAC/PBKDF2')
    final kd = KeyDerivator('SHA-1/HMAC/PBKDF2')
      ..init(Pbkdf2Parameters(
          utf8.encode(salt) as Uint8List, iterations, numBytes));

    return kd.process(utf8.encode(passPhrase) as Uint8List);
  }

  String encrypt(String input, Uint8List passKey) {
    // print("Encrypt ${jsonDecode(input)}");
    var param;
    var initialVector = DateTime.now().millisecondsSinceEpoch * 1000;
    var iv = utf8.encode(initialVector.toString()) as Uint8List;
    var dataSource = pad(utf8.encode(input) as Uint8List, 16);
    var data = aesCbcEncrypt(passKey, iv, dataSource);
    param = base64.encode(data) + "--" + base64.encode(iv);
    return param;
  }

  Uint8List getPassKey() {
    return passphraseToKey(key,
        iterations: iteration as int,
        salt: salt,
        bitLength: keySize);
  }

  Future setPassKey() async {
    var pref = await SharedPreferences.getInstance();
    var passKey = getPassKey();
    await pref.setString('passkey', base64.encode(passKey));
  }

  Future<Uint8List> getPassKeyPref() async {
    var pref = await SharedPreferences.getInstance();
    var passKey = pref.getString('passkey');
    if (passKey == null) {
      await setPassKey().then((value) {
        passKey = pref.getString('passkey');
      });
    }
    return base64.decode(passKey ?? '');
  }

  String decrypt(String input, Uint8List passKey) {
    var result;
    var inputData = input.split("--");
    var iv = base64.decode(inputData[1]);
    var dataSource = base64.decode(inputData[0]);
    var data = aesCbcDecrypt(passKey, iv, dataSource);
    var decryptedBytes = unpad(data);
    result = utf8.decode(decryptedBytes);
    return result;
  }
}
