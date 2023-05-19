enum ExperienceCategory {
  all,
  medical,
  proffesional,
  psychological,
  family,
  adminstrative,
  anoun
}

enum Role { user, expert, anoun }

enum Gender { male, female, other, anoun }

class Contributor {
  int id;
  String name;
  DateTime? birthDay = DateTime.now();
  String location;
  String phoneNumber;
  double rate;
  String email;
  String consultingDetail;
  String imageUrl;
  Enum experienceCategory;
  String walletNumber;
  Enum gender;
  Enum role;
  double consultingCost;
  Map<DateTime, List<int>>? availableDates = {};
  List<String>? favorites;

  Contributor({
    this.id = -1,
    required this.name,
    this.birthDay,
    this.location = "Anoun",
    this.phoneNumber = "provide your phone number",
    this.rate = 0.0,
    required this.email,
    this.consultingDetail = "",
    this.imageUrl = "assets/image/profile_picture.png",
    this.experienceCategory = ExperienceCategory.anoun,
    this.gender = Gender.anoun,
    this.role = Role.anoun,
    this.walletNumber = "provide your wallet number",
    this.consultingCost = 0.0,
    this.availableDates,
    this.favorites
  });

  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
        name: json["name"].toString(), email: json["email"].toString());
  }
}
