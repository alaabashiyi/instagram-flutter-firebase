import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = "Some error occured";

    try {
      String photoUrl =
          await StorageMethods().uploadImageToStroage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Like post
  Future<void> likePost(
    String postId,
    String uid,
    List likes,
  ) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profileImage,
  ) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profileImage': profileImage,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Comment is empty');
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<String> deletePost(String postId) async {
    String res = 'Some error occured';
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'Post deleted!';
    } catch (err) {
      print(err.toString());
    }
    return res;
  }

  Future<String> followUser(String currentUserId, String userId) async {
    String res = 'Some error occured';
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(currentUserId).get();

      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(userId)) {
        await _firestore.collection('users').doc(userId).update({
          'followers': FieldValue.arrayRemove([currentUserId]),
        });

        await _firestore.collection('users').doc(currentUserId).update({
          'following': FieldValue.arrayRemove([userId]),
        });
        res = 'Unfollowed';
      } else {
        await _firestore.collection('users').doc(userId).update({
          'followers': FieldValue.arrayUnion([currentUserId]),
        });

        await _firestore.collection('users').doc(currentUserId).update({
          'following': FieldValue.arrayUnion([userId]),
        });
        res = 'Followed';
      }
    } catch (err) {
      print(err.toString());
    }
    return res;
  }
}
