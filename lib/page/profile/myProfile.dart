import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:nextor/fnc/auth.dart';

class MyProfile extends StatefulWidget { // 내 프로필 페이지
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  AuthDBFNC authDBFNC = AuthDBFNC();
  FirebaseUser currentUser;
  String userName;
  String description;
  String email;
  String userRole;
  String profileImageURL;

  @override
  void initState() {
    super.initState();
    authDBFNC.getUser().then(
            (data) {
          currentUser = data;
          authDBFNC.getUserInfo(currentUser.uid).then(
                  (data) {
                if(this.mounted) {
                  setState(() {
                    userName = data.userName;
                    description = data.description;
                    userRole = data.role;
                    email = data.email;
                    profileImageURL = data.profileImageURL;
                  });
                }
              }
          );
        }
    );
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.centerLeft,
          end: Alignment(0.3, 0),
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.red,
            Colors.orange,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Container(
                width: 130,
                height: 130,
                color: Colors.grey[300],
              ),
            ),
            profileImageURL != null ? ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.network(
                profileImageURL,
                height: 130.0,
                width: 130.0,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                  if(loadingProgress == null) return child;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Container(
                      width: 130,
                      height: 130,
                      color: Colors.grey[300],
                    ),
                  );
                },
              ),
            ) : ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Container(
                child: Center(
                  child: Text("프로필 사진 없음"),
                ),
                width: 130,
                height: 130,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      userName??"",
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        authDBFNC.roleKr(userRole??""),
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        description??"",
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      child: Divider(thickness: 1,),
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 6.4),
                  _buildProfileImage(),
                  _buildFullName(),
                  _buildStatus(context),
                  _buildBio(context),
                  _buildSeparator(screenSize),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}