class IRKitCommand {
  final int id;
  String name;
  String message;
  List<String> wakeWords;

  IRKitCommand(this.id, this.name, this.message, this.wakeWords);

  List<Object> toList() {
    return [this.id, this.name, this.message, ...this.wakeWords];
  }
}
