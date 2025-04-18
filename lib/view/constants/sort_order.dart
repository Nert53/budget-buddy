enum SortOrder {
  oldest(value: 'oldest', name: 'Oldest'),
  newest(value: 'newest', name: 'Newest'),
  alphabetical(value: 'alphabetical', name: 'A-Z'),
  reverseAlphabetical(value: 'reverseAlphabetical', name: 'Z-A'),
  lowest(value: 'lowest', name: 'Lowest'),
  highest(value: 'highest', name: 'Highest');

  const SortOrder({required this.value, required this.name});
  final String value;
  final String name;
}
