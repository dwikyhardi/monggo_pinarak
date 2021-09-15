enum UserEnum {
  Admin,
  Waitress,
  Cashier,
  Owner,
  User,
}

final Map<UserEnum, String> getStringUserEnum = {
  UserEnum.Admin: 'Admin',
  UserEnum.Waitress: 'Waitress',
  UserEnum.Cashier: 'Cashier',
  UserEnum.Owner: 'Owner',
  UserEnum.User: 'User',
};

final Map<String, UserEnum> getUserEnum = {
  'Admin': UserEnum.Admin,
  'Waitress': UserEnum.Waitress,
  'Cashier': UserEnum.Cashier,
  'Owner': UserEnum.Owner,
  'User': UserEnum.User,
};

enum Pref {
  USER,
}
