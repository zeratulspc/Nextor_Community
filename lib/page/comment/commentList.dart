import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

import 'package:Artigo/fnc/user.dart';
import 'package:Artigo/fnc/postDB.dart';
import 'package:Artigo/fnc/comment.dart';
import 'package:Artigo/fnc/emotion.dart';
import 'package:Artigo/page/emotion/emotionList.dart';
import 'package:Artigo/page/emotion/emotionInput.dart';
import 'package:Artigo/page/comment/commentItem.dart';
import 'package:Artigo/page/basicDialogs.dart';

class CommentList extends StatefulWidget {
  final String postKey;
  final String commentKey;
  final String attachKey;
  final User currentUser;
  final VoidCallback getPost;
  final VoidCallback navigateToMyProfile;

  CommentList({this.postKey, this.currentUser, this.attachKey, this.commentKey, this.getPost, this.navigateToMyProfile});
  @override
  CommentListState createState() => CommentListState();
}

class CommentListState extends State<CommentList> {
  CommentDBFNC commentDBFNC;
  EmotionDBFNC likeDBFNC;
  PostDBFNC postDBFNC = PostDBFNC();
  UserDBFNC authDBFNC = UserDBFNC();
  BasicDialogs basicDialogs = BasicDialogs();
  DatabaseReference commentDBRef;
  DatabaseReference likeDBRef;
  
  TextEditingController commentUpdateController = TextEditingController();
  TextEditingController newCommentController = TextEditingController();

  bool isValid = false;
  bool isAttachComment = false;

  Query commentQuery;
  List<Comment> commentList = List();

  @override
  void initState() {
    super.initState();
    if(widget.attachKey == null) {
      if(widget.commentKey == null) { // Post 댓글
        commentDBRef = FirebaseDatabase.instance.reference().child("Posts").child(widget.postKey).child("comment");
        commentDBFNC = CommentDBFNC(commentDBRef: commentDBRef);
        commentQuery = commentDBRef;
      } else { // Post 댓글의 답글
        commentDBRef = FirebaseDatabase.instance.reference().child("Posts").child(widget.postKey).child("comment").child(widget.commentKey).child("reply");
        commentDBFNC = CommentDBFNC(commentDBRef: commentDBRef);
        commentQuery = commentDBRef;
      }
    } else {
      if(widget.commentKey == null) { // attach 댓글
        commentDBRef = FirebaseDatabase.instance.reference().child("Posts").child(widget.postKey).child("attach").child(widget.attachKey).child("comment");
        commentDBFNC = CommentDBFNC(commentDBRef: commentDBRef);
        commentQuery = commentDBRef;
      } else { // attach 댓글의 답글
        commentDBRef = FirebaseDatabase.instance.reference().child("Posts").child(widget.postKey).child("attach").child(widget.attachKey).child("comment").child(widget.commentKey).child("reply");
        commentDBFNC = CommentDBFNC(commentDBRef: commentDBRef);
        commentQuery = commentDBRef;
      }
    }
    newCommentController.addListener((){
      if(newCommentController.text == ""){
        if(this.mounted)
          setState(() {
            isValid = false;
          });
      } else {
        if(this.mounted)
          setState(() {
            isValid = true;
          });
      }
    });
    commentQuery.onChildAdded.listen(_onEntryAdded);
    commentQuery.onChildChanged.listen(_onEntryChanged);
    commentQuery.onChildRemoved.listen(_onEntryRemoved);
  }

  @override
  void dispose() {
    if(widget.getPost != null) {
      widget.getPost();
    }
    super.dispose();
  }

  _onEntryAdded(Event event) async {
    if(this.mounted){
      Comment comment = Comment().fromSnapShot(event.snapshot);
      comment.uploaderInfo = await UserDBFNC().getUserInfo(comment.uploaderUID);
      setState(() {
        commentList.insert(0, comment);
        commentList.sort((a, b){
          DateTime dateA = DateTime.parse(a.uploadDate);
          DateTime dateB = DateTime.parse(b.uploadDate);
          return dateB.compareTo(dateA);
        });
      });
    }
  }

  _onEntryChanged(Event event) async {
    if(this.mounted){
      Comment comment = Comment().fromSnapShot(event.snapshot);
      comment.uploaderInfo = await UserDBFNC().getUserInfo(comment.uploaderUID);
      var oldEntry = commentList.singleWhere((entry) {
        return entry.key == comment.key;
      });
      setState(() {
        commentList[commentList.indexOf(oldEntry)] = comment;
      });
    }
  }

  _onEntryRemoved(Event event) {
    if(this.mounted){
      Comment comment = Comment().fromSnapShot(event.snapshot);
      setState(() {
        commentList.removeWhere((element) =>
        element.key == comment.key,
        );
      });
    }
  }

