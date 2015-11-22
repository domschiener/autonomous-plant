contract DailyPay {
  //The contract pays daily a certain amount of money to the owner
  struct Caretaker {
    string twitter;
    address payee;
    address plant;
    uint amount;
  }

  struct Payments {
    mapping(uint => uint) electricity;
    mapping(uint => uint) internet;
    uint electricityprice;
    uint internetprice;
  }

  Payments paym;
  Caretaker beneficiary;
  uint8 dailyUse;
  modifier onlyowner { if (msg.sender == beneficiary.plant) _ }

  function DailyPay(string _twitter, address _payee, uint _electricityprice, uint _internetprice) {
    beneficiary.twitter = _twitter;
    beneficiary.payee = _payee;
    beneficiary.plant = msg.sender;
    beneficiary.amount = msg.value;
    paym.electricityprice = _electricityprice;
    paym.internetprice = _internetprice;
    dailyUse = 0;
  }

  function hourlyUse() onlyowner {
    dailyUse += 1;

    if (dailyUse >= 12) {
      makePayment();
    }
  }

  function audit() {
    if (dailyUse >= 12) {
      makePayment();
    }
  }

  function makePayment() private {
    uint payment = dailyUse * paym.electricityprice + dailyUse * paym.internetprice;
    beneficiary.payee.send(payment);
    dailyUse = 0;
    beneficiary.amount -= payment;
  }

  function changePrices(uint _internetprice, uint _electricityprice) onlyowner {
    paym.electricityprice = _electricityprice;
    paym.internetprice = _internetprice;
  }
}
