enum AccountType {
  cash("Carteira"),
  credit("Crédito"),
  checking("Corrente");

  const AccountType(this.display);
  final String display;
}

enum TransactionType {
  buy("Compra"),
  sell("Venda"),
  expense("Despesa"),
  income("Receita"),
  transfer("Transferência");

  const TransactionType(this.display);
  final String display;
}

enum Currency { brl, usd, eur }

enum Sorting { category, date, value, description }

enum TimePeriod {
  day("Dia"),
  week("Semana"),
  month("Mês"),
  year("Ano");

  const TimePeriod(this.display);
  final String display;
}

enum CheckState { checked, partial, blank }
