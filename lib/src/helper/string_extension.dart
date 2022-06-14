extension StringExtension on String {
  String capitalize() {

    return this.length>0?"${this[0].toUpperCase()}${this.substring(1)}":"";
  }
}

