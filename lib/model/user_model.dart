class UserSession {
  static String? idToken;
  static bool staySignedIn = false;
  static bool isLoggedIn = false;
  static String? firebaseUid;
  static String? credentialUid;
  static String? accessToken;
}

const String url = "http://localhost:7222/revokeToken";
const String loginUrl = "http://localhost:8000/";
const String clientId = '6c0ab413-ff7a-4f1d-9627-2ca563c575d0';
const String authority =
    'https://login.microsoftonline.com/8b19aa86-8724-4e0b-8200-41ae5e975ef5';
const String tenantId = "8b19aa86-8724-4e0b-8200-41ae5e975ef5";
