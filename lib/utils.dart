Map<Symbol, dynamic> symbolizeKeys(Map<String, dynamic> map) {
  final result = new Map<Symbol, dynamic>();
  map.forEach((String k, v) {
    result[new Symbol(k)] = v;
  });
  return result;
}
