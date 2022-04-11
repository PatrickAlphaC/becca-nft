// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "ds-test/test.sol";
import "../BeccaNFT.sol";
import "./utils/Cheats.sol";

contract BeccaNFTTest is DSTest {
    BeccaNFT public beccaNft;
    Cheats internal constant cheats = Cheats(HEVM_ADDRESS);
    // Her birthday is the 13th... but this is to be safe
    uint256 public constant APRIL_11_2022 = 1649696560;
    uint256 public constant APRIL_14_2023 = 1681505866;
    uint256 public constant APRIL_14_2024 = 1713128266;
    uint256 public april_14_2044;

    function setUp() public {
        cheats.warp(APRIL_11_2022);
        beccaNft = new BeccaNFT();
        april_14_2044 = (beccaNft.SECONDS_IN_YEAR() * 20) + APRIL_14_2024;
    }

    function testImageChangesAfterOneYear() public {
        uint256 startingImageIndex = beccaNft.getImageURIIndex();
        cheats.warp(APRIL_14_2023);
        uint256 firstMovedImageIndex = beccaNft.getImageURIIndex();
        assertTrue(startingImageIndex == 0);
        assertTrue(firstMovedImageIndex == 1);
    }

    function testImageChangesAfterManyYears() public {
        cheats.warp(APRIL_14_2024);
        uint256 nextImageIndex = beccaNft.getImageURIIndex();
        cheats.warp(april_14_2044);
        uint256 lastImageIndex = beccaNft.getImageURIIndex();

        emit log_uint(nextImageIndex);
        emit log_uint(lastImageIndex);
        // emit log_uint((block.timestamp - APRIL_11_2022) % beccaNft.SECONDS_IN_YEAR());
        // emit log_uint((block.timestamp - APRIL_11_2022));
        // emit log_uint(31809306 % beccaNft.SECONDS_IN_YEAR());

        assertTrue(nextImageIndex == 2);
        assertTrue(lastImageIndex == 20);
    }
}
