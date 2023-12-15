"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getEvent = exports.hexToStr = exports.convertToDecimal = exports.toAddress = void 0;
const address_1 = require("@ethersproject/address");
const bignumber_1 = require("@ethersproject/bignumber");
const split_uint256_1 = require("@snapshot-labs/sx/dist/utils/split-uint256");
const toAddress = bn => {
    try {
        return (0, address_1.getAddress)(bignumber_1.BigNumber.from(bn).toHexString());
    }
    catch (e) {
        return bn;
    }
};
exports.toAddress = toAddress;
function convertToDecimal(num, decimals) {
    num /= Math.pow(10, decimals);
    return num;
}
exports.convertToDecimal = convertToDecimal;
function hexToStr(data) {
    const hex = data.toString();
    let str = '';
    for (let i = 0; i < hex.length; i += 2)
        str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
    return str;
}
exports.hexToStr = hexToStr;
function getEvent(data, format) {
    const params = format.split(',').map(param => param.trim());
    const event = {};
    let len = 0;
    let skip = 0;
    params.forEach((param, i) => {
        const name = param.replace('(uint256)', '').replace('(felt)', '').replace('(felt*)', '');
        const next = i + skip;
        if (len > 0) {
            event[name] = data.slice(next, next + len);
            skip += len - 1;
            len = 0;
        }
        else {
            if (param.endsWith('(uint256)')) {
                const uint256 = data.slice(next, next + 2);
                event[name] = new split_uint256_1.SplitUint256(uint256[0], uint256[1]).toUint().toString();
                skip += 1;
            }
            else {
                event[name] = data[next];
            }
        }
        if (param.endsWith('_len'))
            len = parseInt(BigInt(data[next]).toString());
    });
    return event;
}
exports.getEvent = getEvent;
