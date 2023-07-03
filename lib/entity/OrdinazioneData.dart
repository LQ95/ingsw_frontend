class OrdinazioneData {
  final DateTime date;
  final double price;

  OrdinazioneData(this.date, this.price);

  @override
  String toString() {
    return '${date.day}/${date.month}/${date.year}: ${price.toStringAsFixed(2)}€';
  }
}