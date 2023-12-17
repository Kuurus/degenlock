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
exports.handleTokenDeployed = void 0;
const token_1 = require("./utils/token");
function handleTokenDeployed({ block, tx, rawEvent, mysql }) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!rawEvent)
            return;
        if (rawEvent.data[0] === '0x0'.toLowerCase() || rawEvent.data[1] === '0x0'.toLowerCase())
            return;
        console.log('Token deployment found:', rawEvent);
        // If token isn't indexed yet we add it, else we load it
        //if (await newToken(rawEvent.from_address, mysql)) {
        let token = yield (0, token_1.createToken)(rawEvent.data[0]);
        console.log(token);
        yield mysql.queryAsync(`INSERT INTO tokens SET ?`, [
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
    });
}
exports.handleTokenDeployed = handleTokenDeployed;
