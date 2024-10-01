import 'package:flutter/material.dart';

class NewRoomChatScreen extends StatelessWidget {
  final List<Message> messages = [
    Message(
      name: 'Amar',
      text: 'Hello Everyone, How are you?',
      time: '2m ago',
      avatar:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
    ),
    Message(
      name: 'John',
      text: 'All Good, What about you?',
      time: '3m ago',
      avatar:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
    ),
    Message(
      name: 'Sara',
      text: 'This topic is really interesting!',
      time: '5m ago',
      avatar:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
    ),
    Message(
      name: 'Michael',
      text: 'I agree with you',
      time: '10m ago',
      avatar:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
    ),
    Message(
      name: 'Emma',
      text: 'Hello Everyone, How are you?',
      time: '12m ago',
      avatar:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
    ),
    Message(
      name: 'Olivia',
      text: 'Hiiii',
      time: '15m ago',
      avatar:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
    ),
    Message(
      name: 'James',
      text: 'Hello Everyone, How are you?',
      time: '20m ago',
      avatar:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?ga=GA1.1.338869508.1708106114&semt=sph',
    ),
  ];

  NewRoomChatScreen({super.key});

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
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatMessageItem(message: messages[index]);
              },
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}

class Message {
  final String name;
  final String text;
  final String time;
  final String avatar;

  Message(
      {required this.name,
      required this.text,
      required this.time,
      required this.avatar});
}

class ChatMessageItem extends StatelessWidget {
  final Message message;

  const ChatMessageItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
                message.avatar), // Replace with actual image assets
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(message.text),
                const SizedBox(height: 5),
                Text(
                  message.time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
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
