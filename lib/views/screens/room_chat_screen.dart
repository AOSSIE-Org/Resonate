import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resonate/models/message.dart';
import 'package:resonate/models/reply_to.dart';

class RoomChatScreen extends StatefulWidget {
  const RoomChatScreen({super.key});

  @override
  State<RoomChatScreen> createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final double itemHight = 80;

  List<Message> messages = [
    Message(
      roomId: "room1",
      messageId: "msg1",
      creatorId: "user123",
      creatorUsername: "john_doe",
      creatorName: "John Doe",
      creatorImgUrl:
          "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      hasValidTag: true,
      index: 0,
      isEdited: false,
      content: "Hello, everyone! Welcome to the chat room.",
      creationDateTime: DateTime.now(),
      replyTo: null,
    ),
    Message(
      roomId: "room1",
      messageId: "msg2",
      creatorId: "user456",
      creatorUsername: "jane_smith",
      creatorName: "Jane Smith",
      creatorImgUrl:
          "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      hasValidTag: false,
      index: 1,
      isEdited: false,
      content: "Thanks, John! Happy to be here 😊",
      creationDateTime: DateTime.now(),
      replyTo: ReplyTo(
        index: 0,
        creatorUsername: "john_doe",
        content: "Hello, everyone! Welcome to the chat room.",
        creatorImgUrl:
            "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      ),
    ),
    Message(
      roomId: "room1",
      messageId: "msg3",
      creatorId: "user789",
      creatorUsername: "mike_jones",
      creatorName: "Mike Jones",
      creatorImgUrl:
          "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      hasValidTag: true,
      index: 2,
      isEdited: true,
      content: "Good morning! Just edited my message to add this line.",
      creationDateTime: DateTime.now(),
      replyTo: null,
    ),
    Message(
      roomId: "room1",
      messageId: "msg4",
      creatorId: "user123",
      creatorUsername: "john_doe",
      creatorName: "John Doe",
      creatorImgUrl:
          "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      hasValidTag: true,
      index: 3,
      isEdited: false,
      content: "Nice to see everyone interacting. 😊",
      creationDateTime: DateTime.now(),
      replyTo: ReplyTo(
        index: 2,
        creatorUsername: "mike_jones",
        content: "Good morning! Just edited my message to add this line.",
        creatorImgUrl:
            "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      ),
    ),
    Message(
      roomId: "room1",
      messageId: "msg5",
      creatorId: "user789",
      creatorUsername: "mike_jones",
      creatorName: "Mike Jones",
      creatorImgUrl:
          "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      hasValidTag: true,
      index: 4,
      isEdited: true,
      content: "Yes, it's a great day!",
      creationDateTime: DateTime.now(),
      replyTo: null,
    ),
    Message(
      roomId: "room1",
      messageId: "msg6",
      creatorId: "user456",
      creatorUsername: "jane_smith",
      creatorName: "Jane Smith",
      creatorImgUrl:
          "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      hasValidTag: false,
      index: 5,
      isEdited: false,
      content: "Totally agree, Mike!",
      creationDateTime: DateTime.now(),
      replyTo: ReplyTo(
        index: 4,
        creatorUsername: "mike_jones",
        content: "Yes, it's a great day!",
        creatorImgUrl:
            "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      ),
    ),
    // Adding more messages for testing scrolling functionality
    Message(
      roomId: "room1",
      messageId: "msg7",
      creatorId: "user123",
      creatorUsername: "john_doe",
      creatorName: "John Doe",
      creatorImgUrl:
          "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      hasValidTag: true,
      index: 6,
      isEdited: false,
      content: "This chat is getting lively!",
      creationDateTime: DateTime.now(),
      replyTo: null,
    ),
    Message(
      roomId: "room1",
      messageId: "msg8",
      creatorId: "user789",
      creatorUsername: "mike_jones",
      creatorName: "Mike Jones",
      creatorImgUrl:
          "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      hasValidTag: true,
      index: 7,
      isEdited: false,
      content: "Totally! Let's keep it up.",
      creationDateTime: DateTime.now(),
      replyTo: ReplyTo(
        index: 6,
        creatorUsername: "john_doe",
        content: "This chat is getting lively!",
        creatorImgUrl:
            "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      ),
    ),
    Message(
      roomId: "room1",
      messageId: "msg8",
      creatorId: "user789",
      creatorUsername: "mike_jones",
      creatorName: "Mike Jones",
      creatorImgUrl:
          "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      hasValidTag: true,
      index: 8,
      isEdited: false,
      content: "Totally! Let's keep it up.",
      creationDateTime: DateTime.now(),
      replyTo: ReplyTo(
        index: 0,
        creatorUsername: "john_doe",
        content: "Hello, everyone! Welcome to the chat room.",
        creatorImgUrl:
            "https://storage.googleapis.com/fc-freepik-pro-rev1-eu-static/ai-styles-landings/cartoon/characters-and-scenes.jpg?h=1280",
      ),
    ),
];

  void scrollToMessage(int index) {
    _scrollController.animateTo(
      index * itemHight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void updateMessage(int index, String newContent) {
    setState(() {
      messages[index].content = newContent;
      messages[index].isEdited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Room Chat'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatMessageItem(
                  message: messages[index],
                  onTapReply: (int replyIndex) => scrollToMessage(replyIndex),
                  onEditMessage: (String newContent) =>
                      updateMessage(index, newContent),
                );
              },
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}

class ChatMessageItem extends StatefulWidget {
  final Message message;
  final void Function(int) onTapReply;
  final void Function(String) onEditMessage;

  const ChatMessageItem({
    Key? key,
    required this.message,
    required this.onTapReply,
    required this.onEditMessage,
  }) : super(key: key);

  @override
  ChatMessageItemState createState() => ChatMessageItemState();
}

class ChatMessageItemState extends State<ChatMessageItem> {
  bool isEditing = false;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.message.content);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void startEditing() {
    setState(() {
      isEditing = true;
    });
    _editingController.selection = TextSelection.fromPosition(
      TextPosition(offset: _editingController.text.length),
    );
  }

  void saveEdit() {
    widget.onEditMessage(_editingController.text);
    setState(() {
      isEditing = false;
    });
  }

  void cancelEdit() {
    setState(() {
      isEditing = false;
    });
    _editingController.text = widget.message.content;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: startEditing,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.message.creatorImgUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.message.creatorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      if (widget.message.replyTo != null)
                        GestureDetector(
                          onTap: () =>
                              widget.onTapReply(widget.message.replyTo!.index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "@${widget.message.replyTo!.creatorUsername}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  widget.message.replyTo!.content,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (isEditing)
                        Focus(
                          onKeyEvent: (node, event) {
                            if (event.logicalKey == LogicalKeyboardKey.escape) {
                              cancelEdit();
                              return KeyEventResult.handled;
                            }
                            return KeyEventResult.ignored;
                          },
                          child: TextField(
                            controller: _editingController,
                            autofocus: true,
                            onSubmitted: (value) => saveEdit(),
                            onTapOutside: (event) => cancelEdit(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: Text(widget.message.content),
                            ),
                            if (widget.message.isEdited)
                              const Text(
                                ' (edited)',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(height: 5),
                      Text(
                        widget.message.creationDateTime.toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Say Something',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