  void commentMoreOptionSheet(context, Comment comment) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext _context){
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('댓글 수정'),
                    onTap: () {
                      Navigator.pop(context);
                      commentUpdateController.text = comment.body;
                      commentUpdateSheet(context, comment);
                    }
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("댓글 삭제"),
                  subtitle: Text("다시 되돌릴 수 없습니다!"),
                  onTap: () {
                    Navigator.pop(context);
                    basicDialogs.dialogWithFunction(
                        context, "댓글 삭제", "댓글을 삭제하시겠습니까?",
                            () {
                          Navigator.pop(context);
                          basicDialogs.showLoading(context, "댓글을 삭제하는 중입니다.");
                          commentDBFNC.deleteComment(comment.key).then((_) => Navigator.pop(context));
                        });
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  void commentUpdateSheet(context, Comment comment) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext _context){
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 330,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: TextField(
                        controller: commentUpdateController,
                        cursorColor: Theme.of(context).primaryColor,
                        style: TextStyle(
                            fontSize: 18
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "댓글을 수정합니다.",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                ),
                RaisedButton(
                  elevation: 10,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    basicDialogs.showLoading(context, "댓글 수정하는 중");
                    comment.body = commentUpdateController.text;
                    commentDBFNC.updateComment(comment).then((_){
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    child: Center(
                      child: Text("댓글 수정하기", style: TextStyle(color: Colors.white, ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height-50,
      child: Stack(
        children: <Widget>[
          Container(
            height: screenSize.height-105,
            child: ListView.builder(
              itemCount: commentList.length,
              itemBuilder: (context, index) {
                Comment comment = commentList[index];
                return CommentItem(
                  currentUser: widget.currentUser,
                  uploader: comment.uploaderInfo,
                  screenSize: screenSize,
                  seeLikeList: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return EmotionList(
                          postKey: widget.postKey,
                          currentUser: widget.currentUser,
                          commentKey: widget.commentKey != null ? widget.commentKey : comment.key,
                          attachKey: widget.attachKey,
                          replyKey: widget.commentKey != null ? comment.key : null,
                          navigateToMyProfile: widget.navigateToMyProfile,
                        );
                      },
                    );
                  },
                  navigateToMyProfile: widget.navigateToMyProfile,
                  moreOption: (){
                    if(widget.currentUser.uid == comment.uploaderUID)
                      commentMoreOptionSheet(context, comment);
                  },
                  likeToComment: (){
                    DatabaseReference emotionDBRef = commentDBRef.child(comment.key);
                    EmotionInput(emotionDBRef, widget.currentUser.uid, comment.uploaderUID, widget.getPost).showEmotionPicker(context);
                  },
                  dislikeToComment: (){
                    EmotionDBFNC(emotionDBRef: commentDBRef.child(comment.key)).dislike(widget.currentUser.uid);
                  },
                  replyComment: widget.attachKey == null ? widget.commentKey == null ? ()=> showModalBottomSheet( // post 댓글의 답글
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return CommentList(
                        postKey: widget.postKey,
                        commentKey: comment.key,
                        getPost: widget.getPost,
                        currentUser: widget.currentUser,
                        navigateToMyProfile: widget.navigateToMyProfile,
                      );
                    },
                  ) : null : () => showModalBottomSheet( // Attach 댓글의 답글
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return CommentList(
                        postKey: widget.postKey,
                        attachKey: widget.attachKey,
                        commentKey: comment.key,
                        currentUser: widget.currentUser,
                        navigateToMyProfile: widget.navigateToMyProfile,
                      );
                    },
                  ),
                  item: comment,
                );
              },
            ),
          ),
          KeyboardAvoider( // 키보드
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                    color: Colors.grey[800],
                    width: 0.4,
                  ),)
                ),
                padding: EdgeInsets.symmetric(vertical: 5),
                width: screenSize.width,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 150) ,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 10),
                        width: 50,
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo, size: 24,),
                          onPressed: null,
                        ),
                      ),
                      Container(
                          width: screenSize.width - 140,
                          margin: EdgeInsets.only(right: 10),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(),
                            child: TextFormField(
                              maxLines: null,
                              controller: newCommentController,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                    borderSide: BorderSide(color: Colors.transparent)
                                ),
                                fillColor: Colors.grey[300],
                                filled: true,
                                contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 15.0),
                                hintText: "댓글 내용 입력",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                    borderSide: BorderSide(color: Colors.transparent, width: 0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                    borderSide: BorderSide(color: Colors.transparent, width: 0)
                                ),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                    borderSide: BorderSide(color: Colors.transparent, width: 0)
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                    borderSide: BorderSide(color: Colors.red, width: 1)
                                ),
                                errorStyle: TextStyle(height: 0, fontSize: 0,),
                              ),
                            ),
                          )
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.send),
                          color: Theme.of(context).primaryColor,
                          onPressed: isValid ? () {
                            commentDBFNC.createComment(Comment(
                              body: newCommentController.text,
                              uploaderUID: widget.currentUser.uid,
                              uploadDate: DateTime.now().toIso8601String(),
                            )).then((_) => newCommentController.clear());
                          } : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}