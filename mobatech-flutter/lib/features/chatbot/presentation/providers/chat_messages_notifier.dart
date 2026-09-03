part of 'chat_provider.dart';

class ChatMessagesNotifier extends Notifier<List<Map<String, dynamic>>> {
  ChatRepository get _repository => ref.read(chatRepositoryProvider);
  bool isStreaming = false;

  @override
  List<Map<String, dynamic>> build() => [];

  void clearMessages() => state = [];

  Future<void> loadSession(int sessionId) async {
    ref.read(isChatHistoryLoadingProvider.notifier).state = true;
    ref.read(currentSessionIdProvider.notifier).state = sessionId;
    state = [];
    try {
      final messages = await _repository.getSessionMessages(sessionId);
      state = List<Map<String, dynamic>>.from(messages);
    } finally {
      ref.read(isChatHistoryLoadingProvider.notifier).state = false;
    }
  }

  Future<void> deleteSession(int sessionId) async {
    try {
      await _repository.deleteSession(sessionId);
      if (ref.read(currentSessionIdProvider) == sessionId) {
        ref.read(currentSessionIdProvider.notifier).state = null;
        state = [];
      }
      ref.invalidate(chatSessionsProvider);
    } catch (e) {
      // Ignored for now
    }
  }

  Future<void> renameSession(int sessionId, String newTitle) async {
    try {
      await _repository.renameSession(sessionId, newTitle);
      ref.invalidate(chatSessionsProvider);
    } catch (e) {
      // Ignored for now
    }
  }

  Future<void> createNewSessionAndSend(
    String title,
    String message, {
    String? imagePath,
    String? filePath,
  }) async {
    final session = await _repository.createSession(title);
    final sessionId = session['ID'];
    ref.read(currentSessionIdProvider.notifier).state = sessionId;
    ref.invalidate(chatSessionsProvider); // refresh history
    state = [];
    await sendMessage(
      sessionId,
      message,
      imagePath: imagePath,
      filePath: filePath,
    );
  }

  Future<void> sendMessage(
    int sessionId,
    String message, {
    String? imagePath,
    String? filePath,
  }) async {
    if (isStreaming) return;

    _addOptimisticMessage(message, imagePath, filePath);
    isStreaming = true;

    try {
      await _streamResponse(sessionId, message);
    } finally {
      isStreaming = false;
    }
  }

  void _addOptimisticMessage(
    String message,
    String? imagePath,
    String? filePath,
  ) {
    state = [
      ...state,
      {
        'role': 'user',
        'content': message,
        'imagePath': imagePath,
        'filePath': filePath,
      },
      {'role': 'model', 'content': ''},
    ];
  }

  Future<void> _streamResponse(int sessionId, String message) async {
    final response = await _repository.streamResponse(sessionId, message);
    final processor = ChatStreamProcessor();

    final stream = response.data.stream;
    final stringStream = stream
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in stringStream) {
      processor.processLine(line, _appendChunkToLastMessage);
    }
  }

  void _appendChunkToLastMessage(String chunk) {
    if (state.isEmpty) return;
    final messages = List<Map<String, dynamic>>.from(state);
    final lastMessage = Map<String, dynamic>.from(messages.last);

    lastMessage['content'] = lastMessage['content'] + chunk;
    messages[messages.length - 1] = lastMessage;

    state = messages;
  }
}
