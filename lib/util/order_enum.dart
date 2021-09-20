enum OrderEnum {
  WaitingPayment,
  WaitingConfirmation,
  Process,
  Finish,
  Cancel,
}

final Map<OrderEnum, String> getStringOrderEnum = {
  OrderEnum.WaitingPayment: 'Waiting Payment',
  OrderEnum.WaitingConfirmation: 'Waiting Confirmation',
  OrderEnum.Process: 'Process',
  OrderEnum.Finish: 'Finish',
  OrderEnum.Cancel: 'Cancel',
};

final Map<String, OrderEnum> getOrderEnum = {
  'Waiting Payment': OrderEnum.WaitingPayment,
  'Waiting Confirmation': OrderEnum.WaitingConfirmation,
  'Process': OrderEnum.Process,
  'Finish': OrderEnum.Finish,
  'Cancel': OrderEnum.Cancel,
};
