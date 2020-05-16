import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

class LikeDBFNC {
  final likeDBRef = FirebaseDatabase.instance.reference().child("Posts");

  Future likeToPost(String postKey, String userUID) async {
    likeDBRef.child(postKey).child("like").child(userUID).set(
      Like(userUID: userUID, isLiked: true, date: DateTime.now().toIso8601String()).toMap());
  }

  Future dislikeToPost(String postKey, String userUID) async {
    likeDBRef.child(postKey).child("like").child(userUID).remove();
  }

  Future likeToAttach(String postKey, String userUID, String key) async {
    likeDBRef.child(postKey).child("attach").child(key).child("like").child(userUID).set(
        Like(userUID: userUID, isLiked: true, date: DateTime.now().toIso8601String()).toMap());
  }

  Future dislikeToAttach(String postKey, String userUID, String key) async {
    likeDBRef.child(postKey).child("attach").child(key).child("like").child(userUID).remove();
  }

  Future likeToComment(String postKey, String userUID, String commentKey) async {
    likeDBRef.child(postKey).child("comment").child(commentKey).child("like").child(userUID).set(
        Like(userUID: userUID, isLiked: true, date: DateTime.now().toIso8601String()).toMap());
  }

  Future dislikeToComment(String postKey, String userUID, String commentKey) async {
    likeDBRef.child(postKey).child("comment").child(commentKey).child("like").child(userUID).remove();
  }

}

class Like {
  String userUID;
  bool isLiked;
  String date;

  Like({this.userUID, this.isLiked, this.date});

  Like.fromSnapshot(DataSnapshot snapshot)
    :userUID = snapshot.value["userUID"],
      isLiked = snapshot.value["isLiked"],
      date = snapshot.value["date"];

  Like.fromLinkedHashMap(LinkedHashMap linkedHashMap)
      :userUID = linkedHashMap["userUID"],
        isLiked = linkedHashMap["isLiked"],
        date = linkedHashMap["date"];

  toMap() {
    return {
      "userUID" : userUID,
      "isLiked" : isLiked,
      "date" : date
    };
  }
}