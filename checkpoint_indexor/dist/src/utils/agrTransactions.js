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
exports.loadAggregated = exports.createAggregated = exports.newAggreg = void 0;
const utils_1 = require("./utils");
function newAggreg(aggregatedId, aggregatedToId, mysql) {
    return __awaiter(this, void 0, void 0, function* () {
        const newAggreg = yield loadAggregated(aggregatedId, aggregatedToId, mysql);
        return !newAggreg;
    });
}
exports.newAggreg = newAggreg;
function createAggregated(aggregatedId, token, account, accountTo, block) {
    return __awaiter(this, void 0, void 0, function* () {
        return {
            id: aggregatedId,
            from: account,
            to: accountTo,
            rawValue: BigInt(0),
            value: (0, utils_1.convertToDecimal)(0, token.decimals),
            rawAbsVolume: BigInt(0),
            absVolume: (0, utils_1.convertToDecimal)(0, token.decimals),
            token: token.id,
            modified: block.timestamp / 1000
        };
    });
}
exports.createAggregated = createAggregated;
function loadAggregated(aggregatedId, aggregatedToId, mysql) {
    return __awaiter(this, void 0, void 0, function* () {
        const tx = yield mysql.queryAsync(`SELECT * FROM aggregatedtransactions WHERE id = ? OR id= ?`, [
            aggregatedId,
            aggregatedToId
        ]);
        // if (tx.length === 0) {
        //   console.error('No Aggregated data found for the provided ID:', aggregatedId);
        // }
        return tx[0];
    });
}
exports.loadAggregated = loadAggregated;
