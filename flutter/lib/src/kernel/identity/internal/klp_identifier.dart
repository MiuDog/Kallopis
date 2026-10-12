/// 中立識別字彙規則；不包含路徑分隔符或空白，也不自動改寫輸入。
bool isKlpIdentifier(String value) =>
    RegExp(r'^[A-Za-z][A-Za-z0-9_.-]*$').hasMatch(value);
