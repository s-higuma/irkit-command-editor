class IRKitCommand {
  int id;
  String name;
  String message;
  List<String> wakeWords;

  IRKitCommand(this.id, this.name, this.message, this.wakeWords);

  List<Object> toList() {
    return [this.id, this.name, this.message, ...this.wakeWords];
  }

  Map<String, String> toMap() {
    return {
      'id': this.id.toString(),
      'name': this.name,
      'message': this.message,
      'wakeWords': this.wakeWords.join(','),
    };
  }
}
