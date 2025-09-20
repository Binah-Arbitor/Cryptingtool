/// C++ 백엔드와 공유되는 암호화 상수
class CryptoConstants {
  // Algorithms
  static const int algorithmAES = 1;
  static const int algorithmSerpent = 2;
  static const int algorithmTwofish = 3;
  static const int algorithmRC6 = 4;
  static const int algorithmMARS = 5;
  static const int algorithmRC5 = 6;
  static const int algorithmSkipjack = 7;
  static const int algorithmBlowfish = 8;
  static const int algorithmCAST128 = 9;
  static const int algorithmCAST256 = 10;
  static const int algorithmCamellia = 11;
  static const int algorithmChaCha20 = 12;
  static const int algorithmSalsa20 = 13;
  static const int algorithmXSalsa20 = 14;
  static const int algorithmHC128 = 15;
  static const int algorithmHC256 = 16;
  static const int algorithmRabbit = 17;
  static const int algorithmSosemanuk = 18;
  static const int algorithmARIA = 19;
  static const int algorithmSEED = 20;
  static const int algorithmSM4 = 21;
  static const int algorithmGOST28147 = 22;
  static const int algorithmDES3 = 23;
  static const int algorithmIDEA = 24;
  static const int algorithmRC2 = 25;
  static const int algorithmSAFER = 26;
  static const int algorithmSAFERPlus = 27;
  static const int algorithmDES = 28;
  static const int algorithmRC4 = 29;
  static const int algorithmThreefish256 = 30;
  static const int algorithmThreefish512 = 31;
  static const int algorithmThreefish1024 = 32;
  static const int algorithmTEA = 33;
  static const int algorithmXTEA = 34;
  static const int algorithmSHACAL2 = 35;
  static const int algorithmWAKE = 36;
  static const int algorithmSquare = 37;
  static const int algorithmShark = 38;
  static const int algorithmPanama = 39;
  static const int algorithmSEAL = 40;
  static const int algorithmLucifer = 41;
  static const int algorithmSimon = 42;
  static const int algorithmSpeck = 43;

  // Modes
  static const int modeCBC = 1;
  static const int modeGCM = 2;
  static const int modeECB = 3;
  static const int modeCFB = 4;
  static const int modeOFB = 5;
  static const int modeCTR = 6;

  // Operations
  static const int operationEncrypt = 1;
  static const int operationDecrypt = 2;
}
