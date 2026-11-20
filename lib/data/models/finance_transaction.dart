class FinanceTransaction {
  final String title;
  final String subtitle;
  final String amountText;
  final bool isIncome;
  final String iconKey;

  const FinanceTransaction({
    required this.title,
    required this.subtitle,
    required this.amountText,
    required this.isIncome,
    required this.iconKey,
  });
}

const homeTransactions = [
  FinanceTransaction(
    title: 'Upwork',
    subtitle: 'Өнөөдөр',
    amountText: '+ \$ 850.00',
    isIncome: true,
    iconKey: 'upwork',
  ),
  FinanceTransaction(
    title: 'Шилжүүлэг',
    subtitle: 'Өчигдөр',
    amountText: '- \$ 85.00',
    isIncome: false,
    iconKey: 'avatar',
  ),
  FinanceTransaction(
    title: 'Paypal',
    subtitle: 'Jan 30, 2022',
    amountText: '+ \$ 1,406.00',
    isIncome: true,
    iconKey: 'paypal',
  ),
  FinanceTransaction(
    title: 'Youtube',
    subtitle: 'Jan 16, 2022',
    amountText: '- \$ 11.99',
    isIncome: false,
    iconKey: 'youtube',
  ),
];

// Wallet — 1-р таб ("Гүйлгээнүүд")
const walletTransactions = [
  FinanceTransaction(
    title: 'Upwork',
    subtitle: 'Today',
    amountText: '+ \$ 850.00',
    isIncome: true,
    iconKey: 'upwork',
  ),
  FinanceTransaction(
    title: 'Transfer',
    subtitle: 'Yesterday',
    amountText: '- \$ 85.00',
    isIncome: false,
    iconKey: 'avatar',
  ),
  FinanceTransaction(
    title: 'Paypal',
    subtitle: 'Jan 30, 2022',
    amountText: '+ \$ 1,406.00',
    isIncome: true,
    iconKey: 'paypal',
  ),
  FinanceTransaction(
    title: 'Youtube',
    subtitle: 'Jan 16, 2022',
    amountText: '- \$ 11.99',
    isIncome: false,
    iconKey: 'youtube',
  ),
];

// Wallet — 2-р таб ("Хүлээгдэж буй гүйлгээ")
const pendingTransactions = [
  FinanceTransaction(
    title: 'Youtube',
    subtitle: 'Feb 28, 2022',
    amountText: '- \$ 11.99',
    isIncome: false,
    iconKey: 'youtube',
  ),
  FinanceTransaction(
    title: 'Electricity',
    subtitle: 'Mar 28, 2022',
    amountText: '- \$ 64.00',
    isIncome: false,
    iconKey: 'electricity',
  ),
  FinanceTransaction(
    title: 'House Rent',
    subtitle: 'Mar 31, 2022',
    amountText: '- \$ 450.00',
    isIncome: false,
    iconKey: 'house',
  ),
  FinanceTransaction(
    title: 'Spotify',
    subtitle: 'Feb 28, 2022',
    amountText: '- \$ 9.99',
    isIncome: false,
    iconKey: 'spotify',
  ),
];
