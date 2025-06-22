import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

/// Agora 配置
const String agoraAppId = '14e959682c9747919c09ec3ebe4accda';//service 
const String agoraToken = '';         // 测试版无需 Token
const String agoraChannel = 'test_channel';

/// 聊天气泡组件
class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  const ChatBubble({required this.text, this.isMe = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.blueAccent : Colors.grey.shade300;
    final align = isMe ? Alignment.centerRight : Alignment.centerLeft;
    final radius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(color: bg, borderRadius: radius),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

/// ChatPage：文本聊天 + 视频/语音通话，带头像和名字展示
class ChatPage extends StatefulWidget {
  final String name;
  final String imagePath;
  const ChatPage({Key? key, required this.name, required this.imagePath}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() => _messages.add(text));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage(widget.imagePath)),
            const SizedBox(width: 8),
            Text(widget.name, style: const TextStyle(color: Colors.black87)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.black54),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VideoCallPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black54),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VoiceCallPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(top: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[_messages.length - 1 - index];
                return ChatBubble(text: msg, isMe: true);
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// VideoCallPage 与 VoiceCallPage 逻辑保持不变...


/// 视频通话页面
class VideoCallPage extends StatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);
  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late final RtcEngine _engine;
  final List<int> _remoteUids = [];

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: agoraAppId));
    await _engine.enableVideo();
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {},
        onUserJoined:
            (RtcConnection connection, int uid, int elapsed) =>
                setState(() => _remoteUids.add(uid)),
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) =>
                setState(() => _remoteUids.remove(uid)),
      ),
    );
    await _engine.joinChannel(
      token: agoraToken,
      channelId: agoraChannel,
      options: const ChannelMediaOptions(),
      uid: 0,
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Widget _buildLocal() => AgoraVideoView(
    controller: VideoViewController(
      rtcEngine: _engine,
      canvas: const VideoCanvas(uid: 0),
    ),
  );
  Widget _buildRemote(int uid) => AgoraVideoView(
    controller: VideoViewController.remote(
      rtcEngine: _engine,
      canvas: VideoCanvas(uid: uid),
      connection: RtcConnection(channelId: agoraChannel),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Center(
            child:
                _remoteUids.isEmpty
                    ? const Text(
                      'Waiting for user...',
                      style: TextStyle(color: Colors.white),
                    )
                    : _buildRemote(_remoteUids.first),
          ),
          Positioned(
            top: 24,
            left: 24,
            width: 120,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildLocal(),
            ),
          ),
        ],
      ),
    );
  }
}

/// 语音通话页面
class VoiceCallPage extends StatefulWidget {
  const VoiceCallPage({Key? key}) : super(key: key);
  @override
  _VoiceCallPageState createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  late final RtcEngine _engine;
  final List<int> _remoteUids = [];

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: agoraAppId));
    await _engine.enableAudio();
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined:
            (RtcConnection connection, int uid, int elapsed) =>
                setState(() => _remoteUids.add(uid)),
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) =>
                setState(() => _remoteUids.remove(uid)),
      ),
    );
    await _engine.joinChannel(
      token: agoraToken,
      channelId: agoraChannel,
      options: const ChannelMediaOptions(),
      uid: 0,
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1FDF2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _remoteUids.isNotEmpty ? Icons.call : Icons.call_end,
              size: 80,
              color: _remoteUids.isNotEmpty ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              _remoteUids.isNotEmpty ? 'Connected' : 'Waiting...',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
