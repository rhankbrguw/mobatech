part of 'chat_provider.dart';

class ChatStreamProcessor {
  bool _isNextDataAnError = false;

  void processLine(
    String line,
    void Function(String chunk) onChunk,
  ) {
    if (line.startsWith('event: error')) {
      _isNextDataAnError = true;
      return;
    }

    if (line.startsWith('data:')) {
      final dataStr = line.substring(5).trim();
      if (dataStr.isEmpty) return;

      if (_isNextDataAnError) {
        _isNextDataAnError = false;
        onChunk("\n\n⚠️ $dataStr");
        return;
      }

      try {
        final parsed = jsonDecode(dataStr);
        if (parsed['text'] != null) {
          onChunk(parsed['text']);
        }
      } catch (e) {
        onChunk(dataStr);
      }
    }
  }
}
