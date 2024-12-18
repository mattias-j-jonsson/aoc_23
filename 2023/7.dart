import 'dart:io';

enum HandType implements Comparable<HandType> { // utan JJ/med JJ
                // jokers = 2           | jokers = 3   | jokers = 4 | jokers = 5               
    highCard,   // omöjligt             | omöjligt     | omöjligt   | omöjligt       
    pair,       // omöjligt/+2          | omöjligt     | omöjligt   | omöjligt       
    twoPairs,   // omöjligt/+3          | omöjligt     | omöjligt   | omöjligt       
    three,      // omöjligt             | +2           | omöjligt   | omöjligt 
    fullHouse,  // omöjligt/+2          | +2           | omöjligt   | omöjligt 
    four,       // omöjligt             | omöjligt     | +1         | omöjligt
    five;       // omöjligt             | omöjligt     | omöjligt   | +0

  set index(int newIndex) => newIndex; 
  
  @override
  int compareTo(HandType other) => index - other.index;
}

class CamelHand implements Comparable<CamelHand> {

  CamelHand(this.cards, this.bid, {this.joker = false}) {
    fillCardArray();
    determineHand();
    determineRankingSeed();
  }

  bool joker;
  List<int> cardArray = List<int>.filled(15, 0);
  List<int> cardNumbers = <int>[]; // nummer i handen
  final cards; // list<string> med bokstäver
  int bid; // bid
  late HandType type; //par etc
  late int rankingSeed; // oförklarligt

  void fillCardArray() {
    int cardNumber = 0;
    for (var card in cards) {
      if(card == 'A') {
        cardArray[14]++;
        cardNumber = 14;
      } else if (card == 'K') {
        cardArray[13]++;
        cardNumber = 13;
      } else if (card == 'Q') {
        cardArray[12]++;
        cardNumber = 12;
      } else if (card == 'J') {
        cardArray[11]++;
        if(joker)
          cardNumber = 1;
        else
          cardNumber = 11;
      } else if (card == 'T') {
        cardArray[10]++;
        cardNumber = 10;
      } else {
        cardNumber = int.parse(card);
        cardArray[cardNumber]++;
      }
      cardNumbers.add(cardNumber);
    }
  }

  void determineHand() {
    int multiples = 0;
    int indexFirstMulti = 0;
    int indexSecondMulti = 0;
    for (var i = 0; i < cardArray.length; i++) {
      if(cardArray[i] > 1){
        multiples++;
        if (indexFirstMulti > 0) {
          indexSecondMulti = i;
        } else {
          indexFirstMulti = i;
        }
      }
    }
    if(multiples == 0) {
      type = HandType.highCard;
    } else if (multiples == 1) {
        if(cardArray[indexFirstMulti] == 2)
          type = HandType.pair;
        else if (cardArray[indexFirstMulti] == 3)
          type = HandType.three;
        else if (cardArray[indexFirstMulti] == 4)
          type = HandType.four;
        else
          type = HandType.five;
    } else if (multiples == 2) {
        if(cardArray[indexFirstMulti] == 3 || cardArray[indexSecondMulti] == 3)
          type = HandType.fullHouse;
        else
          type = HandType.twoPairs;        
    }

    if(joker && cardArray[11] > 0) {
      int jokers = cardArray[11];
      if(jokers == 1) {
        switch (type) {
          case HandType.highCard:
            type = HandType.pair;
            break;
          case HandType.pair:
            type = HandType.three;
            break;
          case HandType.three:
            type = HandType.four;
            break;
          case HandType.twoPairs:
            type = HandType.fullHouse;
            break;
          case HandType.fullHouse:
            type = HandType.four;
            break;
          case HandType.four:
            type = HandType.five;
          default:
        }
      } else if (jokers == 2) {
        if(type == HandType.pair) {
          type = HandType.three;
        } else if (type == HandType.fullHouse) {
          type = HandType.five;
        }
        else // if(type == HAndType.twopair)
          type = HandType.four;
      } else if (jokers == 3) {
        if(type == HandType.three) {
          type = HandType.four;
        } else if (type == HandType.fullHouse){
          type = HandType.five;
        }
      } else if (jokers == 4) {
        type = HandType.five;
      }
    }
  }

  void determineRankingSeed() {
    // rankingSeed = (type.index+1) * 500000;
    rankingSeed = 0;
    rankingSeed += (14*14*14*14)*cardNumbers[0];
    rankingSeed += (14*14*14)*cardNumbers[1];
    rankingSeed += (14*14)*cardNumbers[2];
    rankingSeed += (14)*cardNumbers[3];
    rankingSeed += cardNumbers[4];
  }

  @override
  int compareTo(CamelHand other){
    if(type == other.type){
      for (var i = 0; i < cardNumbers.length; i++) {
        if(cardNumbers[i] == other.cardNumbers[i])
          continue;
        else
          return cardNumbers[i]-other.cardNumbers[i];
      }
    }
    return type.index - other.type.index;
    // if(type.index == other.type.index)
    //   return rankingSeed - other.rankingSeed;
    // else
    //   return type.index - other.type.index;
  }
}

void main(List<String> args) async {
  var file = File('inputs/7_input');
  List<String> input = await file.readAsLines();
  

  var orderedHands = <CamelHand>[];
  for (var string in input) {
    var cardsAndBid = string.split(' ');
    orderedHands.add(CamelHand(cardsAndBid[0].split(''), int.parse(cardsAndBid[1])));
  }

  orderedHands.sort();
  
  int result = 0;
  for (var i = 0; i < orderedHands.length; i++) {
    result += (i+1)*orderedHands[i].bid;
  }

  print('Result part 1: $result');

  orderedHands.clear();
  for (var string in input) {
    var cardsAndBid = string.split(' ');
    orderedHands.add(CamelHand(cardsAndBid[0].split(''), int.parse(cardsAndBid[1]), joker: true));
  }

  orderedHands.sort();
  
  result = 0;
  for (var i = 0; i < orderedHands.length; i++) {
    result += (i+1)*orderedHands[i].bid;
  }

  print('Result part 2: $result');
}