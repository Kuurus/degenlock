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
exports.handleTransfer = void 0;
const utils_1 = require("./utils/utils");
const token_1 = require("./utils/token");
const agrTransactions_1 = require("./utils/agrTransactions");
function handleTransfer({ block, tx, rawEvent, mysql }) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!rawEvent)
            return;
        if (rawEvent.data[1] ===
            '0x1176a1bd84444c89232ec27754698e5d2e7e1a7f1539f12027f28b23ec9f3d8'.toLowerCase())
            return;
        if (rawEvent.data[0] === '0x0'.toLowerCase() || rawEvent.data[1] === '0x0'.toLowerCase())
            return;
        console.log('Transfer event found:', rawEvent);
        const format = 'from, to, value(uint256)';
        const data = (0, utils_1.getEvent)(rawEvent.data, format);
        let token;
        // aggregatedTx from the account that sent the tokens
        let aggregatedTxFrom;
        // aggregatedTx from the account that recieved the tokens
        let aggregatedTxTo;
        // If token isn't indexed yet we add it, else we load it
        if (yield (0, token_1.newToken)(rawEvent.from_address, mysql)) {
            token = yield (0, token_1.createToken)(rawEvent.from_address);
            yield mysql.queryAsync(`INSERT IGNORE INTO tokens SET ?`, [token]);
        }
        else {
            token = yield (0, token_1.loadToken)(rawEvent.from_address, mysql);
        }
        const agrFromId = `${data.from.slice(2)}-${data.to.slice(2)}`;
        const agrToId = `${data.to.slice(2)}-${data.from.slice(2)}`;
        if (yield (0, agrTransactions_1.newAggreg)(agrFromId, agrToId, mysql)) {
            aggregatedTxFrom = yield (0, agrTransactions_1.createAggregated)(agrFromId, token, data.from, data.to, block);
            yield mysql.queryAsync(`INSERT IGNORE INTO aggregatedtransactions SET ?`, [aggregatedTxFrom]);
        }
        else {
            aggregatedTxFrom = yield (0, agrTransactions_1.loadAggregated)(agrFromId, agrToId, mysql);
        }
        aggregatedTxFrom.rawValue =
            aggregatedTxFrom.id === agrFromId
                ? BigInt(aggregatedTxFrom.rawValue) - BigInt(data.value)
                : BigInt(aggregatedTxFrom.rawValue) + BigInt(data.value);
        // Updating raw balances
        aggregatedTxFrom.value =
            aggregatedTxFrom.id === agrFromId
                ? aggregatedTxFrom.value - (0, utils_1.convertToDecimal)(data.value, token.decimals)
                : aggregatedTxFrom.value + (0, utils_1.convertToDecimal)(data.value, token.decimals);
        // Updating balances
        aggregatedTxFrom.rawAbsVolume += BigInt(data.value);
        aggregatedTxFrom.absVolume += (0, utils_1.convertToDecimal)(data.value, token.decimals);
        // Updating modified field
        aggregatedTxFrom.modified = block.timestamp;
        yield mysql.queryAsync(`UPDATE aggregatedtransactions SET rawValue=?, value=?, rawAbsVolume=?, absVolume=?, token=?, modified=? WHERE id=?`, [
            aggregatedTxFrom.rawValue.toString(),
            aggregatedTxFrom.value,
            aggregatedTxFrom.rawAbsVolume.toString(),
            aggregatedTxFrom.absVolume,
            aggregatedTxFrom.token,
            aggregatedTxFrom.modified,
            aggregatedTxFrom.id
        ]);
    });
}
exports.handleTransfer = handleTransfer;
