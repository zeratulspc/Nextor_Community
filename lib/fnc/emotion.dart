import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'package:Artigo/fnc/notification.dart';
import 'package:Artigo/fnc/user.dart';

class EmotionDBFNC {
  EmotionDBFNC({@required this.emotionDBRef});
  final DatabaseReference emotionDBRef;

  Future like(String userUid, String targetUserUid, String emotionCode) async {
    await emotionDBRef.child("emotion").child(userUid).set(
        Emotion(userUID: userUid, emotionCode: emotionCode,date: DateTime.now().toIso8601String()).toMap());
    if(userUid != targetUserUid) {
      NotificationFCMFnc().sendNotification(
        senderUid: userUid,
        receiverUid: targetUserUid,
        title: "공감 알림",
        body: "님이 공감했습니다.",
      );
    }
  }

  Future dislike(String userUID) async {
    await emotionDBRef.child("emotion").child(userUID).remove();
  }
}

class Emotion {
  String userUID;
  String date;
  String emotionCode;
  String key;
  UserAdditionalInfo uploaderInfo;

  Emotion({this.userUID, this.emotionCode, this.date});

  Emotion.fromSnapshot(DataSnapshot snapshot)
    :key = snapshot.key,
      userUID = snapshot.value["userUID"],
      emotionCode = snapshot.value["emotionCode"],
      date = snapshot.value["date"];

  Emotion.fromLinkedHashMap(LinkedHashMap linkedHashMap)
      :userUID = linkedHashMap["userUID"],
        emotionCode = linkedHashMap["emotionCode"],
        date = linkedHashMap["date"];

  toMap() {
    return {
      "userUID" : userUID,
      "emotionCode": emotionCode,
      "date" : date
    };
  }
}

