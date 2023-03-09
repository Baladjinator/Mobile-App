bool isValidEmail(String email) {
  const String regex =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

  return RegExp(regex).hasMatch(email);
}

bool isvalidPassword(String password) {
  return password.length >= 8;
}
