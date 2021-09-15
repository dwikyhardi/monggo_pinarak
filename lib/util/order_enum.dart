enum OrderEnum {
  Waiting,
  Process,
  Finish,
}

final Map<OrderEnum, String> getStringOrderEnum = {
  OrderEnum.Waiting: 'Waiting',
  OrderEnum.Process: 'Process',
  OrderEnum.Finish: 'Finish',
};

final Map<String, OrderEnum> getOrderEnum = {
  'Waiting': OrderEnum.Waiting,
  'Process': OrderEnum.Process,
  'Finish': OrderEnum.Finish,
};
