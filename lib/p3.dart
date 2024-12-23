import 'dd.dart';

class Country {
  final String city;
  final String language;
  final String capital;
  Country(this.city, this.language, this.capital);

  @override
  String toString() {
    return "hii";
  }
}

void main() {
  P x = P(5, 4);
  Country c = Country("dd", "language", "capital");
}
