class OrdinazioneData {
  final DateTime date;
  final double price;
  int? numeroConti;
  double? mediaGiornaliera;

  OrdinazioneData(this.date, this.price, {this.numeroConti, this.mediaGiornaliera});

  @override
  String toString() {
    return 'Giorno: ${date.day}/${date.month}/${date.year}\nIntroiti totali: ${price.toStringAsFixed(2)}€\nnumero conti: $numeroConti\nIncasso medio giornata: $mediaGiornaliera';
  }
}