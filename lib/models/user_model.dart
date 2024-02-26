class User {
  final String? userId, userName, fullName, phone;
  final int? roleId;

  const User(
      {this.roleId, this.userId, this.phone, this.fullName, this.userName});
}
