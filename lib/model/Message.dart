part of global;

class SingleMessage {
  String owner;
  String content;
  int timeStamp;
  SingleMessage(this.owner, this.content, this.timeStamp);

  SingleMessage.fromJson(Map json) {
    owner = json['owner'];
    content = json['content'];
    timeStamp = json['timeStamp'];
  }
}

class SingleMesCollection {
  String bothOwner;
  List<SingleMessage> message = [];
  int user1flag = 0;
  int user2flag = 0;

  //  空白构造函数
  SingleMesCollection();

  //  根据参数构造函数
  SingleMesCollection.fromMes(String sender, String receiver, String content) {
    bothOwner = sender.compareTo(receiver) > 0 ? receiver + '@' + sender : sender + '@' + receiver;
    user1flag = isFirst(bothOwner, sender) ? 1 : 0;
    user2flag = isFirst(bothOwner, sender) ? 0 : 1;
    message = [new SingleMessage(sender, content, new DateTime.now().millisecondsSinceEpoch)];
  }

  //  根据json的构造函数
  SingleMesCollection.fromJson(Map json) {
    bothOwner = json['bothOwner'];
    message = json['message'].map<SingleMessage>((item) {
      return SingleMessage.fromJson(item);
    }).toList();
    user1flag = json['user1_flag'];
    user2flag = json['user2_flag'];
  }

  //  根据身份更新消息计数(同步本地)
  void rankMark(String identity, String athor) {
    if (identity == 'sender') {
      if (isFirst(bothOwner, athor)) {
        user1flag += 1;
      } else {
        user2flag += 1;
      }
    } else {
      int updateNum = max(user1flag, user1flag) + 1;
      if (isFirst(bothOwner, athor)) {
        user1flag = updateNum;
      } else {
        user2flag = updateNum;
      }
    }
  }
  //  本地计数统一并通知远端同步
  void updateMesRank(IO.Socket mysocket, String user) {
    mysocket.emit('updateMessRank', [user, bothOwner.replaceAll(user, '').replaceAll('@', '')]);
    if (isFirst(bothOwner, user)) {
      user1flag = user2flag;
    } else {
      user2flag = user1flag;
    }
  }

  int flagDiff(owner) {
    return (isFirst(bothOwner, owner) ? -1 : 1) * (user1flag - user2flag);
  }
}

class MessageNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class Message extends MessageNotifier {
  Message();
  List<SingleMesCollection> messageArray;
  void assignFromJson(List json) {
    messageArray = json.map((item) {
      return SingleMesCollection.fromJson(item);
    }).toList();
  }

  Message.fromJson(List json) {
    messageArray = json.map<SingleMesCollection>((item) {
      return SingleMesCollection.fromJson(item);
    }).toList();
  }
  //  获得最后一条信息
  String getLastMessage(String name) {
    return messageArray.firstWhere((item) => (item.bothOwner.contains(name)), orElse: () => new SingleMesCollection()).message.last.content;
  }
  //  获取与某人的聊天记录
  SingleMesCollection getUserMesCollection(String name) {
    return messageArray.firstWhere((item)  {
      return item.bothOwner.contains(name);
      }, orElse: () => new SingleMesCollection());
  }
  //  添加一个新的聊天记录
  void addItemToMesArray(String sender, String receiver, String content) {
    messageArray.add(SingleMesCollection.fromMes(sender, receiver, content));
  }

  void addMessRecord(String sayTo, SingleMessage mes) {
    getUserMesCollection(sayTo).message.add(mes);
    notifyListeners();
  }
}