"use strict";
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var aws_amplify_1 = require("aws-amplify");
var amplify_outputs_json_1 = __importDefault(require("./amplify_outputs.json"));
aws_amplify_1.Amplify.configure(amplify_outputs_json_1.default);
var existingConfig = aws_amplify_1.Amplify.getConfig();
var x = __assign(__assign({}, existingConfig), { API: __assign(__assign({}, existingConfig.API), { REST: amplify_outputs_json_1.default.custom.API }) });
aws_amplify_1.Amplify.configure(__assign(__assign({}, existingConfig), { API: __assign(__assign({}, existingConfig.API), { REST: amplify_outputs_json_1.default.custom.API }) }));
console.log(amplify_outputs_json_1.default);
