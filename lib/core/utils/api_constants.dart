class APIConstants {
  static const String baseUrl = 'https://sumcap101-uqk5.onrender.com/api/v1/';
  //!User Route Endpoints
  static const String login = 'users/login';
  static const String register = 'users/register';
  static const String forgetPassword = 'users/forgotPassword';
  static const String verifyCode = 'users/verifyCode';
  static const String updatePassword = 'users/updatePassword';
  static const String editUser = 'users/';
  static const String deleteUser = 'users/';
  static const String audio = 'users/audios';
  static const String deleteAudio = 'audios/';
  static const String editAudio = 'audios/';
}

class ApiModelConstants {
  static const String apiUrl = 'http://192.168.1.6:8000';
  static const String transcription = '/api/v1/transcribe';
  static const String summarize = '/api/v1/summarize';
}
