// Regex para validar o formato do e-mail
bool isValidEmail(String email) {
  final emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
  return emailRegex.hasMatch(email);
}

// Regex para validar o número de telemóvel
bool isValidPhoneNumber(String phoneNumber) {
  final phoneRegex = RegExp(r'^(9[1236][0-9]) ?([0-9]{3}) ?([0-9]{3})$');
  return phoneRegex.hasMatch(phoneNumber);
}
