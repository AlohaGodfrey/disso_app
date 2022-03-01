//builds the database custom url location
Uri firebaseUrl(String authToken, String uriTarget, [String? uriFilter]) {
  String dbUrl;
  const dbHost =
      'https://disso-7229a-default-rtdb.europe-west1.firebasedatabase.app';

  if (uriFilter == null) {
    dbUrl = '?auth=' + authToken;
  } else {
    dbUrl = '?auth=' + authToken + uriFilter;
  }

  dbUrl = dbHost + uriTarget + dbUrl;
  Uri url = Uri.parse(dbUrl);

  return url;
}
