import { BN } from 'bn.js';
import _ from 'lodash';
import * as ProtocolConfig from '../../config/deployments.json';
import web3 from '../web3';

const decimalPlaces = 6;
const decimals = new BN(String(10 ** decimalPlaces));
const ETHDecimals = 1e18;
const MAX_UINT = new BN('115792089237316195423570985008687907853269984665640564039457584007913129639935');
const MAINNET = 'mainnet';
const ROPSTEN = 'ropsten';
const RINKEBY = 'RINKEBY';
const USDC_ADDRESSES = {
  [ROPSTEN]: '0x07865c6e87b9f70255377e024ace6630c1eaa37f',
  [MAINNET]: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
};

async function sendFromUser(unsentTransaction, userAddress) {
  return web3.eth.getGasPrice().then(gasPrice => {
    return unsentTransaction.send({
      from: userAddress,
      gasPrice: new BN(String(gasPrice)),
    });
  });
}

const mapNetworkToID = {
  main: MAINNET,
  ropsten: ROPSTEN,
  private: 'localhost',
  rinkeby: RINKEBY,
};

function transformedConfig() {
  return _.reduce(
    ProtocolConfig,
    (result, item) => {
      _.toArray(item).forEach(networkConfig => {
        return _.merge(result, networkConfig);
      });
      return result;
    },
    {},
  );
}

function fetchDataFromAttributes(web3Obj, attributes) {
  const result = {};
  if (!web3Obj) {
    return Promise.resolve(result);
  }
  var promises = attributes.map(methodInfo => {
    return web3Obj.methods[methodInfo.method](...(methodInfo.args || [])).call();
  });
  return Promise.all(promises)
    .then(results => {
      attributes.forEach((methodInfo, index) => {
        result[methodInfo.name || methodInfo.method] = results[index];
      });
      return result;
    })
    .catch(e => {
      throw new Error(e);
    });
}

export {
  sendFromUser,
  mapNetworkToID,
  transformedConfig,
  fetchDataFromAttributes,
  decimalPlaces,
  decimals,
  ETHDecimals,
  USDC_ADDRESSES,
  MAX_UINT,
};
