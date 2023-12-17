import { Token } from './token';
import { convertToDecimal } from './utils';

export type Account = {
  id: string;
  account: string;
  rawBalance: bigint;
  modified: number;
  tx: string;
};

export async function newAccount(accountId: string, mysql): Promise<boolean> {
  const newAccount = await loadAccount(accountId, mysql);

  return !newAccount;
}

export async function createAccount(token: Token, accountId: string, tx, block): Promise<Account> {
  return {
    id: accountId,
    account: accountId.split('-')[1],
    rawBalance: BigInt(0),
    modified: block.timestamp / 1000,
    tx: tx.transaction_hash
  };
}

export async function loadAccount(accountId: string, mysql): Promise<Account> {
  const account: Account = await mysql.queryAsync(`SELECT * FROM accounttokens WHERE id = ?`, [
    accountId
  ]);

  return account[0];
}
