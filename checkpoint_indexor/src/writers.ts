import type { CheckpointWriter } from '@snapshot-labs/checkpoint';
import { convertToDecimal, getEvent } from './utils/utils';
import { createToken, loadToken, newToken, Token } from './utils/token';
import { createAccount, newAccount, Account, loadAccount } from './utils/account';

export async function handleTokenDeployed({
  block,
  tx,
  rawEvent,
  mysql
}: Parameters<CheckpointWriter>[0]) {
  if (!rawEvent) return;

  if (rawEvent.data[0] === '0x0'.toLowerCase() || rawEvent.data[1] === '0x0'.toLowerCase()) return;

  console.log('Token deployment found:', rawEvent);

  // If token isn't indexed yet we add it, else we load it
  //if (await newToken(rawEvent.from_address, mysql)) {
  let token = await createToken(rawEvent.data[0]);
  console.log(token);
  await mysql.queryAsync(`INSERT INTO tokens SET ?`, [
    {
      id: rawEvent.data[0],
      owner: rawEvent.data[1],
      tokenName: token.name
    }
  ]);
  return;
  /*} else {
    token = await loadToken(rawEvent.from_address, mysql);
  }*/
}
