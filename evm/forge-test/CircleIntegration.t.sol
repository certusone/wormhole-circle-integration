// SPDX-License-Identifier: Apache 2
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IWormhole} from "../src/interfaces/IWormhole.sol";
import {ICircleIntegration} from "../src/interfaces/ICircleIntegration.sol";
import {ICircleBridge} from "../src/interfaces/circle/ICircleBridge.sol";
import {IMessageTransmitter} from "../src/interfaces/circle/IMessageTransmitter.sol";

import {CircleIntegrationSetup} from "../src/circle_integration/CircleIntegrationSetup.sol";
import {CircleIntegrationImplementation} from "../src/circle_integration/CircleIntegrationImplementation.sol";
import {CircleIntegrationProxy} from "../src/circle_integration/CircleIntegrationProxy.sol";

interface IUSDC {
    function balanceOf(address account) external view returns (uint256);
    function mint(address to, uint256 amount) external;
    function configureMinter(address minter, uint256 minterAllowedAmount) external;
    function masterMinter() external view returns (address);
}

contract CircleIntegrationTest is Test {
    // USDC
    IUSDC usdc;

    // dependencies
    IWormhole wormhole;
    ICircleBridge circleBridge;
    IMessageTransmitter messageTransmitter;

    // USDC Mint/Burn contracts
    CircleIntegrationSetup setup;
    CircleIntegrationImplementation implementation;
    CircleIntegrationProxy proxy;
    ICircleIntegration circleIntegration;

    function mintUSDC() public {
        // spoof .configureMinter() call with the master minter account
        vm.prank(usdc.masterMinter());

        // allow this test contract to mint USDC
        usdc.configureMinter(address(this), type(uint256).max);

        // mint $1000 USDC to the test contract (or an external user)
        usdc.mint(address(this), 1000e6);
    }

    function makeDependencies() public {
        usdc = IUSDC(vm.envAddress("TESTING_USDC_TOKEN_ADDRESS"));
        wormhole = IWormhole(vm.envAddress("TESTING_WORMHOLE_ADDRESS"));
        circleBridge = ICircleBridge(vm.envAddress("TESTING_CIRCLE_BRIDGE_ADDRESS"));
        messageTransmitter = IMessageTransmitter(vm.envAddress("TESTING_MESSAGE_TRANSMITTER_ADDRESS"));
    }

    function setUp() public {
        // dependencies
        makeDependencies();

        // mint USDC to this test contract
        mintUSDC();

        // next Implementation
        implementation = new CircleIntegrationImplementation();

        // first Setup
        setup = new CircleIntegrationSetup();

        // setup Proxy using Implementation
        proxy = new CircleIntegrationProxy(
            address(setup),
            abi.encodeWithSelector(
                bytes4(keccak256("setup(address,uint16,address,uint8,address,address)")),
                address(implementation),
                wormhole.chainId(),
                address(wormhole),
                uint8(1), // finality
                address(circleBridge),
                address(messageTransmitter)
            )
        );

        circleIntegration = ICircleIntegration(address(proxy));
    }

    function testBalance() public {
        // verify the test contract has $1000 USDC
        uint256 balance = usdc.balanceOf(address(this));
        assertEq(balance, 1000e6);
    }
}
