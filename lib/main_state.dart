
// add name, age, email, phone number, address, and a button to submit the form
class MainState {
  final int counter;
  final String name;
  final String age;
  final String email;
  final String phoneNumber;
  final String address;

  MainState({
    this.counter = 0,
    this.name = '',
    this.age = '',
    this.email = '',
    this.phoneNumber = '',
    this.address = '',
  });

  MainState copyWith({
    int? counter,
    String? name,
    String? age,
    String? email,
    String? phoneNumber,
    String? address,
  }) {
    return MainState(
      counter: counter ?? this.counter,
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }
}