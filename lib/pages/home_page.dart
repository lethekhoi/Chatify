import 'package:chatify_app/pages/recent_conversations_page.dart';
import 'package:chatify_app/pages/search_page.dart';
import 'package:flutter/material.dart';
import './profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double _deviceHeight;
  double _deviceWidth;
  TabController _tabController;

  _HomePageState() {}

  @override
  void initState() {
   
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Chatify",
            style: TextStyle(fontSize: 15),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          controller: _tabController,
          tabs: choices.map((Choice choice) {
            return Tab(
              icon: Icon(
                choice.icon,
                size: 25,
              ),
            );
          }).toList(),
        ),
      ),
      body: _tabBarPages(),
    );
  }

  Widget _tabBarPages() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        SearchPage(_deviceHeight, _deviceWidth),
        RecentConversationsPage(_deviceHeight, _deviceWidth),
        ProfilePage(_deviceHeight, _deviceWidth),
      ],
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Contacts', icon: Icons.people_outline),
  const Choice(title: 'Chats', icon: Icons.chat_bubble_outline),
  const Choice(title: 'Profile', icon: Icons.person_outline),
];
