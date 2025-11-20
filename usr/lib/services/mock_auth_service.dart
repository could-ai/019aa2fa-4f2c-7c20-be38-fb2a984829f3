class MockAuthService {
  // محاكاة عملية تسجيل الدخول
  static Future<bool> login(String email, String password) async {
    // تأخير بسيط لمحاكاة الشبكة
    await Future.delayed(const Duration(seconds: 1));
    
    // التحقق من البيانات (Hardcoded كما هو مطلوب في السكربت)
    if (email == 'admin@sanad.dz' && password == 'password123') {
      return true;
    }
    return false;
  }

  // محاكاة جلب بيانات المستخدم
  static Future<Map<String, dynamic>> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'id': 1,
      'email': 'admin@sanad.dz',
      'role': 'admin',
      'name': 'المدير العام'
    };
  }
}
