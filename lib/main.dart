import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(GHFlutterApp());

class GHFlutterApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GHFlutterAppState();
  }
}

class _GHFlutterAppState extends State<GHFlutterApp> {
  var _repos = [];
  var _isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchRepos();
  }

  _fetchRepos() async {
    final url = 'https://api.github.com/users/chetannn/repos';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final reposJson = json.decode(response.body);

      setState(() {
        _isLoading = false;
        _repos = reposJson;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Github Repos App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.green.shade800),
        home: Scaffold(
            appBar: AppBar(
              title: Text('My Github Repos App'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    print('Reloading.....');
                    setState(() {
                      _isLoading = true;
                    });
                    _fetchRepos();
                  },
                ),
              ],
            ),
            body: Center(
                child: _isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      )
                    : ListView.builder(
                        itemCount: _repos != null ? _repos.length : 0,
                        itemBuilder: (BuildContext context, i) {
                          return Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        _repos[i]['name'],
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        backgroundImage: NetworkImage(
                                            _repos[i]['owner']['avatar_url']),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.green,
                              )
                            ],
                          );
                        }))));
  }
}
