"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.loadAccount = exports.createAccount = exports.newAccount = void 0;
function newAccount(accountId, mysql) {
    return __awaiter(this, void 0, void 0, function* () {
        const newAccount = yield loadAccount(accountId, mysql);
        return !newAccount;
    });
}
exports.newAccount = newAccount;
function createAccount(token, accountId, tx, block) {
    return __awaiter(this, void 0, void 0, function* () {
        return {
            id: accountId,
            account: accountId.split('-')[1],
            rawBalance: BigInt(0),
            modified: block.timestamp / 1000,
            tx: tx.transaction_hash
        };
    });
}
exports.createAccount = createAccount;
function loadAccount(accountId, mysql) {
    return __awaiter(this, void 0, void 0, function* () {
        const account = yield mysql.queryAsync(`SELECT * FROM accounttokens WHERE id = ?`, [
            accountId
        ]);
        return account[0];
    });
}
exports.loadAccount = loadAccount;
