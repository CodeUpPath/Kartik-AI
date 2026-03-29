import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../models.dart';
import '../services/api_service.dart';
import '../state/app_model.dart';
import '../ui.dart';

const List<String> _coachSuggestions = <String>[
  'What should I eat today?',
  'Give me a quick 20 min workout',
  'How can I improve recovery?',
  'Motivate me',
  'Best pre-workout meal',
  'How many calories should I eat?',
];

class CoachTab extends StatefulWidget {
  const CoachTab({super.key});

  @override
  State<CoachTab> createState() => _CoachTabState();
}

class _CoachTabState extends State<CoachTab> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SpeechToText _speechToText = SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();

  StreamSubscription<PlayerState>? _audioStateSubscription;

  int _lastVisibleMessageCount = 0;
  bool _speechReady = false;
  bool _listening = false;
  bool _speaking = false;
  bool _autoSendPending = false;
  String _voiceStatus = 'Tap the mic to speak to your coach.';
  String? _voiceError;

  @override
  void initState() {
    super.initState();
    _audioStateSubscription = _audioPlayer.playerStateStream.listen((
      PlayerState state,
    ) {
      final bool speakingNow =
          state.playing && state.processingState != ProcessingState.completed;
      if (_speaking != speakingNow && mounted) {
        setState(() => _speaking = speakingNow);
      }
      if (state.processingState == ProcessingState.completed) {
        unawaited(_audioPlayer.stop());
      }
    });
  }

  @override
  void dispose() {
    _audioStateSubscription?.cancel();
    _audioPlayer.dispose();
    _speechToText.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final ({List<ChatMessage> coachMessages, bool coachBusy, String coachTip})
    coach = context
        .select<
          AppModel,
          ({List<ChatMessage> coachMessages, bool coachBusy, String coachTip})
        >(
          (AppModel model) => (
            coachMessages: model.coachMessages,
            coachBusy: model.coachBusy,
            coachTip: model.coachTip,
          ),
        );
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final int visibleMessageCount =
        coach.coachMessages.length + (coach.coachBusy ? 1 : 0);

    if (_lastVisibleMessageCount != visibleMessageCount) {
      _lastVisibleMessageCount = visibleMessageCount;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToLatest());
    }

    return AppBackdrop(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: FitnessCard(
                margin: EdgeInsets.zero,
                color: palette.card,
                borderColor: palette.border.withValues(alpha: 0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: palette.primaryLight,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.smart_toy_rounded,
                            color: palette.primary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Kartik AI Coach',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Text or talk for workout, nutrition, and recovery guidance.',
                                style: TextStyle(height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.tonal(
                          onPressed: coach.coachBusy
                              ? null
                              : () =>
                                    context.read<AppModel>().refreshCoachTip(),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(44, 44),
                            padding: EdgeInsets.zero,
                            backgroundColor: palette.primaryLight,
                            foregroundColor: palette.primary,
                          ),
                          child: const Icon(Icons.refresh_rounded, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        StatusPill(
                          label: _listening
                              ? 'Listening'
                              : _speaking
                              ? 'Speaking'
                              : 'Voice ready',
                          icon: _listening
                              ? Icons.mic_rounded
                              : _speaking
                              ? Icons.graphic_eq_rounded
                              : Icons.volume_up_rounded,
                          background: _listening
                              ? palette.danger.withValues(alpha: 0.12)
                              : palette.primaryLight,
                          foreground: _listening
                              ? palette.danger
                              : palette.primary,
                        ),
                        StatusPill(
                          label: coach.coachBusy
                              ? 'Generating reply'
                              : 'Live coach',
                          icon: coach.coachBusy
                              ? Icons.hourglass_bottom_rounded
                              : Icons.bolt_rounded,
                          background: palette.surface,
                          foreground: palette.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    FitnessCard(
                      margin: EdgeInsets.zero,
                      color: palette.surface.withValues(alpha: 0.82),
                      borderColor: palette.border.withValues(alpha: 0.72),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Coach Tip',
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            coach.coachTip,
                            style: TextStyle(
                              color: palette.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _voiceError ?? _voiceStatus,
                            style: TextStyle(
                              color: _voiceError == null
                                  ? palette.textSecondary
                                  : palette.danger,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                children: _coachSuggestions
                    .map(
                      (String suggestion) => ChipButton(
                        label: suggestion,
                        selected: false,
                        onTap: () => _sendText(context, suggestion),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                itemCount:
                    coach.coachMessages.length + (coach.coachBusy ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == coach.coachMessages.length) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: FitnessCard(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _TypingDot(color: palette.primary),
                            const SizedBox(width: 6),
                            _TypingDot(color: palette.textLight),
                            const SizedBox(width: 6),
                            _TypingDot(color: palette.textLight),
                          ],
                        ),
                      ),
                    );
                  }

                  final ChatMessage message = coach.coachMessages[index];
                  final bool isUser = message.role == 'user';
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth > 420 ? 360 : screenWidth * 0.78,
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: FitnessCard(
                        margin: EdgeInsets.zero,
                        color: isUser ? palette.primary : palette.card,
                        borderColor: isUser
                            ? palette.primary
                            : palette.border.withValues(alpha: 0.32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              message.text,
                              style: TextStyle(
                                color: isUser
                                    ? Colors.white
                                    : palette.textPrimary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Text(
                                  message.time,
                                  style: TextStyle(
                                    color: isUser
                                        ? Colors.white.withValues(alpha: 0.72)
                                        : palette.textLight,
                                    fontSize: 11,
                                  ),
                                ),
                                const Spacer(),
                                if (!isUser)
                                  InkWell(
                                    borderRadius: BorderRadius.circular(999),
                                    onTap: _speaking
                                        ? _stopSpeaking
                                        : () => _speakMessage(message.text),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Icon(
                                        _speaking
                                            ? Icons.stop_circle_outlined
                                            : Icons.volume_up_outlined,
                                        color: palette.primary,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: FitnessCard(
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  color: palette.tabBar,
                  radius: 24,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      FilledButton.tonal(
                        onPressed: coach.coachBusy
                            ? null
                            : () => _toggleListening(),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(48, 48),
                          maximumSize: const Size(48, 48),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: _listening
                              ? palette.danger.withValues(alpha: 0.14)
                              : palette.surface,
                          foregroundColor: _listening
                              ? palette.danger
                              : palette.primary,
                        ),
                        child: Icon(
                          _listening
                              ? Icons.mic_off_rounded
                              : Icons.mic_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Ask your coach anything...',
                            fillColor: palette.inputBg,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onSubmitted: (_) => _send(context),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton(
                        onPressed: coach.coachBusy
                            ? null
                            : () => _send(context),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(48, 48),
                          maximumSize: const Size(48, 48),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Icon(Icons.send_rounded, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleListening() async {
    _voiceError = null;
    if (_listening) {
      _autoSendPending = true;
      await _speechToText.stop();
      return;
    }

    _speechReady = await _speechToText.initialize(
      onStatus: _handleSpeechStatus,
      onError: (SpeechRecognitionError error) {
        if (!mounted) return;
        setState(() {
          _listening = false;
          _autoSendPending = false;
          _voiceError = error.errorMsg;
          _voiceStatus = 'Voice capture stopped.';
        });
      },
    );

    if (!_speechReady) {
      setState(() {
        _voiceError = 'Speech recognition is not available on this device.';
      });
      return;
    }

    setState(() {
      _listening = true;
      _autoSendPending = true;
      _voiceStatus = 'Listening...';
    });

    await _speechToText.listen(
      onResult: _handleSpeechResult,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 4),
      listenOptions: SpeechListenOptions(partialResults: true),
    );
  }

  void _handleSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() {
      _controller.text = result.recognizedWords;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _voiceStatus = result.finalResult
          ? 'Voice note captured.'
          : 'Listening...';
    });
  }

  void _handleSpeechStatus(String status) {
    if (!mounted) return;
    final bool listeningNow = status == 'listening';
    if (_listening != listeningNow) {
      setState(() => _listening = listeningNow);
    }
    if (!listeningNow && _autoSendPending) {
      _autoSendPending = false;
      if (_controller.text.trim().isNotEmpty) {
        _send(context);
      }
    }
  }

  Future<void> _speakMessage(String text) async {
    setState(() {
      _voiceError = null;
      _voiceStatus = 'Generating voice reply...';
    });
    try {
      final Uint8List bytes = await context
          .read<AppModel>()
          .api
          .synthesizeSpeech(text);
      await _audioPlayer.setAudioSource(_BytesAudioSource(bytes));
      await _audioPlayer.play();
      if (mounted) {
        setState(() => _voiceStatus = 'Playing coach reply.');
      }
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _voiceError = error.message;
        _voiceStatus = 'Voice playback unavailable.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _voiceError = 'Could not play the coach reply.';
        _voiceStatus = 'Voice playback unavailable.';
      });
    }
  }

  Future<void> _stopSpeaking() async {
    await _audioPlayer.stop();
    if (!mounted) return;
    setState(() => _voiceStatus = 'Voice playback stopped.');
  }

  void _send(BuildContext context) {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    _sendText(context, text);
  }

  void _sendText(BuildContext context, String text) {
    context.read<AppModel>().sendCoachMessage(text);
    if (_listening) {
      _speechToText.stop();
    }
    setState(() {
      _voiceError = null;
      _voiceStatus = 'Coach is thinking...';
    });
  }

  void _scrollToLatest() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }
}

class _TypingDot extends StatelessWidget {
  const _TypingDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ignore: experimental_member_use
class _BytesAudioSource extends StreamAudioSource {
  _BytesAudioSource(this.bytes);

  final Uint8List bytes;

  @override
  // ignore: experimental_member_use
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final int safeStart = start ?? 0;
    final int safeEnd = end ?? bytes.length;
    // ignore: experimental_member_use
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: safeEnd - safeStart,
      offset: safeStart,
      stream: Stream<Uint8List>.value(bytes.sublist(safeStart, safeEnd)),
      contentType: 'audio/mpeg',
    );
  }
}
