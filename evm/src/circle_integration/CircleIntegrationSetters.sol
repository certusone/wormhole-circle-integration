// SPDX-License-Identifier: Apache 2
pragma solidity ^0.8.13;

import "./CircleIntegrationState.sol";

contract CircleIntegrationSetters is CircleIntegrationState {
    function setOwner(address owner_) internal {
        _state.owner = owner_;
    }

    function setPendingOwner(address pendingOwner_) internal {
        _state.pendingOwner = pendingOwner_;
    }

    function setInitialized(address implementatiom) internal {
        _state.initializedImplementations[implementatiom] = true;
    }

    function setWormhole(address wormhole_) internal {
        _state.wormhole = payable(wormhole_);
    }

    function setChainId(uint16 chainId_) internal {
        _state.chainId = chainId_;
    }

    function setWormholeFinality(uint8 finality) internal {
        _state.wormholeFinality = finality;
    }

    function setCircleBridge(address circleBridgeAddress_) internal {
        _state.circleBridgeAddress = circleBridgeAddress_;
    }

    function setCircleTransmitter(address circleTransmitterAddress_) internal {
        _state.circleTransmitterAddress = circleTransmitterAddress_;
    }

    function setEmitter(uint16 chainId_, bytes32 emitter) internal {
        _state.registeredEmitters[chainId_] = emitter;
    }

    function addAcceptedToken(address token) internal {
        _state.acceptedTokens[token] = true;
    }

    function addTargetAcceptedToken(address sourceToken, uint16 chainId, address targetToken) internal {
        _state.targetAcceptedTokens[sourceToken][chainId] = targetToken;
    }

    function setChainIdToDomain(uint16 chainId_, uint32 domain) internal {
        _state.chainIdToDomain[chainId_] = domain;
    }

    function setDomainToChainId(uint32 domain, uint16 chainId_) internal {
        _state.domainToChainId[domain] = chainId_;
    }

    function consumeMessage(bytes32 hash) internal {
        _state.consumedMessages[hash] = true;
    }
}
