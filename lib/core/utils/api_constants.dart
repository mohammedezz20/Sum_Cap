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

class ApiModelConstatnts {
  static const String apiUrl = 'https://sumcap101-uqk5.onrender.com';
  static const String apiKey =
      '------------------Your Api Key-------------------';
  static const String transcribttion = '/api/v1/transcribe';
  static const String summarize = '/api/v1/summarize';
  static const String deepGramBaseUrl = 'https://api.deepgram.com/v1/listen';
  static const String deepGramApiKey =
      '2ce3b2380aa3db2bcab9635d7859449c98ecd464';
  static const String deepGramTranscription = 'transcribe';
}
