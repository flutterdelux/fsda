enum SequenceCode {
  m('M'),
  mp('Mp'),
  mr('Mr'),
  mrp('Mrp'),
  r('R'),
  rp('Rp'),
  rpag('Rpag'),
  rs('Rs'),
  rsp('Rsp'),
  rc('Rc'),
  rloc('Rloc');

  final String code;

  const SequenceCode(this.code);

  factory SequenceCode.fromValue(String? code) {
    return values.firstWhere(
      (e) => e.code == code,
      orElse: () => throw ArgumentError('Invalid sequence code: $code'),
    );
  }

  bool get isMutation => code.startsWith('M');
  bool get isRetrieval => code.startsWith('R');
}
