"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isErc20 = exports.loadToken = exports.createToken = exports.newToken = void 0;
const starknet = __importStar(require("starknet"));
const utils_1 = require("./utils");
const erc20_json_1 = __importDefault(require("../abis/erc20.json"));
const provider = new starknet.Provider({
    rpc: { nodeUrl: 'https://starknet-goerli.infura.io/v3/3d5e774ac52847fd8cf5c2dd2fc76cf6' }
});
function newToken(tokenAddress, mysql) {
    return __awaiter(this, void 0, void 0, function* () {
        const newToken = yield loadToken(tokenAddress, mysql);
        return !newToken;
    });
}
exports.newToken = newToken;
function createToken(tokenAddress) {
    return __awaiter(this, void 0, void 0, function* () {
        const erc20 = new starknet.Contract(erc20_json_1.default, tokenAddress, provider);
        console.log(yield erc20.name());
        const name = yield erc20.name();
        return {
            name: (0, utils_1.hexToStr)(name.res.toString(16))
        };
    });
}
exports.createToken = createToken;
function loadToken(tokenAddress, mysql) {
    return __awaiter(this, void 0, void 0, function* () {
        const token = yield mysql.queryAsync(`SELECT * FROM tokens WHERE id = ?`, [tokenAddress]);
        return token[0];
    });
}
exports.loadToken = loadToken;
function isErc20(address, block_number) {
    return __awaiter(this, void 0, void 0, function* () {
        const desiredFunctions = [
            'name',
            'decimals',
            'totalSupply',
            'balanceOf',
            'transfer',
            'transferFrom',
            'approve',
            'allowance'
        ];
        const undesiredFunctions = ['tokenURI'];
        const classHash = yield provider.getClassHashAt(address, block_number);
        const contractClass = yield provider.getClassByHash(classHash);
        const hasFunctions = desiredFunctions.every(func => { var _a; return (_a = contractClass.abi) === null || _a === void 0 ? void 0 : _a.find(token => token.name === func && token.type === 'function'); });
        const hasNoFunctions = undesiredFunctions.every(func => { var _a; return !((_a = contractClass.abi) === null || _a === void 0 ? void 0 : _a.find(token => token.name === func && token.type === 'function')); });
        const result = hasFunctions && hasNoFunctions;
        console.log(result, `Smart contract ${result ? 'matches' : "doesn't match"} desired functions`);
        return result;
    });
}
exports.isErc20 = isErc20;
