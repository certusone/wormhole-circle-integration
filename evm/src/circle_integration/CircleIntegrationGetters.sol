// SPDX-License-Identifier: Apache 2
pragma solidity ^0.8.13;

import {IWormhole} from "wormhole/interfaces/IWormhole.sol";
import {ICircleBridge} from "../interfaces/circle/ICircleBridge.sol";
import {IMessageTransmitter} from "../interfaces/circle/IMessageTransmitter.sol";

import {CircleIntegrationSetters} from "./CircleIntegrationSetters.sol";

contract CircleIntegrationGetters is CircleIntegrationSetters {
    function isInitialized(address impl) public view returns (bool) {
        return _state.initializedImplementations[impl];
    }

    function wormhole() public view returns (IWormhole) {
        return IWormhole(_state.wormhole);
    }

    function chainId() public view returns (uint16) {
        return _state.chainId;
    }

    function wormholeFinality() public view returns (uint8) {
        return _state.wormholeFinality;
    }

    function circleBridge() public view returns (ICircleBridge) {
        return ICircleBridge(_state.circleBridgeAddress);
    }

    function circleTransmitter() public view returns (IMessageTransmitter) {
        return IMessageTransmitter(_state.circleTransmitterAddress);
    }

    function getRegisteredEmitter(uint16 emitterChainId) public view returns (bytes32) {
        return _state.registeredEmitters[emitterChainId];
    }

    function isAcceptedToken(address token) public view returns (bool) {
        return _state.acceptedTokens[token];
    }

    function targetAcceptedToken(address sourceToken, uint16 chainId_) public view returns (bytes32) {
        return _state.targetAcceptedTokens[sourceToken][chainId_];
    }

    function getDomainFromChainId(uint16 chainId_) public view returns (uint32) {
        return _state.chainIdToDomain[chainId_];
    }

    function getChainIdFromDomain(uint32 domain) public view returns (uint16) {
        return _state.domainToChainId[domain];
    }

    function isMessageConsumed(bytes32 hash) public view returns (bool) {
        return _state.consumedMessages[hash];
    }

    function localDomain() public view returns (uint32) {
        return _state.localDomain;
    }

    function governanceChainId() public view returns (uint16) {
        return _state.governanceChainId;
    }

    function governanceContract() public view returns (bytes32) {
        return _state.governanceContract;
    }
}