List<String> emotion =  [
  '👍',
  '❤️',
  '😢',
  '🤣',
  '🤬',
  '🙏',
  '👀',
  '😀',
  '😃',
  '😄',
  '😁',
  '😆',
  '😅',
  '🤣',
  '😂',
  '🙂',
  '🙃',
  '😉',
  '😊',
  '😇',
  '🥰',
  '😍',
  '🤩',
  '😘',
  '😗',
  '☺',
  '😚',
  '😙',
  '😋',
  '😛',
  '😜',
  '🤪',
  '😝',
  '🤑',
  '🤗',
  '🤭',
  '🤫',
  '🤔',
  '🤐',
  '🤨',
  '😐',
  '😑',
  '😶',
  '😏',
  '😒',
  '🙄',
  '😬',
  '🤥',
  '😌',
  '😔',
  '😪',
  '🤤',
  '😴',
  '😷',
  '🤒',
  '🤕',
  '🤢',
  '🤮',
  '🤧',
  '🥵',
  '🥶',
  '🥴',
  '😵',
  '🤯',
  '🤠',
  '🥳',
  '😎',
  '🤓',
  '🧐',
  '😕',
  '😟',
  '🙁',
  '☹\ufe0f',
  '\ud83d\udea3',
  '😯',
  '😲',
  '😳',
  '🥺',
  '😦',
  '😧',
  '😨',
  '😰',
  '😥',
  '😢',
  '😭',
  '😱',
  '😖',
  '😣',
  '😞',
  '😓',
  '😩',
  '😫',
  '😤',
  '😡',
  '😠',
  '🤬',
  '😈',
  '👿',
  '💀',
  '☠',
  '💩',
  '🤡',
  '👹',
  '👺',
  '👻',
  '👽',
  '👾',
  '🤖',
  '😺',
  '😸',
  '😹',
  '😻',
  '😼',
  '😽',
  '🙀',
  '😿',
  '😾',
  '💋',
  '👋',
  '🤚',
  '🖐',
  '✋',
  '🖖',
  '👌',
  '✌',
  '🤞',
  '🤟',
  '🤘',
  '🤙',
  '👈',
  '👉',
  '👆',
  '🖕',
  '👇',
  '☝',
  '👍',
  '👎',
  '✊',
  '👊',
  '🤛',
  '🤜',
  '👏',
  '🙌',
  '👐',
  '🤲',
  '🤝',
  '🙏',
  '✍',
  '💅',
  '🤳',
  '💪',
  '🦵',
  '🦶',
  '👂',
  '👃',
  '🧠',
  '🦷',
  '🦴',
  '👀',
  '👁',
  '👅',
  '👄',
  '👶',
  '🧒',
  '👦',
  '👧',
  '🧑',
  '👨',
  '🧔',
  '👱\u200d♂️',
  '👨\u200d🦰',
  '👨\u200d🦱',
  '👨\u200d🦳',
  '👨\u200d🦲',
  '👩',
  '👱\u200d♀️',
  '👩\u200d🦰',
  '👩\u200d🦱',
  '👩\u200d🦳',
  '👩\u200d🦲',
  '🧓',
  '👴',
  '👵',
  '🙍\u200d♂️',
  '🙍\u200d♀️',
  '🙎\u200d♂️',
  '🙎\u200d♀️',
  '🙅\u200d♂️',
  '🙅\u200d♀️',
  '🙆\u200d♂️',
  '🙆\u200d♀️',
  '💁\u200d♂️',
  '💁\u200d♀️',
  '🙋\u200d♂️',
  '🙋\u200d♀️',
  '🙇\u200d♂️',
  '🙇\u200d♀️',
  '🤦\u200d♂️',
  '🤦\u200d♀️',
  '🤷\u200d♂️',
  '🤷\u200d♀️',
  '👨\u200d⚕️',
  '👩\u200d⚕️',
  '👨\u200d🎓',
  '👩\u200d🎓',
  '👨\u200d🏫',
  '👩\u200d🏫',
  '👨\u200d⚖️',
  '👩\u200d⚖️',
  '👨\u200d🌾',
  '👩\u200d🌾',
  '👨\u200d🍳',
  '👩\u200d🍳',
  '👨\u200d🔧',
  '👩\u200d🔧',
  '👨\u200d🏭',
  '👩\u200d🏭',
  '👨\u200d💼',
  '👩\u200d💼',
  '👨\u200d🔬',
  '👩\u200d🔬',
  '👨\u200d💻',
  '👩\u200d💻',
  '👨\u200d🎤',
  '👩\u200d🎤',
  '👨\u200d🎨',
  '👩\u200d🎨',
  '👨\u200d✈️',
  '👩\u200d✈️',
  '👨\u200d🚀',
  '👩\u200d🚀',
  '👨\u200d🚒',
  '👩\u200d🚒',
  '👮\u200d♂️',
  '👮\u200d♀️',
  '🕵️\u200d♂️',
  '🕵️\u200d♀️',
  '💂\u200d♂️',
  '💂\u200d♀️',
  '👷\u200d♂️',
  '👷\u200d♀️',
  '🤴',
  '👸',
  '👳\u200d♂️',
  '👳\u200d♀️',
  '👲',
  '🧕',
  '🤵',
  '👰',
  '🤰',
  '🤱',
  '👼',
  '🎅',
  '🤶',
  '🦸\u200d♂️',
  '🦸\u200d♀️',
  '🦹\u200d♂️',
  '🦹\u200d♀️',
  '🧙\u200d♂️',
  '🧙\u200d♀️',
  '🧚\u200d♂️',
  '🧚\u200d♀️',
  '🧛\u200d♂️',
  '🧛\u200d♀️',
  '🧜\u200d♂️',
  '🧜\u200d♀️',
  '🧝\u200d♂️',
  '🧝\u200d♀️',
  '🧞\u200d♂️',
  '🧞\u200d♀️',
  '🧟\u200d♂️',
  '🧟\u200d♀️',
  '💆\u200d♂️',
  '💆\u200d♀️',
  '💇\u200d♂️',
  '💇\u200d♀️',
  '🚶\u200d♂️',
  '🚶\u200d♀️',
  '🏃\u200d♂️',
  '🏃\u200d♀️',
  '💃',
  '🕺',
  '🕴',
  '👯\u200d♂️',
  '👯\u200d♀️',
  '🧖\u200d♂️',
  '🧖\u200d♀️',
  '🧘',
  '👭',
  '👫',
  '👬',
  '💏',
  '👨\u200d❤️\u200d💋\u200d👨',
  '👩\u200d❤️\u200d💋\u200d👩',
  '💑',
  '👨\u200d❤️\u200d👨',
  '👩\u200d❤️\u200d👩',
  '👪',
  '👨\u200d👩\u200d👦',
  '👨\u200d👩\u200d👧',
  '👨\u200d👩\u200d👧\u200d👦',
  '👨\u200d👩\u200d👦\u200d👦',
  '👨\u200d👩\u200d👧\u200d👧',
  '👨\u200d👨\u200d👦',
  '👨\u200d👨\u200d👧',
  '👨\u200d👨\u200d👧\u200d👦',
  '👨\u200d👨\u200d👦\u200d👦',
  '👨\u200d👨\u200d👧\u200d👧',
  '👩\u200d👩\u200d👦',
  '👩\u200d👩\u200d👧',
  '👩\u200d👩\u200d👧\u200d👦',
  '👩\u200d👩\u200d👦\u200d👦',
  '👩\u200d👩\u200d👧\u200d👧',
  '👨\u200d👦',
  '👨\u200d👦\u200d👦',
  '👨\u200d👧',
  '👨\u200d👧\u200d👦',
  '👨\u200d👧\u200d👧',
  '👩\u200d👦',
  '👩\u200d👦\u200d👦',
  '👩\u200d👧',
  '👩\u200d👧\u200d👦',
  '👩\u200d👧\u200d👧',
  '🗣',
  '👤',
  '👥',
  '👣',
  '🧳',
  '🌂',
  '☂',
  '🧵',
  '🧶',
  '👓',
  '🕶',
  '🥽',
  '🥼',
  '👔',
  '👕',
  '👖',
  '🧣',
  '🧤',
  '🧥',
  '🧦',
  '👗',
  '👘',
  '👙',
  '👚',
  '👛',
  '👜',
  '👝',
  '🎒',
  '👞',
  '👟',
  '🥾',
  '🥿',
  '👠',
  '👡',
  '👢',
  '👑',
  '👒',
  '🎩',
  '🎓',
  '🧢',
  '⛑',
  '💄',
  '💍',
  '💼',
  '🙈',
  '🙉',
  '🙊',
  '💥',
  '💫',
  '💦',
  '💨',
  '🐵',
  '🐒',
  '🦍',
  '🐶',
  '🐕',
  '🐩',
  '🐺',
  '🦊',
  '🦝',
  '🐱',
  '🐈',
  '🦁',
  '🐯',
  '🐅',
  '🐆',
  '🐴',
  '🐎',
  '🦄',
  '🦓',
  '🐮',
  '🐂',
  '🐃',
  '🐄',
  '🐷',
  '🐖',
  '🐗',
  '🐽',
  '🐏',
  '🐑',
  '🐐',
  '🐪',
  '🐫',
  '🦙',
  '🦒',
  '🐘',
  '🦏',
  '🦛',
  '🐭',
  '🐁',
  '🐀',
  '🐹',
  '🐰',
  '🐇',
  '🐿',
  '🦔',
  '🦇',
  '🐻',
  '🐨',
  '🐼',
  '🦘',
  '🦡',
  '🐾',
  '🦃',
  '🐔',
  '🐓',
  '🐣',
  '🐤',
  '🐥',
  '🐦',
  '🐧',
  '🕊',
  '🦅',
  '🦆',
  '🦢',
  '🦉',
  '🦚',
  '🦜',
  '🐸',
  '🐊',
  '🐢',
  '🦎',
  '🐍',
  '🐲',
  '🐉',
  '🦕',
  '🦖',
  '🐳',
  '🐋',
  '🐬',
  '🐟',
  '🐠',
  '🐡',
  '🦈',
  '🐙',
  '🐚',
  '🐌',
  '🦋',
  '🐛',
  '🐜',
  '🐝',
  '🐞',
  '🦗',
  '🕷',
  '🕸',
  '🦂',
  '🦟',
  '🦠',
  '💐',
  '🌸',
  '💮',
  '🏵',
  '🌹',
  '🥀',
  '🌺',
  '🌻',
  '🌼',
  '🌷',
  '🌱',
  '🌲',
  '🌳',
  '🌴',
  '🌵',
  '🌾',
  '🌿',
  '☘',
  '🍀',
  '🍁',
  '🍂',
  '🍃',
  '🍄',
  '🌰',
  '🦀',
  '🦞',
  '🦐',
  '🦑',
  '🌍',
  '🌎',
  '🌏',
  '🌐',
  '🌑',
  '🌒',
  '🌓',
  '🌔',
  '🌕',
  '🌖',
  '🌗',
  '🌘',
  '🌙',
  '🌚',
  '🌛',
  '🌜',
  '☀',
  '🌝',
  '🌞',
  '⭐',
  '🌟',
  '🌠',
  '☁',
  '⛅',
  '⛈',
  '🌤',
  '🌥',
  '🌦',
  '🌧',
  '🌨',
  '🌩',
  '🌪',
  '🌫',
  '🌬',
  '🌈',
  '☂',
  '☔',
  '⚡',
  '❄',
  '☃',
  '⛄',
  '☄',
  '🔥',
  '💧',
  '🌊',
  '🎄',
  '✨',
  '🎋',
  '🎍',
  '🍇',
  '🍈',
  '🍉',
  '🍊',
  '🍋',
  '🍌',
  '🍍',
  '🥭',
  '🍎',
  '🍏',
  '🍐',
  '🍑',
  '🍒',
  '🍓',
  '🥝',
  '🍅',
  '🥥',
  '🥑',
  '🍆',
  '🥔',
  '🥕',
  '🌽',
  '🌶',
  '🥒',
  '🥬',
  '🥦',
  '🍄',
  '🥜',
  '🌰',
  '🍞',
  '🥐',
  '🥖',
  '🥨',
  '🥯',
  '🥞',
  '🧀',
  '🍖',
  '🍗',
  '🥩',
  '🥓',
  '🍔',
  '🍟',
  '🍕',
  '🌭',
  '🥪',
  '🌮',
  '🌯',
  '🥙',
  '🍳',
  '🥘',
  '🍲',
  '🥣',
  '🥗',
  '🍿',
  '🧂',
  '🥫',
  '🍱',
  '🍘',
  '🍙',
  '🍚',
  '🍛',
  '🍜',
  '🍝',
  '🍠',
  '🍢',
  '🍣',
  '🍤',
  '🍥',
  '🥮',
  '🍡',
  '🥟',
  '🥠',
  '🥡',
  '🍦',
  '🍧',
  '🍨',
  '🍩',
  '🍪',
  '🎂',
  '🍰',
  '🧁',
  '🥧',
  '🍫',
  '🍬',
  '🍭',
  '🍮',
  '🍯',
  '🍼',
  '🥛',
  '☕',
  '🍵',
  '🍶',
  '🍾',
  '🍷',
  '🍸',
  '🍹',
  '🍺',
  '🍻',
  '🥂',
  '🥃',
  '🥤',
  '🥢',
  '🍽',
  '🍴',
  '🥄',
  '🚣',
  '🗾',
  '🏔',
  '⛰',
  '🌋',
  '🗻',
  '🏕',
  '🏖',
  '🏜',
  '🏝',
  '🏞',
  '🏟',
  '🏛',
  '🏗',
  '🏘',
  '🏚',
  '🏠',
  '🏡',
  '🏢',
  '🏣',
  '🏤',
  '🏥',
  '🏦',
  '🏨',
  '🏩',
  '🏪',
  '🏫',
  '🏬',
  '🏭',
  '🏯',
  '🏰',
  '💒',
  '🗼',
  '🗽',
  '⛪',
  '🕌',
  '🕍',
  '⛩',
  '🕋',
  '⛲',
  '⛺',
  '🌁',
  '🌃',
  '🏙',
  '🌄',
  '🌅',
  '🌆',
  '🌇',
  '🌉',
  '🎠',
  '🎡',
  '🎢',
  '🚂',
  '🚃',
  '🚄',
  '🚅',
  '🚆',
  '🚇',
  '🚈',
  '🚉',
  '🚊',
  '🚝',
  '🚞',
  '🚋',
  '🚌',
  '🚍',
  '🚎',
  '🚐',
  '🚑',
  '🚒',
  '🚓',
  '🚔',
  '🚕',
  '🚖',
  '🚗',
  '🚘',
  '🚚',
  '🚛',
  '🚜',
  '🏎',
  '🏍',
  '🛵',
  '🚲',
  '🛴',
  '🚏',
  '🛤',
  '⛽',
  '🚨',
  '🚥',
  '🚦',
  '🚧',
  '⚓',
  '⛵',
  '🚤',
  '🛳',
  '⛴',
  '🛥',
  '🚢',
  '✈',
  '🛩',
  '🛫',
  '🛬',
  '💺',
  '🚁',
  '🚟',
  '🚠',
  '🚡',
  '🛰',
  '🚀',
  '🛸',
  '🌠',
  '🌌',
  '⛱',
  '🎆',
  '🎇',
  '🎑',
  '💴',
  '💵',
  '💶',
  '💷',
  '🗿',
  '🛂',
  '🛃',
  '🛄',
  '🛅',
  '🕴',
  '🧗\u200d♂️',
  '🧗\u200d♀️',
  '🏇',
  '⛷',
  '🏂',
  '🏌️\u200d♂️',
  '🏌️\u200d♀️',
  '🏄\u200d♂️',
  '🏄\u200d♀️',
  '🚣\u200d♂️',
  '🚣\u200d♀️',
  '🏊\u200d♂️',
  '🏊\u200d♀️',
  '⛹️\u200d♂️',
  '⛹️\u200d♀️',
  '🏋️\u200d♂️',
  '🏋️\u200d♀️',
  '🚴\u200d♂️',
  '🚴\u200d♀️',
  '🚵\u200d♂️',
  '🚵\u200d♀️',
  '🤸\u200d♂️',
  '🤸\u200d♀️',
  '🤼\u200d♂️',
  '🤼\u200d♀️',
  '🤽\u200d♂️',
  '🤽\u200d♀️',
  '🤾\u200d♂️',
  '🤾\u200d♀️',
  '🤹\u200d♂️',
  '🤹\u200d♀️',
  '🧘\u200d♂️',
  '🧘\u200d♀️',
  '🎪',
  '🛹',
  '🎗',
  '🎟',
  '🎫',
  '🎖',
  '🏆',
  '🏅',
  '🥇',
  '🥈',
  '🥉',
  '⚽',
  '⚾',
  '🥎',
  '🏀',
  '🏐',
  '🏈',
  '🏉',
  '🎾',
  '🥏',
  '🎳',
  '🏏',
  '🏑',
  '🏒',
  '🥍',
  '🏓',
  '🏸',
  '🥊',
  '🥋',
  '⛳',
  '⛸',
  '🎣',
  '🎽',
  '🎿',
  '🛷',
  '🥌',
  '🎯',
  '🎱',
  '🎮',
  '🎰',
  '🎲',
  '🧩',
  '♟',
  '🎭',
  '🎨',
  '🧵',
  '🧶',
  '🎼',
  '🎤',
  '🎧',
  '🎷',
  '🎸',
  '🎹',
  '🎺',
  '🎻',
  '🥁',
  '🎬',
  '🏹',
  '💌',
  '🕳',
  '💣',
  '🛀',
  '🛌',
  '🔪',
  '🏺',
  '🗺',
  '🧭',
  '🧱',
  '💈',
  '🛢',
  '🛎',
  '🧳',
  '⌛',
  '⏳',
  '⌚',
  '⏰',
  '⏱',
  '⏲',
  '🕰',
  '🌡',
  '⛱',
  '🧨',
  '🎈',
  '🎉',
  '🎊',
  '🎎',
  '🎏',
  '🎐',
  '🧧',
  '🎀',
  '🎁',
  '🔮',
  '🧿',
  '🕹',
  '🧸',
  '🖼',
  '🧵',
  '🧶',
  '🛍',
  '📿',
  '💎',
  '📯',
  '🎙',
  '🎚',
  '🎛',
  '📻',
  '📱',
  '📲',
  '☎',
  '📞',
  '📟',
  '📠',
  '🔋',
  '🔌',
  '💻',
  '🖥',
  '🖨',
  '⌨',
  '🖱',
  '🖲',
  '💽',
  '💾',
  '💿',
  '📀',
  '🧮',
  '🎥',
  '🎞',
  '📽',
  '📺',
  '📷',
  '📸',
  '📹',
  '📼',
  '🔍',
  '🔎',
  '🕯',
  '💡',
  '🔦',
  '🏮',
  '📔',
  '📕',
  '📖',
  '📗',
  '📘',
  '📙',
  '📚',
  '📓',
  '📃',
  '📜',
  '📄',
  '📰',
  '🗞',
  '📑',
  '🔖',
  '🏷',
  '💰',
  '💴',
  '💵',
  '💶',
  '💷',
  '💸',
  '💳',
  '🧾',
  '✉',
  '📧',
  '📨',
  '📩',
  '📤',
  '📥',
  '📦',
  '📫',
  '📪',
  '📬',
  '📭',
  '📮',
  '🗳',
  '✏',
  '✒',
  '🖋',
  '🖊',
  '🖌',
  '🖍',
  '📝',
  '📁',
  '📂',
  '🗂',
  '📅',
  '📆',
  '🗒',
  '🗓',
  '📇',
  '📈',
  '📉',
  '📊',
  '📋',
  '📌',
  '📍',
  '📎',
  '🖇',
  '📏',
  '📐',
  '✂',
  '🗃',
  '🗄',
  '🗑',
  '🔒',
  '🔓',
  '🔏',
  '🔐',
  '🔑',
  '🗝',
  '🔨',
  '⛏',
  '⚒',
  '🛠',
  '🗡',
  '⚔',
  '🔫',
  '🛡',
  '🔧',
  '🔩',
  '⚙',
  '🗜',
  '⚖',
  '🔗',
  '⛓',
  '🧰',
  '🧲',
  '⚗',
  '🧪',
  '🧫',
  '🧬',
  '🔬',
  '🔭',
  '📡',
  '💉',
  '💊',
  '🚪',
  '🛏',
  '🛋',
  '🚽',
  '🚿',
  '🛁',
  '🧴',
  '🧷',
  '🧹',
  '🧺',
  '🧻',
  '🧼',
  '🧽',
  '🧯',
  '🚬',
  '⚰',
  '⚱',
  '🗿',
  '🚰',
  '💘',
  '💝',
  '💖',
  '💗',
  '💓',
  '💞',
  '💕',
  '💟',
  '❣',
  '💔',
  '❤',
  '🧡',
  '💛',
  '💚',
  '💙',
  '💜',
  '🖤',
  '💯',
  '💢',
  '💬',
  '👁️\u200d🗨️',
  '🗯',
  '💭',
  '💤',
  '💮',
  '♨',
  '💈',
  '🛑',
  '🕛',
  '🕧',
  '🕐',
  '🕜',
  '🕑',
  '🕝',
  '🕒',
  '🕞',
  '🕓',
  '🕟',
  '🕔',
  '🕠',
  '🕕',
  '🕡',
  '🕖',
  '🕢',
  '🕗',
  '🕣',
  '🕘',
  '🕤',
  '🕙',
  '🕥',
  '🕚',
  '🕦',
  '🌀',
  '♠',
  '♥',
  '♦',
  '♣',
  '🃏',
  '🀄',
  '🎴',
  '🔇',
  '🔈',
  '🔉',
  '🔊',
  '📢',
  '📣',
  '📯',
  '🔔',
  '🔕',
  '🎵',
  '🎶',
  '🏧',
  '🚮',
  '🚰',
  '♿',
  '🚹',
  '🚺',
  '🚻',
  '🚼',
  '🚾',
  '⚠',
  '🚸',
  '⛔',
  '🚫',
  '🚳',
  '🚭',
  '🚯',
  '🚱',
  '🚷',
  '🔞',
  '☢',
  '☣',
  '⬆',
  '↗',
  '➡',
  '↘',
  '⬇',
  '↙',
  '⬅',
  '↖',
  '↕',
  '↔',
  '↩',
  '↪',
  '⤴',
  '⤵',
  '🔃',
  '🔄',
  '🔙',
  '🔚',
  '🔛',
  '🔜',
  '🔝',
  '🛐',
  '⚛',
  '🕉',
  '✡',
  '☸',
  '☯',
  '✝',
  '☦',
  '☪',
  '☮',
  '🕎',
  '🔯',
  '♈',
  '♉',
  '♊',
  '♋',
  '♌',
  '♍',
  '♎',
  '♏',
  '♐',
  '♑',
  '♒',
  '♓',
  '⛎',
  '🔀',
  '🔁',
  '🔂',
  '▶',
  '⏩',
  '◀',
  '⏪',
  '🔼',
  '⏫',
  '🔽',
  '⏬',
  '⏹',
  '⏏',
  '🎦',
  '🔅',
  '🔆',
  '📶',
  '📳',
  '📴',
  '♾',
  '♻',
  '🔱',
  '📛',
  '🔰',
  '⭕',
  '✅',
  '☑',
  '✔',
  '✖',
  '❌',
  '❎',
  '➕',
  '➖',
  '➗',
  '➰',
  '➿',
  '〽',
  '✳',
  '✴',
  '❇',
  '‼',
  '⁉',
  '❓',
  '❔',
  '❕',
  '❗',
  '©',
  '®',
  '™',
  '#️⃣',
  '0️⃣',
  '1️⃣',
  '2️⃣',
  '3️⃣',
  '4️⃣',
  '5️⃣',
  '6️⃣',
  '7️⃣',
  '8️⃣',
  '9️⃣',
  '🔟',
  '🔠',
  '🔡',
  '🔢',
  '🔣',
  '🔤',
  '🅰',
  '🆎',
  '🅱',
  '🆑',
  '🆒',
  '🆓',
  'ℹ',
  '🆔',
  'Ⓜ',
  '🆕',
  '🆖',
  '🅾',
  '🆗',
  '🅿',
  '🆘',
  '🆙',
  '🆚',
  '🈁',
  '🈂',
  '🈷',
  '🈶',
  '🈯',
  '🉐',
  '🈹',
  '🈚',
  '🈲',
  '🉑',
  '🈸',
  '🈴',
  '🈳',
  '㊗',
  '㊙',
  '🈺',
  '🈵',
  '🔴',
  '🔵',
  '⚫',
  '⚪',
  '⬛',
  '⬜',
  '◼',
  '◻',
  '◾',
  '◽',
  '▪',
  '▫',
  '🔶',
  '🔷',
  '🔸',
  '🔹',
  '🔺',
  '🔻',
  '💠',
  '🔳',
  '🔲'
];